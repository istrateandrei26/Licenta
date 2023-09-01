using ChatService.DTOs;
using ChatService.Models;

namespace ChatService.Services.Details
{
    public interface IDetailsService
    {
        public UserObject? getUserById(int id);
        public ConversationObject? getConversationById(int conversationId);
        public int GetNumberOfFriends(int userId);
        public int getFriendRequestId(int fromUser, int toUser);
        public SportCategoryObject? getSportCategoryById(int sportCategoryId);
        public IEnumerable<UserObject> GetUserFriends(int userId);
    }
}
