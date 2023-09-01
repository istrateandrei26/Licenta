using ChatService.DTOs;
using ChatService.Models;
using ChatService.Services.Details;
using ChatService.Services.User;
using Microsoft.EntityFrameworkCore;
using Microsoft.VisualBasic;
using System.Xml;

namespace ChatService.Services.Chat
{
    public class MessageService : IMessageService
    {
        private SportNetContext _context;
        IDetailsService _detailsService;
        IUserService _userService;

        public MessageService(SportNetContext context, IDetailsService detailsService, IUserService userService)
        {
            _context = context;
            _detailsService = detailsService;
            _userService = userService;
        }

        public async Task<Message> GetMessageById(int messageId)
        {
            var message = await _context.Messages.FirstAsync(x => x.Id == messageId);

            return message;
        }

        public async Task<IEnumerable<LastMessage>> getLastMessages(int userId)         // pay attention here when modify Friendship table(maybe add a trigger there) => Bob is friend with Alice, then Alice is friend with Bob too!!
        {
            var conversations = await _userService.getUserConversations(userId);

            var lastMessages = new List<LastMessage>();


            foreach (var conversation in conversations)
            {

                var lastMessage = await _context.Messages.Where(x => x.ConversationId == conversation.Id)
                    .OrderByDescending(x => x.Datetime)
                    .FirstOrDefaultAsync();


                var conversationPartners = await GetConversationPartners(userId, conversation.Id);

                if(lastMessage != null)
                {
                    lastMessages.Add(new LastMessage
                    {
                        FromUser = lastMessage.FromUser,
                        UserId = userId,
                        Content = lastMessage.Content,
                        Datetime = lastMessage.Datetime,
                        Id = lastMessage.Id,
                        userDetails = conversationPartners,
                        ConversationId = lastMessage.ConversationId,
                        isImage = lastMessage.IsImage,
                        isVideo = lastMessage.IsVideo,
                        ConversationDescription = conversation.Description,
                        GroupImage = conversation.GroupImage,
                        IsGroup = conversation.IsGroup,
                        FromUserDetails = _detailsService.getUserById(lastMessage.FromUser)!
                    });
                }


            }

            return lastMessages.OrderByDescending(x => x.Datetime);
        }

        public async Task<IEnumerable<MessageObject>> GetMessages(int userId, int conversationId)
        {
            var conversation = await _context.ConversationMembers.Where(x => x.UserId == userId && x.ConversationId == conversationId)
                .FirstOrDefaultAsync();

            var messagesFound = await _context.Messages.Where(x => x.ConversationId == conversation!.ConversationId)
                .OrderBy(x => x.Datetime)
                .ToListAsync();

            
            var messages = messagesFound.Select(message =>new MessageObject
            {
                Id = message.Id,
                Content = message.Content,
                FromUser = message.FromUser,
                ToUser = message.ToUser,
                Datetime = message.Datetime,
                ConversationId = conversation!.ConversationId,
                isImage = message.IsImage,
                isVideo = message.IsVideo,
                fromUserDetails = _detailsService.getUserById(message.FromUser),
                UsersWhoReacted = GetMessageReactions(message.Id)
            });

            return messages;

        }

        public async Task<List<UserObject>> GetConversationPartners(int userId, int conversationId)
        {
            var conversationPartnerIds = await
                (
                    from conversation in _context.ConversationMembers
                    where conversation.ConversationId == conversationId && conversation.UserId != userId
                    select conversation.UserId
                ).ToListAsync();


            var conversationPartners = new List<UserObject>();

            foreach(var partnerId in conversationPartnerIds)
            {
                var partner = _detailsService.getUserById(partnerId);
                conversationPartners.Add(partner!);
            }

            return conversationPartners;
        }

        

        public async Task<int> AddMessage(int fromId, int toId, int conversationId, string content, bool isImage, bool isVideo)
        {
            var messageToSend = new Message
            {
                ToUser = toId,
                FromUser = fromId,
                ConversationId = conversationId,
                Content = content,
                Datetime = DateTime.Now,
                IsImage = isImage,
                IsVideo = isVideo
            };

            _context.Messages.Add(messageToSend);
            var result = await _context.SaveChangesAsync();

            var messageId = messageToSend.Id;

            return messageId;
        }

