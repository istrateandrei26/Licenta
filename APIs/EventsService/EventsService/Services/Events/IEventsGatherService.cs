using EventsService.DTOs;
using System.Diagnostics.Contracts;

namespace EventsService.Services.Events
{
    public interface IEventsGatherService
    {
        public Task<IEnumerable<EventObject>> getAllEvents();
        public Task<IEnumerable<SportCategoryObject>> getAllCategories();
        public Task<EventObject?> getEventDetailsAsync(int eventId);
        public EventObject? getEventDetails(int eventId);
        public Task addMemberToEvent(int userId, int eventId);
        public Task removeMemberFromEvent(int memberId, int eventId);
        public Task<int> createEvent(int sportCategoryId, int LocationId, int creatorId, int requiredMembers, List<int> allMembers, DateTime startDatetime, double duration, bool createNewLocation, double lat, double lng, string city, string locationName);
        public Task<InvitationObject> getInvitationByEventAndInvitedId(int eventId, int toId);
        public Task<List<InvitationObject>> getEventsInvitations(int userId);
        public Task<IEnumerable<EventReviewInfo>> getEventsWithoutReview(int userId);
        public Task ReviewEventAndHonorMembers(List<int> honoredUsers, int eventId, int ratingScore, int fromId);
        public Task ReviewEvent(int eventId, int ratingScore, int fromId);
        public Task HonorMembers(List<int> honoredUsers, int eventId, int fromId);
        public Task ReviewEventAsIgnored(int eventId, int fromId);
        public Task<bool> AcceptEventInvitation(int invitationId, int userId);
        public bool CheckIfEventIsExpired(int eventId);
        public bool CheckIfEventIsFull(int eventId);
        public Task<bool> CheckIfEventIntersectsWithAnotherEvents(int eventId, int userId);
        public Task AddGoogleCalendarEvent(string googleCalendarEventId, int userId, int eventId);
        public Task RemoveGoogleCalendarEvent(int userId, int eventId);
        public Task<string> GetGoogleCalendarEventId(int eventId, int userId);
        public Task<bool> CheckIfEventCreatorIsBusy(DateTime startDateTime, double duration, int creatorId);
        public Task<List<int>> SendInvitesToUsers(int eventId, List<int> usersToInvite);

        public List<UserObject> RecommendFriends(int userId);

        // unused
        public Task<IEnumerable<RequestedLocationObject>> GetRequestedLocations();
    }
}
