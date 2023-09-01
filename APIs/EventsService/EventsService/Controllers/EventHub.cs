using Microsoft.AspNetCore.SignalR;
using EventsService.Services.Authorization;
using EventsService.Services.Details;
using EventsService.Services.Events;
using EventsService.Models;
using System.Diagnostics.Metrics;
using Newtonsoft.Json;
using EventsService.DTOs;
using EventsService.Services.Notification;

namespace EventsService.Controllers
{
    public class EventHub : Hub
    {
        ContextUser _contextUser;
        IDetailsService _detailsService;
        IEventsGatherService _eventsService;
        INotificationService _notificationService;

        //create links between connections
        private static Dictionary<int, string> _connectionLinks = new Dictionary<int, string>();
    
        public EventHub(ContextUser contextUser, IDetailsService detailsService, IEventsGatherService eventsService, INotificationService notificationService)
        {
            _contextUser = contextUser;
            _detailsService = detailsService;
            _eventsService = eventsService;
            _notificationService = notificationService;
        }



        public async Task SendMessage(string message)
        {
            await Clients.All.SendAsync("Received message", message);
        }


        public async Task NotifyMemberAddedToEvent(int memberId, int eventId)
        {
            var eventPartners = await _detailsService.getEventPartners(memberId, eventId);

            var connectionIds = new List<string>();

            foreach(var partner in eventPartners)
            {
                if(_connectionLinks.ContainsKey(partner.Id))
                {
                    connectionIds.Add(_connectionLinks.GetValueOrDefault(partner.Id)!);
                }
            }


            await _eventsService.addMemberToEvent(memberId, eventId);

            // search invitation to that event and delete it if it exists and is not accepted
            _detailsService.deleteInvitationToEvent(memberId, eventId);

            // get member details to help Frontend add new member to list...
            var memberDetails = _detailsService.getUserById(memberId)!;


            await Clients.Clients(connectionIds).SendAsync("Added Event Member", JsonConvert.SerializeObject(memberDetails), eventId);


            if (_connectionLinks.ContainsKey(memberId))
            {
                await Clients.Clients(new List<string>() { _connectionLinks.GetValueOrDefault(memberId)!}).SendAsync("Member Joined Event", JsonConvert.SerializeObject(memberDetails), eventId);
            }

            var eventDetails = _eventsService.getEventDetails(eventId)!;
            var notificationReceivers = eventPartners
                .Select(x => x.Id)
                .ToList();

            var sportCategoryId = await _detailsService.getSportCategoryOfEvent(eventId);
            var sportCategoryImage = _detailsService.getSportCategoryById(sportCategoryId)!.Image;
            var payload = NotificationPayloadBuilder.BuildPayload(NotificationUtilityInfo.EVENT_DETAILS_SCREEN, new List<int> { eventId }, new List<string>() { sportCategoryImage });
            await _notificationService.SendNotification(notificationReceivers, $"{eventDetails.SportCategory!.Name}, {eventDetails.Location!.City}, {eventDetails.Location.LocationName}", $"{memberDetails.Firstname} {memberDetails.Lastname} joined the event", payload);


        }

        public async Task NotifyMemberQuitedEvent(int memberId, int eventId)
        {
            var eventPartners = await _detailsService.getEventPartners(memberId, eventId);

            var connectionIds = new List<string>();

            foreach (var partner in eventPartners)
            {
                if (_connectionLinks.ContainsKey(partner.Id))
                {
                    connectionIds.Add(_connectionLinks.GetValueOrDefault(partner.Id)!);
                }
            }

            //delete membership...
            await _eventsService.removeMemberFromEvent(memberId, eventId);

            await Clients.Clients(connectionIds).SendAsync("Member Quited Event", memberId, eventId);



            var memberDetails = _detailsService.getUserById(memberId)!;
            var eventDetails = _eventsService.getEventDetails(eventId)!;
            var notificationReceivers = eventPartners
                .Select(x => x.Id)
                .ToList();

            var sportCategoryId = await _detailsService.getSportCategoryOfEvent(eventId);
            var sportCategoryImage = _detailsService.getSportCategoryById(sportCategoryId)!.Image;
            var payload = NotificationPayloadBuilder.BuildPayload(NotificationUtilityInfo.EVENT_DETAILS_SCREEN, new List<int> { eventId }, new List<string>() { sportCategoryImage });
            await _notificationService.SendNotification(notificationReceivers, $"{eventDetails.SportCategory!.Name}, {eventDetails.Location!.City.Trim()}, {eventDetails.Location.LocationName.Trim()}", $"{memberDetails.Firstname} {memberDetails.Lastname} left the event", payload);
        }

        public async Task AddNewEventToFeed(int eventId, List<int> allMembers, int creatorId)
        {
            var invitedMembersIds = _connectionLinks.Values.ToList();

            var connectionIds = _connectionLinks.Values.ToList();

            var ev = await _eventsService.getEventDetailsAsync(eventId);

            await Clients.Clients(connectionIds).SendAsync("Event Added To Feed", JsonConvert.SerializeObject(ev));


            if (allMembers.Count > 0)
            {
                //get event creator
                var eventCreator = (await _eventsService.getEventDetailsAsync(eventId))!.Creator!.Id;

                var invitedUsers = allMembers.Where(x => x != eventCreator).ToList();

                foreach (var invitedUser in invitedUsers)
                {
                    if (_connectionLinks.ContainsKey(invitedUser))
                    {
                        var invitation = await _eventsService.getInvitationByEventAndInvitedId(eventId, invitedUser);
                        //invitedMembersIds.Add(_connectionLinks.GetValueOrDefault(invitedUser)!);
                        await Clients.Clients(connectionIds.Where(x => x == _connectionLinks[invitedUser]).ToList()).SendAsync("Received Event Invitation", JsonConvert.SerializeObject(invitation));
                    }
                    
                    
                }

                var creatorDetails = _detailsService.getUserById(creatorId)!;
                var notificationReceivers = allMembers.Where(x => x != creatorId).ToList();
                await _notificationService.SendNotification(notificationReceivers, $"{ev!.SportCategory!.Name}, {ev.Location!.City.Trim()}, {ev.Location.LocationName.Trim()}", $"{creatorDetails.Firstname} {creatorDetails.Lastname} invited you to join");

            }
        }