        public async Task<int> AddFriendRequest(int fromUserId, int toUserId)
        {
            var friendRequest = new FriendRequest
            {
                FromUserId = fromUserId,
                ToUserId = toUserId,
                Accepted = false
            };

            await _context.FriendRequests.AddAsync(friendRequest);
            await _context.SaveChangesAsync();



            return friendRequest.Id;

        }

        public async Task AcceptFriendRequest(int fromUserId, int toUserId)
        {
            var friendRequestFound = _context.FriendRequests.First(x => x.FromUserId == fromUserId && x.ToUserId == toUserId);

            friendRequestFound.Accepted = true;

            
            //if Alice is friend with Bob => Bob is friend with Alice too 
            await _context.Friendships.AddAsync(new Friendship
            {
                UserId = fromUserId,
                FriendId = toUserId
            });

            await _context.Friendships.AddAsync(new Friendship
            {
                UserId = toUserId,
                FriendId = fromUserId
            });



            await _context.SaveChangesAsync();


        }

        public async Task<int> CreateConversation(int creatorId, int[] conversationPartners)
        {
            var newConversation = new Conversation
            {
                IsGroup = true
            };
            await _context.Conversations.AddAsync(newConversation);
            await _context.SaveChangesAsync();


            List<string> memberNames = new List<string>(); 

            foreach(var partnerId in conversationPartners)
            {
                //get member name:
                string name = _detailsService.getUserById(partnerId)!.Firstname;
                memberNames.Add(name);

                var newConversationMember = new ConversationMember
                {
                    ConversationId = newConversation.Id,
                    UserId = partnerId,
                    JoinedDatetime = DateTime.Now
                    
                };

                await _context.ConversationMembers.AddAsync(newConversationMember);
                await _context.SaveChangesAsync();
            }
            

            newConversation.Description = string.Join(',', memberNames);
            //newConversation.GroupImage = "group_image.jpg";

            await _context.SaveChangesAsync();

            return newConversation.Id;
        }
        public async Task<int> CreateConversationWithFriend(int userId, int friendId)
        {
            var newConversation = new Conversation
            {
                Description = null,
                IsGroup = false
                
            };
            await _context.Conversations.AddAsync(newConversation);

            await _context.SaveChangesAsync();


            var userConversationMember = new ConversationMember
            {
                ConversationId = newConversation.Id,
                UserId = userId,
                JoinedDatetime = DateTime.Now,
                LeftDatetime = null
            };

            var friendConversationMember = new ConversationMember
            {
                ConversationId = newConversation.Id,
                UserId = friendId,
                JoinedDatetime = DateTime.Now,
                LeftDatetime = null
            };

            await _context.ConversationMembers.AddAsync(userConversationMember);
            await _context.ConversationMembers.AddAsync(friendConversationMember);

            await _context.SaveChangesAsync();

            return newConversation.Id;
        }

        public async Task<List<DTOs.FriendRequestObject>> GetFriendRequests(int userId)
        {
            var friendRequests = await
            (
                from friendReq in _context.FriendRequests
                join user in _context.Users
                on friendReq.FromUserId equals user.Id
                where friendReq.ToUserId == userId
                select new { friendReq, user }
            ).ToListAsync();

            return friendRequests
            .Select(x => new FriendRequestObject
            {
                User = _detailsService.getUserById(x.user.Id)!,
                FriendRequestId = x.friendReq.Id,
                Accepted = x.friendReq.Accepted
            })
            .ToList();


            //return friendRequests;

        }

        public async Task<List<UserObject>> GetConversationMembers(int conversationId)
        {
            var conversationMemberIds = await
                (
                    from conversation in _context.ConversationMembers
                    where conversation.ConversationId == conversationId
                    select conversation.UserId
                ).ToListAsync();


            var conversationMembers = new List<UserObject>();

            foreach (var memberId in conversationMemberIds)
            {
                var partner = _detailsService.getUserById(memberId);
                conversationMembers.Add(partner!);
            }

            return conversationMembers;
        }

