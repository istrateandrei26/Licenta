using AuthService.DTOs;
using AuthService.Models;
using AuthService.Utility;
using System.Text;

namespace AuthService.Services.Details
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
                Coordinates = coord
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

        public EventObject? getEventDetails(int eventId)
        {
            var eventFound = _context.Events.FirstOrDefault(x => x.Id == eventId);

            if (eventFound == null)
                return null;

            var sportCategory = getSportCategoryById(eventFound.SportCategory);
            var eventLocation = getLocationById(eventFound.LocationId);
            var eventCreator = getUserById(eventFound.CreatorId);

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

        public IEnumerable<EventObjectAndRatingAverage> getRatingForEachOfMyEvents(int userId)
        {
            var events = (
                from ev in _context.RatedEvents
                join allEv in _context.Events
                on ev.EventId equals allEv.Id
                where allEv.CreatorId == userId && DateTime.Now > allEv.StartDatetime.AddMinutes(allEv.Duration) && ev.Rating != null
                group ev by ev.EventId into g
                select new
                {
                    eventId = g.Key,
                    averageRating = g.Average(e => e.Rating)
                })
                .ToList()
                .Select(x => new EventObjectAndRatingAverage
                {
                    Event = getEventDetails(x.eventId)!,
                    RatingAverage = x.averageRating,
                    Members = getEventMembers(x.eventId)!,
                })
                .ToList();

            var allEventsCreatedByUser = _context.Events.Where(x => x.CreatorId == userId).ToList().Select(x => x.Id).ToList();

            foreach (var ev in allEventsCreatedByUser)
            {
                var foundEvent = events.Find(x => x.Event.Id == ev);
                if (foundEvent == null)
                    events.Add(new EventObjectAndRatingAverage
                    {
                        Event = getEventDetails(ev)!,
                        RatingAverage = 0.0,
                        Members = getEventMembers(ev)!,
                    });
            }

            return events;


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
                );


             return eventMembers.ToList().Select(x => new UserObject
                {
                    Id = x.user.Id,
                    Email = x.user.Email,
                    Firstname = x.user.Firstname,
                    Lastname = x.user.Lastname,
                    Username = x.Username,
                    ProfileImage = x.user.ProfileImage != null ? x.user.ProfileImage!.Select(x => (int)x).ToList() : null
                })
                .ToList();

        }

        
    }
}