        public async Task InviteUsersToEvent(int eventId, List<int> usersToInvite, int whoInvited)
        {
            var connectionIds = _connectionLinks.Values.ToList();

            //send invites to user in database
            var notificationReceivers = await _eventsService.SendInvitesToUsers(eventId, usersToInvite);

            Console.WriteLine(notificationReceivers.ToString);

            foreach (var invitedUser in notificationReceivers)
            {
                //bool isAlreadyMember = _detailsService.CheckUserIsMember(invitedUser, eventId);
                //bool isAlreadyInvited = _detailsService.CheckInvitationExists(invitedUser, eventId);

                //if (isAlreadyInvited || isAlreadyMember) continue;

                if (_connectionLinks.ContainsKey(invitedUser))
                {
                    var invitation = await _eventsService.getInvitationByEventAndInvitedId(eventId, invitedUser);
                    await Clients.Clients(connectionIds.Where(x => x == _connectionLinks[invitedUser]).ToList()).SendAsync("Received Event Invitation", JsonConvert.SerializeObject(invitation));
                }

            }

            var whoInvitedDetails = _detailsService.getUserById(whoInvited)!;
            //var notificationReceivers = usersToInvite;
            var ev = await _eventsService.getEventDetailsAsync(eventId);

            var sportCategoryId = await _detailsService.getSportCategoryOfEvent(eventId);
            var sportCategoryImage = _detailsService.getSportCategoryById(sportCategoryId)!.Image;
            var payload = NotificationPayloadBuilder.BuildPayload(NotificationUtilityInfo.EVENT_DETAILS_SCREEN, new List<int> { eventId }, new List<string>() { sportCategoryImage });
            await _notificationService.SendNotification(notificationReceivers, $"{ev!.SportCategory!.Name}, {ev.Location!.City.Trim()}, {ev.Location.LocationName.Trim()}", $"{whoInvitedDetails.Firstname} {whoInvitedDetails.Lastname} invited you to join", payload);


        }


        public async Task HonorMembers(List<int> honoredUsers, int eventId, int fromId)
        {
            var connectionIds = _connectionLinks.Values.ToList();

            // review event in database:
            await _eventsService.HonorMembers(honoredUsers, eventId, fromId);
           
            
            // build response:
            var fromHonor =  _detailsService.getUserById(fromId)!;
            
            
            foreach (var userId in honoredUsers)
            {
                if (_connectionLinks.ContainsKey(userId))
                {
                    var attendedCategory = _detailsService.GetAttendedCategory(userId, eventId);

                    var content = JsonConvert.SerializeObject(new MembersHonor
                    {
                        FromHonor = fromHonor!,
                        AttendedCategory = attendedCategory
                    });

                    await Clients.Clients(connectionIds.Where(x => x == _connectionLinks[userId]).ToList()).SendAsync("Received Honor", content);   // check in frontend if user is creator to process his event rating etc
                }
            }


            var notificationReceivers = honoredUsers;
            var eventDetails = _eventsService.getEventDetails(eventId);
            await _notificationService.SendNotification(notificationReceivers, "Sport Net", $"{fromHonor.Firstname} {fromHonor.Lastname} honored you from your last {eventDetails!.SportCategory!.Name} performance");

        }

        public async Task ReviewOnlyEvent(int eventId, int ratingScore, int fromId)
        {
            var reviewedEvent = _eventsService.getEventDetails(eventId);
            var creatorId = reviewedEvent!.Creator!.Id;


            var connectionIds = new List<string>();

            if (_connectionLinks.ContainsKey(creatorId))
            {
                connectionIds.Add(_connectionLinks.GetValueOrDefault(creatorId)!);
            }

            // review event in database:
            await _eventsService.ReviewEvent(eventId, ratingScore, fromId);


            // build response
            var fromReview = _detailsService.getUserById(fromId);
            var newAverageRating = _detailsService.getAverageRatingForEvent(eventId);
            var eventMembers = _detailsService.getEventMembers(eventId);

            var eventReviewDetails = new EventObjectAndRatingAverage
            {
                Event = reviewedEvent,
                RatingAverage = newAverageRating,
                Members = eventMembers!
            };
            
            var content = JsonConvert.SerializeObject(new EventReview
            {
                FromReview = fromReview!,
                ReviewedEvent = eventReviewDetails
            });

            await Clients.Clients(connectionIds).SendAsync("Received Event Review Only", content);


            if (creatorId != fromId)
            {
                await _notificationService.SendNotification(new List<int> { creatorId }, "Sport Net", $"{fromReview!.Firstname} {fromReview!.Lastname} rated your event as {ratingScore}/5 from {reviewedEvent.Location!.LocationName}");
            }
        }

        public override Task OnConnectedAsync()
        {
            var userId = _contextUser.requestUser()!.Id;

            if (!_connectionLinks.ContainsKey(userId))
                _connectionLinks.Add(userId, Context.ConnectionId);

            return base.OnConnectedAsync();
        }

        public override Task OnDisconnectedAsync(Exception? exception)
        {
            _connectionLinks.Remove(_contextUser.requestUser()!.Id);

            return base.OnDisconnectedAsync(exception);
        }

    }
}