        public async Task<bool> CheckIfFriendRequestExists(int fromUserId, int toUserId)
        {
            var friendRequest = await _context.FriendRequests.FirstOrDefaultAsync(x => x.FromUserId == fromUserId && x.ToUserId == toUserId);

            if(friendRequest == null)
            {
                return false;
            }

            return true;

        }

        public async Task UpdateGroupDescription(int groupId, string newDescription)
        {
            var conversationFound = await _context.Conversations.FirstAsync(x => x.Id == groupId);

            conversationFound.Description = newDescription;

            _context.SaveChanges();
        }


        public async Task UpdateGroupImage(int groupId, List<int> newImageContent)
        {
            var conversationFound = await _context.Conversations.FirstAsync(x => x.Id == groupId);

            conversationFound.GroupImage = newImageContent.Select(i => (byte)i).ToArray();

            _context.SaveChanges();
        }

        public async Task<string> LeaveChatGroup(int groupId, int userId)
        {
            var membership = await _context.ConversationMembers.FirstAsync(x => x.ConversationId == groupId);

            _context.ConversationMembers.Remove(membership);

            _context.SaveChanges();

            var userWhoLeaves = _detailsService.getUserById(userId)!.Firstname;
            var groupName = _detailsService.getConversationById(groupId)!.Description!;


            if(groupName.Contains(','))
            {
                var names = groupName.Split(',').ToList();
                names.Remove(userWhoLeaves);

                groupName = string.Join(',', names);
            }


            return groupName;
        }

        public async Task<List<UserObject>> AddUserToChatGroup(List<int> users, int groupId)
        {
            var group = _detailsService.getConversationById(groupId)!;
            var groupName = group.Description!;
            List<string> names = new List<string>();
            if (groupName.Contains(','))
            {
                names = groupName.Split(',').ToList();
            }

            foreach (var userId in users)
            {
                
                if(!_context.ConversationMembers.Any(x => x.UserId == userId && x.ConversationId == groupId))
                {
                    var userToAddName = _detailsService.getUserById(userId)!.Firstname;
                    var membership = new ConversationMember
                    {
                        UserId = userId,
                        ConversationId = group.Id,
                        JoinedDatetime = DateTime.Now,
                    };

                    _context.ConversationMembers.Add(membership);

                    names.Add(userToAddName);
                    
                }
            }

            if(groupName.Contains(','))
            {
                groupName = string.Join(',', names);
                _context.Conversations.First(x => x.Id == groupId).Description = groupName;
                
            }

            await _context.SaveChangesAsync();

            var newGroupMembersList = await GetConversationMembers(groupId);

            return newGroupMembersList;
        }

        public async Task<Message> GetLastMessage(int conversationId)
        {
            var lastMessage = await _context.Messages.Where(x => x.ConversationId == conversationId)
                   .OrderByDescending(x => x.Datetime)
                   .FirstOrDefaultAsync();

            return lastMessage!;

        }

        public  List<UserObject> GetMessageReactions(int messageId)
        {
            var messageHasReactions = _context.MessageReactions.Any(x => x.MessageId == messageId);

            if(!messageHasReactions) return new List<UserObject>();

            var idsWhoReacted = (
                from reactions in _context.MessageReactions
                where reactions.MessageId == messageId
                select reactions.UserId
            ).ToList();

            var usersWhoReacted = idsWhoReacted.Select(x => _detailsService.getUserById(x)!).ToList();


            return usersWhoReacted;

        }

        public async Task ReactToMessage(int userId, int messageId)
        {
            
            var newReaction = new MessageReaction
            {
                UserId = userId,
                MessageId = messageId
            };

            await _context.MessageReactions.AddAsync(newReaction);
            await _context.SaveChangesAsync();

        }

        public bool CheckIfUserHasAlreadyReactedToMessage(int userId, int messageId)
        {
            // check if user has already reacted to same message before => if not, add new reaction :
            var userHasAlreadyReacted = _context.MessageReactions.Any(x => x.UserId == userId && x.MessageId == messageId);

            return userHasAlreadyReacted;
        }

