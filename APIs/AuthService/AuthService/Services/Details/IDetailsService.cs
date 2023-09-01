using AuthService.DTOs;

namespace AuthService.Services.Details
{
    public interface IDetailsService
    {
        public LocationObject? getLocationById(int locationId);
        public SportCategoryObject? getSportCategoryById(int sportCategoryId);
        public UserObject? getUserById(int id);
        public IEnumerable<EventObjectAndRatingAverage> getRatingForEachOfMyEvents(int userId);
        public EventObject? getEventDetails(int eventId);
        public IEnumerable<UserObject?> getEventMembers(int eventId);
        
    }
}
