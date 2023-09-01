using EventsService.DTOs;
using EventsService.DTOs.Response;
using EventsService.Models;
using EventsService.Services.Utility;
using Microsoft.EntityFrameworkCore;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace EventsService.Services.Details
{
    public class DetailsService : IDetailsService
    {
        private SportNetContext _context;


        public DetailsService(SportNetContext context)
        {
           _context = context;
        }

        public UserObject? getUserById(int id)
        {
            var userFound = _context.Users.FirstOrDefault(x => x.Id == id);

            if (userFound == null)
                return null;

            return new UserObject
            {
                Id = userFound.Id,
                Email = userFound.Email,
                Lastname = userFound.Lastname,
                Firstname = userFound.Firstname,
                Username = _context.UsersCredentials.FirstOrDefault(x => x.UserId == id)!.Username,
                ProfileImage = userFound.ProfileImage != null ? userFound.ProfileImage!.Select(x => (int)x).ToList() : null
            };

        }

        public LocationObject? getLocationById(int locationId)
        {
            var locationFound = _context.Locations.FirstOrDefault(x => x.Id == locationId);


            if (locationFound == null)
                return null;

            var coordinates = _context.LocationCoordinates.FirstOrDefault(x => x.Id == locationFound!.CoordinatesId);

            if (coordinates == null)
                return null;

            var coord = new CoordinatesObject
            {
                Id = coordinates.Id,
                Latitude = coordinates.Latitude,
                Longitude = coordinates.Longitude
            };

            return new LocationObject
            {
                Id = locationFound!.Id,
                City = locationFound.City,
                LocationName = locationFound.LocationName,
                Coordinates = coord,
                MapChosen = locationFound.MapChosen
            };
        }

        public SportCategoryObject? getSportCategoryById(int sportCategoryId)
        {
            var sportCategoryFound = _context.SportCategories.FirstOrDefault(x => x.Id == sportCategoryId);

            if (sportCategoryFound == null)
                return null;



            return new SportCategoryObject
            {
                Id = sportCategoryFound.Id,
                Name = sportCategoryFound.Name,
                Image = sportCategoryFound.Image!
            };
        }

        public IEnumerable<UserObject?> getEventMembers(int eventId)
        {
            var eventMembers =
                (
                    from membership in _context.EventMembers
                    join user in _context.Users
                        on membership.MemberId equals user.Id
                    join userCredential in _context.UsersCredentials
                        on user.Id equals userCredential.UserId
                    where membership.EventId == eventId
                    select new { user, userCredential.Username }
                )
                .Select(x => new UserObject
                {
                    Id = x.user.Id,
                    Email = x.user.Email,
                    Firstname = x.user.Firstname,
                    Lastname = x.user.Lastname,
                    Username = x.Username,
                    ProfileImage = new List<int>() { }
                })
                .ToList();

            foreach(var member in eventMembers)
            {
                member.ProfileImage = getUserById(member.Id)?.ProfileImage;
            }


            return eventMembers;
        }

        public async Task<IEnumerable<UserObject?>> getEventMembersAsync(int eventId)
        {
            var eventMembers = await
                (
                    from membership in _context.EventMembers
                    join user in _context.Users
                        on membership.MemberId equals user.Id
                    join userCredential in _context.UsersCredentials
                        on user.Id equals userCredential.UserId
                    where membership.EventId == eventId
                    select new {user, userCredential.Username}
                )
                .Select(x => new UserObject
                {
                    Id = x.user.Id,
                    Email = x.user.Email,
                    Firstname = x.user.Firstname,
                    Lastname = x.user.Lastname,
                    Username = x.Username,
                    ProfileImage = new List<int>() { }
                })
                .ToListAsync();

            foreach (var member in eventMembers)
            {
                var memberProfileImage = getUserById(member.Id)!.ProfileImage;
                member.ProfileImage = memberProfileImage != null ? memberProfileImage.Select(x => (int)x).ToList() : null;
            }



            return eventMembers;
        }

        public async Task<IEnumerable<SportCategoryObject>> getAllSportCategories()
        {
            var categories = await _context.SportCategories
                .OrderBy(x => x.Name)
                .Select(x => new SportCategoryObject
                {
                    Id = x.Id,
                    Name = x.Name,
                    Image = x.Image!
                })
                .ToListAsync();


            return categories;
        }


        public async Task<List<UserObject>> getEventPartners(int userId, int eventId)
        {
            var eventMembers = await (
                from Event in _context.EventMembers
                join user in _context.Users
                on Event.MemberId equals user.Id
                join userCredential in _context.UsersCredentials
                on user.Id equals userCredential.UserId
                where Event.EventId == eventId && Event.MemberId != userId
                select new { user, userCredential.Username}
            )
            .Select(x => new UserObject
            {
                Id = x.user.Id,
                Email = x.user.Email,
                Firstname = x.user.Firstname,
                Lastname = x.user.Lastname,
                Username = x.Username,
                ProfileImage = new List<int>() { }

            })
            .ToListAsync();

            foreach (var member in eventMembers)
            {
                member.ProfileImage = getUserById(member.Id)!.ProfileImage;
            }


            return eventMembers;

        }

        public async Task<List<LocationObject>> getLocationsBySportCategoryId(int sportCategoryId)
        {
            var locations = await
            (
                from locationSportCategory in _context.LocationsSportCategories
                join location in _context.Locations
                on locationSportCategory.LocationId equals location.Id
                join category in _context.SportCategories
                on locationSportCategory.SportCategoryId equals category.Id
                join coordinate in _context.LocationCoordinates
                on location.CoordinatesId equals coordinate.Id
                where category.Id == sportCategoryId
                select new { location, coordinate }
            )
            .Select(x => new LocationObject
            {
                Id = x.location.Id,
                City = x.location.City,
                LocationName = x.location.LocationName,
                Coordinates = new CoordinatesObject
                {
                    Id = x.coordinate.Id,
                    Latitude = x.coordinate.Latitude,
                    Longitude = x.coordinate.Longitude,
                },
                MapChosen = x.location.MapChosen
            })
            .ToListAsync();

            return locations;

        }

        public (List<int>, bool) EventExistsInLocation(int sportCategoryId, int locationId)
        {

            var eventsFound = _context.Events.Where(x => x.SportCategory == sportCategoryId && x.LocationId == locationId).ToList();

            if (eventsFound != null)
                return (eventsFound.Select(x => x.Id).ToList(), true);
                
            
            return (new List<int>(), false);        // return empty list and flag

        }

        public async Task<bool> EventExistsAroundSameTime(DateTime startDatetimeA, double duration, int eventId)
        {
            var startDateTimeB = (await _context.Events.FirstAsync(x => x.Id == eventId)).StartDatetime;
            var durationB = (await _context.Events.FirstAsync(x => x.Id == eventId)).Duration;
            var endDateTimeB = startDateTimeB.AddMinutes(durationB);
            var endDateTimeA = startDatetimeA.AddMinutes(duration);


            var maxStartDateTime = DateTime.Compare(startDatetimeA, startDateTimeB) > 0 ? startDatetimeA : startDateTimeB;

            var minEndDateTime = DateTime.Compare(endDateTimeA, endDateTimeB) < 0 ? endDateTimeA : endDateTimeB;




            var dateRangesOverlap = DateTime.Compare(maxStartDateTime, minEndDateTime);
            if(dateRangesOverlap == 0)
                return false;

            if (dateRangesOverlap < 0)
                return true;

            return false;

        }

        public IEnumerable<EventObject> getUsersAttendedEvents(int userId)
        {
            var attendedEvents = (
                    from ev in _context.Events
                    join evMemb in _context.EventMembers
                    on ev.Id equals evMemb.EventId
                    where evMemb.MemberId == userId && ev.StartDatetime.AddMinutes(ev.Duration) < DateTime.Now
                    select ev
                )
                .ToList()
                .Select(Event => new EventObject
                {
                    Id = Event.Id,
                    StartDateTime = Event.StartDatetime,
                    Duration = Event.Duration,
                    SportCategory = getSportCategoryById(Event.SportCategory),
                    Location = getLocationById(Event.LocationId),
                    Creator = getUserById(Event.CreatorId),
                    RequiredMembersTotal = Event.RequiredMembersTotal
                });
            return attendedEvents;
        }

        public double getAverageRatingForEvent(int eventId)
        {
            var avg = _context.RatedEvents
            .Where(x => x.EventId == eventId && x.Rating != null)
            .Average(x => x.Rating);



            return avg == null ? 0.0 : ((double)avg);
        }

        public IEnumerable<AttendedCategory> GetAttendedCategories(int userId)
        {
            var attendedCategoriesWithHonor = (
                    from honor in _context.Honors
                    join ev in _context.Events
                    on honor.EventId equals ev.Id
                    join cat in _context.SportCategories
                    on ev.SportCategory equals cat.Id
                    where honor.ToId == userId
                    group cat by cat.Id into g
                    select new
                    {
                        SportCategoryId = g.Key,
                        Honors = g.Count()
                    }
                )
                .ToList()
                .Select(x => new AttendedCategory
                {
                    SportCategory = getSportCategoryById(x.SportCategoryId)!,
                    Honors = x.Honors
                })
                .ToList();

            var attendedCategories = (
                from E in _context.Events
                join EM in _context.EventMembers on E.Id equals EM.EventId
                join SP in _context.SportCategories on E.SportCategory equals SP.Id
                join U in _context.Users on EM.MemberId equals U.Id
                where U.Id == 34
                group SP by SP.Id into g
                select g.Key
            ).ToList();


            foreach (var attendedCat in attendedCategories)
            {
                var foundCategory = attendedCategoriesWithHonor.Find(x => x.SportCategory.Id == attendedCat);
                if (foundCategory == null)
                    attendedCategoriesWithHonor.Add(new AttendedCategory
                    {
                        SportCategory = getSportCategoryById(attendedCat)!,
                        Honors = 0
                    });
            }


            return attendedCategoriesWithHonor;
        }

        public AttendedCategory GetAttendedCategory(int userId, int eventId)
        {
            var foundEvent = _context.Events.Where(x => x.Id == eventId).First();
            var sportCategory = getSportCategoryById(foundEvent.SportCategory)!;
            var honors = _context.Honors.Count(x => x.ToId == userId);

            return new AttendedCategory
            {
                SportCategory = sportCategory,
                Honors = honors
            };

        }

        public Event getEventByInvitationId(int invitationId)
        {
            var eventFound = (
                    from ev in _context.Events
                    join inv in _context.Invitations
                    on ev.Id equals inv.EventId
                    where inv.Id == invitationId
                    select ev
                )
                .First();

            return eventFound;
        }

        public void deleteInvitationToEvent(int toId, int eventId)
        {
            var invitation = _context.Invitations.FirstOrDefault(x => x.ToId == toId && x.EventId == eventId);

            if(invitation != null && !invitation.Accepted)
            {
                invitation.Accepted = true;
                _context.SaveChanges();
            }


        }

        public async Task<IEnumerable<AttendedLocation>> GetAttendedLocations(int userId)
        {
            var result = await (
                from e in _context.Events
                join em in _context.EventMembers on e.Id equals em.EventId
                join sp in _context.SportCategories on e.SportCategory equals sp.Id
                join l in _context.Locations on e.LocationId equals l.Id
                join lc in _context.LocationCoordinates on l.CoordinatesId equals lc.Id
                where em.MemberId == userId
                group new { l, sp , e} by l.Id into g
                select new
                {
                    LocationId = g.Max(x => x.l.Id),
                    SportCategoryId = g.Max(x => x.sp.Id),
                    AttendedDatetime = g.Max(x => x.e.StartDatetime)
                }
            ).ToListAsync();


            var attendedLocations = result
                .Select(x => new AttendedLocation
                {
                    Location = getLocationById(x.LocationId)!,
                    SportCategory = getSportCategoryById(x.SportCategoryId)!,
                    AttendedDatetime = x.AttendedDatetime
                });

            var sortedAttendedLocations = attendedLocations
                .OrderByDescending(x => x.AttendedDatetime);


            return sortedAttendedLocations;

        }

        public async Task<int> CreateNewLocation(double latitude, double longitude, string city, string locationName, int sportCategoryId, bool mapChosen)
        {

            // create link between location and coordinates
            var coordinates = new LocationCoordinate
            {
                Latitude = Convert.ToDecimal(latitude),
                Longitude = Convert.ToDecimal(longitude)
            };

            _context.LocationCoordinates.Add(coordinates);

            await _context.SaveChangesAsync();

            var coordinatesId = coordinates.Id;

            var location = new Location
            {
                City = city,
                LocationName = locationName,
                CoordinatesId = coordinatesId,
                MapChosen = mapChosen
            };

            _context.Locations.Add(location);

            await _context.SaveChangesAsync();

            var locationId = location.Id;

            var locationSportCategory = new LocationsSportCategory
            {
                LocationId = locationId,
                SportCategoryId = sportCategoryId
            };

            _context.LocationsSportCategories.Add(locationSportCategory);

            await _context.SaveChangesAsync();

            return location.Id;
        }

        public async Task<IEnumerable<UserObject>> GetUserFriendsAsync(int userId)
        {
            var friendships = await _context.Friendships.Where(x => x.UserId == userId).ToListAsync();

            var result = friendships.Select(x => getUserById(x.FriendId));


            if (result != null)
            {
                return result!;
            }
            else
            {
                return new List<UserObject>();
            }


        }

        public bool CheckInvitationExists(int userId, int eventId)
        {
            var invitationExists = _context.Invitations.Any(x => x.ToId == userId && x.EventId == eventId);

            return invitationExists;
        }

        public bool CheckUserIsMember(int userId, int eventId)
        {
            var userIsMember = _context.EventMembers.Any(x => x.MemberId == userId && x.EventId == eventId);

            return userIsMember;
        }

        public async Task<bool> AddNewLocationRequest(double latitude, double longitude, string city, string locationName, string ownerEmail, int sportCategoryId)
        {
            using (var transaction = _context.Database.BeginTransaction())
            {

                try
                {
                    var locationRequest = new RequestedLocation
                    {
                        Latitude = Convert.ToDecimal(latitude),
                        Longitude = Convert.ToDecimal(longitude),
                        City = city,
                        LocationName = locationName,
                        OwnerEmail = ownerEmail,
                        Approved = false,
                        SportCategoryId = sportCategoryId
                    };

                    await _context.RequestedLocations.AddAsync(locationRequest);
                    await _context.SaveChangesAsync();

                    var requestedLocationId = locationRequest.Id;

                    var paymentDetails = new PaymentDetail
                    {
                        RequestedLocationId = requestedLocationId,
                        Paid = false
                    };

                    await _context.PaymentDetails.AddAsync(paymentDetails);
                    await _context.SaveChangesAsync();

                    transaction.Commit();

                    return true;
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    Console.WriteLine(ex.Message);
                    return false;
                }

            }


        }

        public async Task ConfirmNewLocationPayment(int approvedLocationId)
        {
            using (var transaction = _context.Database.BeginTransaction())
            {
                try
                {
                    var paymentDetails = (
                        from paymentDet in _context.PaymentDetails
                        join locReq in _context.RequestedLocations
                        on paymentDet.RequestedLocationId equals locReq.Id
                        where locReq.Id == approvedLocationId
                        select paymentDet
                    ).First();

                    paymentDetails.Paid = true;

                    await _context.SaveChangesAsync();

                    var requestedLocation = _context.RequestedLocations.First(x => x.Id == approvedLocationId);

                    await CreateNewLocation(Decimal.ToDouble(requestedLocation.Latitude), Decimal.ToDouble(requestedLocation.Longitude), requestedLocation.City, requestedLocation.LocationName, requestedLocation.SportCategoryId, false);

                    transaction.Commit();

                }
                catch (Exception e)
                {
                    transaction.Rollback();
                    Console.WriteLine(e.Message);
                }
            }
        }

        public async Task<GetNewRequestedLocationInfoForPaymentResponse> GetRequestedLocationInfoForPayment(string verificationCode)
        {
            var verificationCodeDatabaseStored = SecurityHelper.ComputeHash(Encoding.ASCII.GetBytes(verificationCode));

            var foundPaymentReq = _context.PaymentDetails.Any(x => x.VerificationCode!.SequenceEqual(verificationCodeDatabaseStored));
            if (!foundPaymentReq) return new GetNewRequestedLocationInfoForPaymentResponse
            {
                Found = false,
                AlreadyUsed = false
            };

            var paymentDetails = _context.PaymentDetails.First(x => x.VerificationCode!.SequenceEqual(verificationCodeDatabaseStored));

            if (paymentDetails.Paid) return new GetNewRequestedLocationInfoForPaymentResponse
            {
                //already used
                Found = true,
                AlreadyUsed = true
            };


            var requestedLocation = await (
                from paymentRec in _context.PaymentDetails
                join reqLoc in _context.RequestedLocations
                on paymentRec.RequestedLocationId equals reqLoc.Id
                where paymentRec.VerificationCode!.SequenceEqual(verificationCodeDatabaseStored)
                select reqLoc
            ).FirstAsync();


            

            var response = new GetNewRequestedLocationInfoForPaymentResponse
            {
                LocationName = requestedLocation.LocationName,
                City = requestedLocation.City,
                SportCategory = getSportCategoryById(requestedLocation.SportCategoryId)!,
                Coordinates = new CoordinatesObject
                {
                    Id = -1,
                    Latitude = requestedLocation.Latitude,
                    Longitude = requestedLocation.Longitude
                },
                ApprovedLocationId = requestedLocation.Id,
                OwnerEmail = requestedLocation.OwnerEmail,
                Found = true,
                AlreadyUsed = false
            };

            return response;
        }

        public async Task<int> getSportCategoryOfEvent(int eventId)
        {
            var eventFound = await _context.Events.FirstAsync(x => x.Id == eventId);


            return eventFound.SportCategory;
        }

        public IEnumerable<UserObject> GetUserFriends(int userId)
        {
            var userFriendships = _context.Friendships.Where(x => x.UserId == userId).ToList();

            if(userFriendships == null) return new List<UserObject>();

            var userFriendsIds = userFriendships.Select(x => x.FriendId).ToList();

            var userFriends = userFriendsIds.Select(x => getUserById(x)).ToList();

            return userFriends;

        }
    }
}