        public async Task RemoveReactionFromMessage(int userId, int messageId)
        {
            var reaction = _context.MessageReactions.First(x => x.UserId == userId && x.MessageId == messageId);

            _context.MessageReactions.Remove(reaction);
            await _context.SaveChangesAsync();
        }

        public List<UserObject> RecommendFriends(int userId)
        {
            int topN = 30;


            var users = _context.Users
                 .Select(u => new { UserId = u.Id, u.Firstname, u.Lastname })
                 .ToList();

            var events = _context.Events
                .Select(e => new { EventId = e.Id, e.SportCategory, e.LocationId })
                .ToList();

            var eventMembers = _context.EventMembers
                .Select(em => new { em.EventId, em.MemberId })
                .ToList();

            var locations = _context.Locations
                .Select(l => new { LocationId = l.Id, l.City })
                .ToList();

            var merged = from user in users
                         join member in eventMembers on user.UserId equals member.MemberId
                         join ev in events on member.EventId equals ev.EventId
                         join location in locations on ev.LocationId equals location.LocationId
                         select new
                         {
                             user.UserId,
                             user.Firstname,
                             user.Lastname,
                             ev.SportCategory,
                             location.City
                         };

            var userSportsMatrix = merged
                .GroupBy(m => m.UserId)
                .Select(g => new
                {
                    UserId = g.Key,
                    Sports = g.GroupBy(m => m.SportCategory + "_" + m.City)
                              .ToDictionary(g2 => g2.Key, g2 => g2.Count())
                })
                .ToList();

            var sportsList = userSportsMatrix
                .SelectMany(m => m.Sports.Keys)
                .Distinct()
                .ToList();

            var userSimilarityMatrix = new double[userSportsMatrix.Count, userSportsMatrix.Count];
            var userIds = new Dictionary<int, int>();
            int index = 0;

            for (int i = 0; i < userSportsMatrix.Count; i++)
            {
                userIds[userSportsMatrix[i].UserId] = index;

                for (int j = i; j < userSportsMatrix.Count; j++)
                {
                    var dict1 = userSportsMatrix[i].Sports;
                    var dict2 = userSportsMatrix[j].Sports;

                    var dotProduct = sportsList
                        .Select(s => dict1.ContainsKey(s) && dict2.ContainsKey(s) ? dict1[s] * dict2[s] : 0)
                        .Sum();

                    var magnitude1 = Math.Sqrt(dict1.Values.Sum(v => v * v));
                    var magnitude2 = Math.Sqrt(dict2.Values.Sum(v => v * v));

                    var similarity = dotProduct / (magnitude1 * magnitude2);

                    userSimilarityMatrix[index, index] = 1.0;
                    userSimilarityMatrix[index, j] = similarity;
                    userSimilarityMatrix[j, index] = similarity;
                }
                index++;
            }

            int userIndex = userIds[userId];

            var similarUsers = Enumerable.Range(0, userSimilarityMatrix.GetLength(0))
                .Where(i => i != userIndex)
                .OrderByDescending(i => userSimilarityMatrix[userIndex, i])
                .Take(topN)
                .ToList();

            var similarUserIds = similarUsers
                .Select(i => userSportsMatrix[i].UserId)
                .ToList();


            var userFriends = _detailsService.GetUserFriends(userId);

            //if (userFriends.Count() == 0) return new List<UserObject>();

            var attendedEvents = (
                    from E in _context.Events
                    join EM in _context.EventMembers
                    on E.Id equals EM.EventId
                    where EM.MemberId == userId && DateTime.Now > E.StartDatetime.AddMinutes(E.Duration)
                    select E
                )
                .ToList();
            if (attendedEvents.Count == 0) return new List<UserObject>();

            Console.WriteLine($"Similar users to user {userId}: {string.Join(", ", similarUserIds)}");


            List<int> recommendations = similarUserIds
                .Except(userFriends.Select(x => x.Id))
                .ToList();


            return recommendations
                .Select(x => _detailsService.getUserById(x)!)
                .ToList();


        }
    }
}
