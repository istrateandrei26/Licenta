using EventsService.DTOs;
using EventsService.Models;
using EventsService.Services.Details;
using Itenso.TimePeriod;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration.UserSecrets;
using Microsoft.Extensions.Logging;
using Microsoft.Owin.Security.Provider;
using System;

namespace EventsService.Services.Events
{
    public class EventsGatherService : IEventsGatherService
    {

        private SportNetContext _context;
        private IDetailsService _detailsService;

        public EventsGatherService(SportNetContext context, IDetailsService detailsService)
        {
            _context = context;
            _detailsService = detailsService;
        }


        public async Task<IEnumerable<EventObject>> getAllEvents()
        {
            var eventsFound = await _context.Events.Where(x => x.StartDatetime > DateTime.Now).ToListAsync();

            var events = eventsFound.Select(Event => new EventObject
            {
                Id = Event.Id,
                StartDateTime = Event.StartDatetime,
                Duration = Event.Duration,
                SportCategory = _detailsService.getSportCategoryById(Event.SportCategory),
                Location = _detailsService.getLocationById(Event.LocationId),
                Creator = _detailsService.getUserById(Event.CreatorId),
                RequiredMembersTotal = Event.RequiredMembersTotal
            });
              

            return events;

        }

        public EventObject? getEventDetails(int eventId)
        {
            var eventFound = _context.Events.FirstOrDefault(x => x.Id == eventId);

            if (eventFound == null)
                return null;

            var sportCategory = _detailsService.getSportCategoryById(eventFound.SportCategory);
            var eventLocation = _detailsService.getLocationById(eventFound.LocationId);
            var eventCreator = _detailsService.getUserById(eventFound.CreatorId);

            return new EventObject
            {
                Id = eventFound.Id,
                StartDateTime = eventFound.StartDatetime,
                Duration = eventFound.Duration,
                SportCategory = sportCategory,
                Location = eventLocation,
                Creator = eventCreator,
                RequiredMembersTotal = eventFound.RequiredMembersTotal
            };
        }

        public async Task<EventObject?> getEventDetailsAsync(int eventId)
        {
            var eventFound = await _context.Events.FirstOrDefaultAsync(x => x.Id == eventId);

            if (eventFound == null)
                return null;

            var sportCategory = _detailsService.getSportCategoryById(eventFound.SportCategory);
            var eventLocation = _detailsService.getLocationById(eventFound.LocationId);
            var eventCreator = _detailsService.getUserById(eventFound.CreatorId);

           return new EventObject
            {
                Id = eventFound.Id,
                StartDateTime = eventFound.StartDatetime,
                Duration = eventFound.Duration,
                SportCategory = sportCategory,
                Location = eventLocation,
                Creator = eventCreator,
                RequiredMembersTotal = eventFound.RequiredMembersTotal
            };

        }
        public async Task addMemberToEvent(int userId, int eventId)
        {
            var newMembership = new EventMember { 
                EventId = eventId, 
                MemberId = userId
            };

            await _context.EventMembers.AddAsync(newMembership);
            await _context.SaveChangesAsync();
        }

        public async Task removeMemberFromEvent(int memberId, int eventId)
        {
            var membershipFound = await _context.EventMembers.FirstOrDefaultAsync(x => x.MemberId == memberId && x.EventId == eventId);

            if (membershipFound == null)
                return;

            _context.EventMembers.Remove(membershipFound);
            
            
            await _context.SaveChangesAsync();

        }

        public async Task<IEnumerable<SportCategoryObject>> getAllCategories()
        {
            var categories = await _detailsService.getAllSportCategories();

            return categories;
        }

