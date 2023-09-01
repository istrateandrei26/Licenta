
using ChatService.DTOs;

namespace ChatService.Services.User
{
    public interface IUserService
    {
        public Task<IEnumerable<UserObject>> getUserFriends(int userId);
        public Task<IEnumerable<ConversationObject>> getUserConversations(int userId);
        public Task<IEnumerable<AttendedCategory>> getCommonAttendedCategories(int userId1, int userId2);
        public Task<IEnumerable<GroupObject>> getCommonGroups(int userId1, int userId2);
    }
}
