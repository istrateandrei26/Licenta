using ChatService.Models;
using ChatService.DTOs;
using Microsoft.EntityFrameworkCore;

namespace ChatService.Services.Details
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


        public ConversationObject? getConversationById(int conversationId)
        {
            var conversationFound = _context.Conversations.FirstOrDefault(x => x.Id == conversationId);

            if (conversationFound == null)
                return null;

            return new ConversationObject
            {
                Id = conversationFound.Id,
                Description = conversationFound.Description,
                GroupImage = conversationFound.GroupImage?.Select((b) => (int)b).ToList(),
                IsGroup = conversationFound.IsGroup
            };
        }

        public int GetNumberOfFriends(int userId)
        {
            return _context.Friendships.Count(x => x.UserId == userId);
        }

        public int getFriendRequestId(int fromUser, int toUser)
        {
            var friendRequestId = _context.FriendRequests.First(x => x.FromUserId == fromUser && x.ToUserId == toUser).Id;

            return friendRequestId;
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

        public IEnumerable<UserObject> GetUserFriends(int userId)
        {
            var userFriendships = _context.Friendships.Where(x => x.UserId == userId).ToList();

            if (userFriendships == null) return new List<UserObject>();

            var userFriendsIds = userFriendships.Select(x => x.FriendId).ToList();

            var userFriends = userFriendsIds.Select(x => getUserById(x)).ToList();

            return userFriends;

        }
    }
}