        public async Task<int> createEvent(int sportCategoryId, int locationId, int creatorId, int requiredMembers, List<int> allMembers, DateTime startDatetime, double duration, bool createNewLocation, double lat, double lng, string city, string locationName)
        {

            var datetime = new DateTime(startDatetime.Year, startDatetime.Month, startDatetime.Day, startDatetime.Hour, startDatetime.Minute, 0, 0);

            bool periodsOverlap;

            int eventLocationId;

            if (createNewLocation)
            {
                eventLocationId = await _detailsService.CreateNewLocation(lat, lng, city, locationName, sportCategoryId, true);
            }
            else
            {
                var location = _detailsService.getLocationById(locationId);
                if(location!.MapChosen)
                {
                    periodsOverlap = false;
                }
                else
                {
                    var (events_ids,  eventExistsInSameLocation) = _detailsService.EventExistsInLocation(sportCategoryId, locationId);

                    if (eventExistsInSameLocation)
                    {
                        foreach (var event_id in events_ids) {
                            periodsOverlap = await _detailsService.EventExistsAroundSameTime(datetime, duration, event_id);

                            if(periodsOverlap)
                                return 0;
                        }
                    }

                }
                eventLocationId = locationId;
            }


            var newEvent = new Event
            {
                StartDatetime = datetime,
                Duration = duration, 
                SportCategory = sportCategoryId,
                LocationId = eventLocationId,
                CreatorId = creatorId,
                RequiredMembersTotal = requiredMembers
            };


            await _context.Events.AddAsync(newEvent);
            await _context.SaveChangesAsync();


            await addMemberToEvent(creatorId, newEvent.Id);    // by default : new created event has only 1 member : the creator



            if (allMembers.Count > 0)
            {
                //Add invitations to users 
                foreach (var member in allMembers.Where(x => x != creatorId))
                {
                    var eventInvitation = new Invitation
                    {
                        FromId = creatorId,
                        EventId = newEvent.Id,
                        ToId = member
                    };

                    await _context.Invitations.AddAsync(eventInvitation);
                    await _context.SaveChangesAsync();
                }
            }

            
            return newEvent.Id;
        }

        public async Task<InvitationObject> getInvitationByEventAndInvitedId(int eventId, int toId)
        {
            var invitation = await _context.Invitations.FirstAsync(x => x.ToId == toId && x.EventId == eventId);

            var fromUser = _detailsService.getUserById((int)invitation.FromId!);
            var toUser = _detailsService.getUserById(invitation.ToId);
            var currentEvent = await getEventDetailsAsync(eventId);

            return new InvitationObject
            {
                Id = invitation.Id,
                FromUser = fromUser,
                ToUser = toUser,
                Event = currentEvent
            };

        }

        public async Task<List<InvitationObject>> getEventsInvitations(int userId)
        {
            var invitations = await _context.Invitations.Where(x => x.ToId == userId).ToListAsync();


            var invitationObjects = new List<InvitationObject>();
            foreach(var invite in invitations)
            {
                var invitation = new InvitationObject
                {
                    Id = invite.Id,
                    FromUser = _detailsService.getUserById((int)invite.FromId!),
                    ToUser = _detailsService.getUserById((int)invite.ToId!),
                    Event = await getEventDetailsAsync(invite.EventId),
                    Accepted = invite.Accepted
                    
                };

                if (invitation.Event!.StartDateTime > DateTime.Now)
                {
                    invitationObjects.Add(invitation);
                }
            }


            return invitationObjects;

        }

        public async Task<IEnumerable<EventReviewInfo>> getEventsWithoutReview(int userId)
        {
            // find the events which user has participated to:
            var attentedEvents = _detailsService.getUsersAttendedEvents(userId);

            // find which are not reviewed by current user
            var notReviewedEvents = new List<EventReviewInfo>();


            foreach (var ev in attentedEvents)
            {
                var foundNotReviewedEvent = await _context.RatedEvents.FirstOrDefaultAsync(x => x.FromId == userId && x.EventId == ev.Id);

                if (foundNotReviewedEvent == null)
                {
                    var notReviewedEventToBeAdded = new EventReviewInfo
                    {
                        Event = getEventDetails(ev.Id)!,
                        Members = _detailsService.getEventMembers(ev.Id)!
                    };

                    notReviewedEvents.Add(notReviewedEventToBeAdded);
                }
            }


            return notReviewedEvents;

        }

