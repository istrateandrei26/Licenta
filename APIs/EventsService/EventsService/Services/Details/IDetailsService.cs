using EventsService.DTOs;
using EventsService.DTOs.Response;
using EventsService.Models;

namespace EventsService.Services.Details
{
    public interface IDetailsService
    {
        public UserObject? getUserById(int id);
        public LocationObject? getLocationById(int locationId);
        public SportCategoryObject? getSportCategoryById(int sportCategoryId);
        public Task<IEnumerable<UserObject?>> getEventMembersAsync(int eventId);
        public IEnumerable<UserObject?> getEventMembers(int eventId);
        public Task<IEnumerable<SportCategoryObject>> getAllSportCategories();
        public Task<List<UserObject>> getEventPartners(int userId, int eventId);
        public Task<List<LocationObject>> getLocationsBySportCategoryId(int sportCategoryId);
        public (List<int>, bool) EventExistsInLocation(int sportCategoryId, int locationId);
        public Task<bool> EventExistsAroundSameTime(DateTime startDatetimeA, double duration, int eventId);
        public IEnumerable<EventObject> getUsersAttendedEvents(int userId);
        public double getAverageRatingForEvent(int eventId);
        public IEnumerable<AttendedCategory> GetAttendedCategories(int userId);
        public AttendedCategory GetAttendedCategory(int userId, int eventId);
        public Task<int> getSportCategoryOfEvent(int eventId);
        public Event getEventByInvitationId(int invitationId);
        public void deleteInvitationToEvent(int toId, int eventId);
        public Task<IEnumerable<AttendedLocation>> GetAttendedLocations(int userId); 
        public Task<int> CreateNewLocation(double latitude, double longitude, string city, string locationName, int sportCategoryId, bool mapChosen);
        public Task<IEnumerable<UserObject>> GetUserFriendsAsync(int userId);
        public bool CheckInvitationExists(int userId, int eventId);
        public bool CheckUserIsMember(int userId, int eventId);
        public Task<bool> AddNewLocationRequest(double latitude, double longitude, string city, string locationName, string ownerEmail, int sportCategoryId);
        public Task ConfirmNewLocationPayment(int approvedLocationId);
        public Task<GetNewRequestedLocationInfoForPaymentResponse> GetRequestedLocationInfoForPayment(string verificationCode);
        public IEnumerable<UserObject> GetUserFriends(int userId); 
    }
}
