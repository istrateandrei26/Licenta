using ChatService.DTOs;
using ChatService.Models;
using System.Security.Cryptography.X509Certificates;

namespace ChatService.Services.Chat
{
    public interface IMessageService
    {
        public Task<Message> GetMessageById(int messageId);
        public Task<IEnumerable<LastMessage>> getLastMessages(int userId);
        public Task<IEnumerable<MessageObject>> GetMessages(int userId, int conversationId);
        public Task<List<UserObject>> GetConversationPartners(int userId, int conversationId);
        public Task<List<UserObject>> GetConversationMembers(int conversationId);
        public Task<List<FriendRequestObject>> GetFriendRequests(int userId);
        public Task<int> AddMessage(int fromId, int toId, int conversationId, string content, bool isImage, bool isVideo);
        public Task<int> AddFriendRequest(int fromUserId, int toUserId);
        public Task AcceptFriendRequest(int fromUserId, int toUserId);
        public Task<int> CreateConversation(int creatorId, int[] conversationPartners);
        public Task<bool> CheckIfFriendRequestExists(int fromUserId, int toUserId);
        public Task<int> CreateConversationWithFriend(int userId, int friendId);
        public Task UpdateGroupDescription(int groupId, string newDescription);
        public Task UpdateGroupImage(int groupId, List<int> newImageUrl);
        public Task<string> LeaveChatGroup(int groupId, int userId);
        public Task<List<UserObject>> AddUserToChatGroup(List<int> users, int groupId);
        public Task<Message> GetLastMessage(int conversationId);
        public List<UserObject> GetMessageReactions(int messageId);
        public Task ReactToMessage(int userId, int messageId);
        public Task RemoveReactionFromMessage(int userId, int messageId);
        public bool CheckIfUserHasAlreadyReactedToMessage(int userId, int messageId);
        public List<UserObject> RecommendFriends(int userId);
    }
}