        public async Task ReviewEventAndHonorMembers(List<int> honoredUsers, int eventId, int ratingScore, int fromId)
        {
            var newEventReview = new RatedEvent
            {
                EventId = eventId,
                Rating = ratingScore,
                FromId = fromId
            };

            foreach(var userId in honoredUsers)
            {
                var newHonor = new Honor
                {
                    FromId = fromId,
                    ToId = userId,
                    EventId = eventId
                };


                _context.Honors.Add(newHonor);
            }

            _context.RatedEvents.Add(newEventReview);

            await _context.SaveChangesAsync();
        }

        public async Task ReviewEvent(int eventId, int ratingScore, int fromId)
        {
            var newEventReview = new RatedEvent
            {
                EventId = eventId,
                Rating = ratingScore,
                FromId = fromId
            };

            _context.RatedEvents.Add(newEventReview);

            await _context.SaveChangesAsync();
        }

        public async Task HonorMembers(List<int> honoredUsers, int eventId, int fromId)
        {
            foreach (var userId in honoredUsers)
            {
                var newHonor = new Honor
                {
                    FromId = fromId,
                    ToId = userId,
                    EventId = eventId
                };


                _context.Honors.Add(newHonor);
            }


            await _context.SaveChangesAsync();
        }

        public async Task ReviewEventAsIgnored(int eventId, int fromId)
        {
            var newEventReview = new RatedEvent
            {
                EventId = eventId,
                Rating = null,
                FromId = fromId
            };

            _context.RatedEvents.Add(newEventReview);

            await _context.SaveChangesAsync();
        }

        public async Task<bool> AcceptEventInvitation(int invitationId, int userId)
        {
            // check if user has already another event in temporal proximity; the event has to be not expired 

            // find the event corresponding to the invitation:
            var eventToAttend = _detailsService.getEventByInvitationId(invitationId);

            var usersScheduledEvents = (
                    from ev in _context.Events
                    join evMemb in _context.EventMembers
                    on ev.Id equals evMemb.EventId
                    where evMemb.MemberId == userId
                    select ev.Id
                )
                .ToList();


            bool periodsOverlap = false;

            if (usersScheduledEvents.Count != 0)
            {
                foreach (var event_id in usersScheduledEvents)
                {
                    periodsOverlap = await _detailsService.EventExistsAroundSameTime(eventToAttend.StartDatetime, eventToAttend.Duration, event_id);

                    if (periodsOverlap)
                        return true;
                }

            }


            var invitationToAccept = _context.Invitations.Where(x => x.Id == invitationId).First();

            invitationToAccept.Accepted = true;

            await _context.SaveChangesAsync();

            return false;
            
        }

        public async Task<bool> CheckIfEventIntersectsWithAnotherEvents(int eventId, int userId)
        {

            var eventToAttend = getEventDetails(eventId)!;

            var usersScheduledEvents = (
                    from ev in _context.Events
                    join evMemb in _context.EventMembers
                    on ev.Id equals evMemb.EventId
                    where evMemb.MemberId == userId
                    select ev.Id
                )
                .ToList();

            bool periodsOverlap = false;

            if (usersScheduledEvents.Count != 0)
            {
                foreach (var event_id in usersScheduledEvents)
                {
                    periodsOverlap = await _detailsService.EventExistsAroundSameTime(eventToAttend.StartDateTime, eventToAttend.Duration, event_id);

                    if (periodsOverlap)
                        return true;
                }

            }


            return false;

        }

        public async Task<bool> CheckIfEventCreatorIsBusy(DateTime startDateTime, double duration, int creatorId)
        {
            var usersScheduledEvents = (
                    from ev in _context.Events
                    join evMemb in _context.EventMembers
                    on ev.Id equals evMemb.EventId
                    where evMemb.MemberId == creatorId
                    select ev.Id
                )
                .ToList();

            bool periodsOverlap = false;


            if (usersScheduledEvents.Count != 0)
            {
                foreach (var event_id in usersScheduledEvents)
                {
                    periodsOverlap = await _detailsService.EventExistsAroundSameTime(startDateTime, duration, event_id);

                    if (periodsOverlap)
                        return true;
                }

            }


            return false;

        }


        public bool CheckIfEventIsExpired(int eventId)
        {
            var eventFound = _context.Events.First(x => x.Id == eventId);

            return eventFound.StartDatetime < DateTime.Now ? true : false;
        }

        public bool CheckIfEventIsFull(int eventId)
        {
            var numberOfMembers = _context.EventMembers.Where(x => x.EventId == eventId).Count();

            var eventFound = _context.Events.First(x => x.Id == eventId);

            return (numberOfMembers == eventFound.RequiredMembersTotal);
        }

        public async Task AddGoogleCalendarEvent(string googleCalendarEventId, int userId, int eventId)
        {
            var newGoogleCalendarEvent = new GoogleCalendarEvent
            {
                GoogleCalendarEventId = googleCalendarEventId,
                UserId = userId,
                EventId = eventId
            };

            _context.GoogleCalendarEvents.Add(newGoogleCalendarEvent);

            await _context.SaveChangesAsync();
        }

        public async Task RemoveGoogleCalendarEvent(int userId, int eventId)
        {
            var googleCalendarEventFound = await _context.GoogleCalendarEvents.FirstOrDefaultAsync(x => x.UserId == userId && x.EventId == eventId);

            if (googleCalendarEventFound != null)
            {
                _context.GoogleCalendarEvents.Remove(googleCalendarEventFound);
                _context.SaveChanges();
            }

        }

        public async Task<string> GetGoogleCalendarEventId(int eventId, int userId)
        {
            var googleCalendarEventFound = await _context.GoogleCalendarEvents.FirstOrDefaultAsync(x => x.UserId == userId && x.EventId == eventId);

            if(googleCalendarEventFound != null)
            {
                return googleCalendarEventFound.GoogleCalendarEventId;
            }


            return "";
        }

        

        public async Task<List<int>> SendInvitesToUsers(int eventId, List<int> usersToInvite)
        {
            var thoseWhoWereNotMembers = new List<int> { };

            var ev = await getEventDetailsAsync(eventId);

            //Add invitations to users 
            foreach (var member in usersToInvite)
            {

                bool isAlreadyMember = _detailsService.CheckUserIsMember(member, eventId);
                bool isAlreadyInvited = _detailsService.CheckInvitationExists(member, eventId);

                if (isAlreadyMember) { continue; }

                if(isAlreadyInvited)
                {
                    // get invitation and mark it unaccepted
                    var invitation = _context.Invitations.First(x => x.ToId == member && x.EventId == eventId);

                    if (invitation.Accepted)
                    {
                        invitation.Accepted = false;

                        _context.SaveChanges();

                        thoseWhoWereNotMembers.Add(member);

                    }
                    
                    continue;
                }

                thoseWhoWereNotMembers.Add(member);

                var eventInvitation = new Invitation
                {
                    FromId = ev!.Creator!.Id,
                    EventId = ev.Id,
                    ToId = member
                };

                await _context.Invitations.AddAsync(eventInvitation);
                
            }

            if (thoseWhoWereNotMembers.Count != 0)
            {
                await _context.SaveChangesAsync();
            }

            return thoseWhoWereNotMembers;
            
        }

        public async Task<IEnumerable<RequestedLocationObject>> GetRequestedLocations()
        {
            var requestedLocs = await (
                (
                from reqL in _context.RequestedLocations
                select reqL
                ).ToListAsync()
            );

            var result = new List<RequestedLocationObject>();

            foreach(var loc in requestedLocs)
            {
                var category = _detailsService.getSportCategoryById(loc.SportCategoryId);

                var item = new RequestedLocationObject
                {
                    Id = loc.Id,
                    City = loc.City,
                    LocationName = loc.LocationName,
                    OwnerEmail = loc.OwnerEmail,
                    Coordinates = new CoordinatesObject
                    {
                        Latitude = loc.Latitude,
                        Longitude = loc.Longitude
                    },
                    SportCategoryName = category!.Name,
                    SportCategoryId = category!.Id,
                    Approved = loc.Approved
                };

                result.Add(item);
            }


            return result;
        }

        public List<UserObject> RecommendFriends(int userId)
        {
            int topN = 30;
            
            
            var users = _context.Users
                 .Select(u => new { UserId = u.Id, u.Firstname, u.Lastname })
                 .ToList();

            var events = _context.Events
                .Select(e => new { EventId = e.Id, e.SportCategory, e.LocationId })
                .ToList();

            var eventMembers = _context.EventMembers
                .Select(em => new { em.EventId, em.MemberId })
                .ToList();

            var locations = _context.Locations
                .Select(l => new { LocationId = l.Id, l.City })
                .ToList();

            var merged = from user in users
                         join member in eventMembers on user.UserId equals member.MemberId
                         join ev in events on member.EventId equals ev.EventId
                         join location in locations on ev.LocationId equals location.LocationId
                         select new
                         {
                             user.UserId,
                             user.Firstname,
                             user.Lastname,
                             ev.SportCategory,
                             location.City
                         };

            var userSportsMatrix = merged
                .GroupBy(m => m.UserId)
                .Select(g => new
                {
                    UserId = g.Key,
                    Sports = g.GroupBy(m => m.SportCategory + "_" + m.City)
                              .ToDictionary(g2 => g2.Key, g2 => g2.Count())
                })
                .ToList();

            var sportsList = userSportsMatrix
                .SelectMany(m => m.Sports.Keys)
                .Distinct()
                .ToList();

            var userSimilarityMatrix = new double[userSportsMatrix.Count, userSportsMatrix.Count];
            var userIds = new Dictionary<int, int>();
            int index = 0;

            for (int i = 0; i < userSportsMatrix.Count; i++)
            {
                userIds[userSportsMatrix[i].UserId] = index;

                for (int j = i; j < userSportsMatrix.Count; j++)
                {
                    var dict1 = userSportsMatrix[i].Sports;
                    var dict2 = userSportsMatrix[j].Sports;

                    var dotProduct = sportsList
                        .Select(s => dict1.ContainsKey(s) && dict2.ContainsKey(s) ? dict1[s] * dict2[s] : 0)
                        .Sum();

                    var magnitude1 = Math.Sqrt(dict1.Values.Sum(v => v * v));
                    var magnitude2 = Math.Sqrt(dict2.Values.Sum(v => v * v));

                    var similarity = dotProduct / (magnitude1 * magnitude2);

                    userSimilarityMatrix[index, index] = 1.0;
                    userSimilarityMatrix[index, j] = similarity;
                    userSimilarityMatrix[j, index] = similarity;
                }
                index++;
            }

            int userIndex = userIds[userId];

            var similarUsers = Enumerable.Range(0, userSimilarityMatrix.GetLength(0))
                .Where(i => i != userIndex)
                .OrderByDescending(i => userSimilarityMatrix[userIndex, i])
                .Take(topN)
                .ToList();

            var similarUserIds = similarUsers
                .Select(i => userSportsMatrix[i].UserId)
                .ToList();


            var userFriends = _detailsService.GetUserFriends(userId);

            if (userFriends.Count() == 0) return new List<UserObject>();

            Console.WriteLine($"Similar users to user {userId}: {string.Join(", ", similarUserIds)}");


            List<int> recommendations = similarUserIds
                .Except(userFriends.Select(x => x.Id))
                .ToList();

            
            return recommendations
                .Select(x => _detailsService.getUserById(x)!)
                .ToList();
            

        }
    }
}
