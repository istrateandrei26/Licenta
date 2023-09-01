using ChatService.DTOs;
using ChatService.Models;
using ChatService.Services.Authorization;
using ChatService.Services.Chat;
using ChatService.Services.Details;
using ChatService.Services.Notification;
using Microsoft.AspNet.SignalR.Messaging;
using Microsoft.AspNetCore.SignalR;
using Microsoft.VisualBasic;
using Newtonsoft.Json;
using System.Diagnostics.Metrics;
using System.Text.RegularExpressions;

namespace ChatService.Controllers
{
    public class ChatHub : Hub
    {
        IMessageService _messageService;
        IDetailsService _detailsService;
        INotificationService _notificationService;
        ContextUser _contextUser;

        //create links between connections
        private static Dictionary<int, string> _connectionLinks = new Dictionary<int, string>();
        private const int _DEFAULT_TO_USER_ID = 38;
        public ChatHub(ContextUser contextUser, IMessageService messageService, IDetailsService detailsService, INotificationService notificationService)
        {
            _contextUser = contextUser;
            _messageService = messageService;
            _detailsService = detailsService;
            _notificationService = notificationService;
        }


        public async Task SendMessage(string message)
        {
            await Clients.All.SendAsync("Received message", message);
        }

        public async Task SendMessageToConversation(int fromId, int toId, int conversationId, string content, int isImage, int isVideo)
        {
            //var connectionsIdentifiers = _connectionLinks.Where(x => x.Key == toId).Select(x => x.Value).ToList();

            var conversationMembers = await _messageService.GetConversationMembers(conversationId);

            var connectionIds = new List<string>();
            foreach(var member in conversationMembers)
            {
                if(_connectionLinks.ContainsKey(member.Id))
                {
                    connectionIds.Add(_connectionLinks.GetValueOrDefault(member.Id)!);
                }
            }

            var fromUser = _detailsService.getUserById(fromId);
            var conversation = _detailsService.getConversationById(conversationId)!;
            String conversationDescription = conversation.Description!;
            bool isGroup = conversation.IsGroup;


            // write message to database:
            var messageId = await _messageService.AddMessage(fromId, _DEFAULT_TO_USER_ID, conversationId, content, Convert.ToBoolean(isImage), Convert.ToBoolean(isVideo));                              

           
            //send notifications to clients
            await Clients.Clients(connectionIds.ToList()).SendAsync("Received message", fromId, isImage, isVideo, content, JsonConvert.SerializeObject(fromUser), messageId);



            foreach (var member in conversationMembers)
            {
                var lastMessage = new LastMessage
                {
                    FromUser = fromId,
                    UserId = _DEFAULT_TO_USER_ID,
                    Content = content,
                    Datetime = DateTime.Now,
                    Id = messageId,
                    userDetails = await _messageService.GetConversationPartners(member.Id, conversationId),
                    ConversationId = conversationId,
                    isImage = Convert.ToBoolean(isImage),
                    isVideo = Convert.ToBoolean(isVideo),
                    ConversationDescription = conversationDescription,
                    IsGroup = isGroup,
                    FromUserDetails = _detailsService.getUserById(fromId)!
                };
                
                if (_connectionLinks.ContainsKey(member.Id))
                {
                    await Clients.Clients(connectionIds.Where(x => x == _connectionLinks[member.Id]).ToList()).SendAsync("Received message in chat list", JsonConvert.SerializeObject(lastMessage));

                }
            }

            var conversationPartenersIds = conversationMembers
                .Where(x => x.Id != fromId)
                .ToList()
                .Select(x => x.Id)
                .ToList();

            var notificationContent = isImage == 1 ? "Sent a photo." : isVideo == 1 ? "Sent a video." : content;


            var payload = NotificationPayloadBuilder.BuildPayload(NotificationUtilityInfo.CONVERSATION_SCREEN, new List<int> { conversationId }, new List<string>() { });
            await _notificationService.SendNotification(conversationPartenersIds, $"{fromUser!.Firstname} {fromUser!.Lastname}", notificationContent, payload);

        }

        public async Task SendFriendRequest(int fromUserId, int toUserId)
        {
            var connectionIdentifiers = new List<string>();

            if (_connectionLinks.ContainsKey(toUserId))
            {
                connectionIdentifiers.Add(_connectionLinks.GetValueOrDefault(toUserId)!);
            }

            bool friendRequestExists = await _messageService.CheckIfFriendRequestExists(toUserId, fromUserId);

            if (friendRequestExists)
            {

                await _messageService.AcceptFriendRequest(toUserId, fromUserId);

                var conversationId = await _messageService.CreateConversationWithFriend(fromUserId, toUserId);

                var messageId = await _messageService.AddMessage(fromUserId, toUserId, conversationId, "", false, false);

                var lastMessage1 = new LastMessage
                {
                    FromUser = fromUserId,
                    UserId = toUserId,
                    Content = "",
                    Datetime = DateTime.Now,
                    Id = messageId,
                    userDetails = await _messageService.GetConversationPartners(fromUserId, conversationId),
                    ConversationId = conversationId,
                    isImage = false,
                    isVideo = false,
                    ConversationDescription = null,
                    IsGroup = false
                };

                var lastMessage2 = new LastMessage
                {
                    FromUser = fromUserId,
                    UserId = toUserId,
                    Content = "",
                    Datetime = DateTime.Now,
                    Id = messageId,
                    userDetails = await _messageService.GetConversationPartners(toUserId, conversationId),
                    ConversationId = conversationId,
                    isImage = false,
                    isVideo = false,
                    ConversationDescription = null,
                    IsGroup = false
                };
                var newNumberOfFriendsToUser = _detailsService.GetNumberOfFriends(toUserId);
                var newNumberOfFriendsFromUser = _detailsService.GetNumberOfFriends(fromUserId);

                var friendRequestId = _detailsService.getFriendRequestId(toUserId, fromUserId);

                var fromUser = _detailsService.getUserById(fromUserId);
                var toUser = _detailsService.getUserById(toUserId);


                await Clients.Clients(_connectionLinks.Where(x => x.Key == toUserId).Select(x => x.Value).ToList()).SendAsync("Created Conversation With Friend", JsonConvert.SerializeObject(lastMessage2), newNumberOfFriendsToUser, friendRequestId, JsonConvert.SerializeObject(fromUser));
                await Clients.Clients(_connectionLinks.Where(x => x.Key == fromUserId).Select(x => x.Value).ToList()).SendAsync("Created Conversation With Friend", JsonConvert.SerializeObject(lastMessage1), newNumberOfFriendsFromUser, friendRequestId, JsonConvert.SerializeObject(toUser));


                var payload = NotificationPayloadBuilder.BuildPayload(NotificationUtilityInfo.FRIEND_REQUESTS_SCREEN, new List<int> { }, new List<string>() { });
                await _notificationService.SendNotification(new List<int> { fromUserId }, "Sport Net", $"You and {toUser!.Firstname} {toUser!.Lastname} are now friends", payload);
                await _notificationService.SendNotification(new List<int> { toUserId }, "Sport Net", $"You and {fromUser!.Firstname} {toUser!.Lastname} are now friends", payload);
            }
            else
            {
                //write friend request to database:
                var friendRequestId = await _messageService.AddFriendRequest(fromUserId, toUserId);

                var fromUser = _detailsService.getUserById(fromUserId);

                var contentToSend = new ReceivedFriendRequestModel
                {
                    Id = fromUser!.Id,
                    Firstname = fromUser!.Firstname,
                    Lastname = fromUser!.Lastname,
                    ProfileImage = fromUser!.ProfileImage,
                    FriendRequestId = friendRequestId
                };


                await Clients.Clients(connectionIdentifiers).SendAsync("Received Friend Request", JsonConvert.SerializeObject(contentToSend));

                await _notificationService.SendNotification(new List<int> {toUserId}, "Sport Net", $"{fromUser.Firstname} {fromUser.Lastname} sent you a friend request");


            }

        }
        public async Task AcceptFriendRequest(int friendRequestId ,int fromUserId, int toUserId)
        {

            await _messageService.AcceptFriendRequest(fromUserId, toUserId);

            var conversationId = await _messageService.CreateConversationWithFriend(fromUserId, toUserId);

            var messageId = await _messageService.AddMessage(fromUserId, toUserId, conversationId, "", false, false);

            var lastMessage1 = new LastMessage
            {
                FromUser = fromUserId,
                UserId = toUserId,
                Content = "",
                Datetime = DateTime.Now,
                Id = messageId,
                userDetails = await _messageService.GetConversationPartners(fromUserId, conversationId),
                ConversationId = conversationId,
                isImage = false,
                isVideo = false,
                ConversationDescription = null,
                IsGroup = false
            };

            var lastMessage2 = new LastMessage
            {
                FromUser = fromUserId,
                UserId = toUserId,
                Content = "",
                Datetime = DateTime.Now,
                Id = messageId,
                userDetails = await _messageService.GetConversationPartners(toUserId, conversationId),
                ConversationId = conversationId,
                isImage = false,
                isVideo = false,
                ConversationDescription = null,
                IsGroup = false
            };


            var newNumberOfFriendsToUser = _detailsService.GetNumberOfFriends(toUserId);
            var newNumberOfFriendsFromUser = _detailsService.GetNumberOfFriends(fromUserId);

            var fromUser = _detailsService.getUserById(fromUserId);
            var toUser = _detailsService.getUserById(toUserId);

            await Clients.Clients(_connectionLinks.Where(x => x.Key == fromUserId).Select(x => x.Value).ToList()).SendAsync("Created Conversation With Friend", JsonConvert.SerializeObject(lastMessage1), newNumberOfFriendsFromUser, friendRequestId, JsonConvert.SerializeObject(toUser));
            await Clients.Clients(_connectionLinks.Where(x => x.Key == toUserId).Select(x => x.Value).ToList()).SendAsync("Created Conversation With Friend", JsonConvert.SerializeObject(lastMessage2), newNumberOfFriendsToUser, friendRequestId, JsonConvert.SerializeObject(fromUser));

            //var toUser = _detailsService.getUserById(toUserId);
            var payload = NotificationPayloadBuilder.BuildPayload(NotificationUtilityInfo.FRIEND_REQUESTS_SCREEN, new List<int> { conversationId }, new List<string>() { });
            await _notificationService.SendNotification(new List<int> { fromUserId }, "Sport Net", $"{toUser!.Firstname} {toUser!.Lastname} accepted your friend request", payload);
            await _notificationService.SendNotification(new List<int> { toUserId }, "Sport Net", $"You and {fromUser!.Firstname} {fromUser!.Lastname} are now friends");

        }

        public async Task CreateConversation(int creatorId, int[] conversationMembers)
        {
            List<string>? connectionIdentifiers = new List<string>();
            foreach(var partnerId in conversationMembers)
            {
                var connectionIdentifierFound = _connectionLinks.Where(x => x.Key == partnerId).Select(x => x.Value).FirstOrDefault();
                if(connectionIdentifierFound != null)
                {
                    connectionIdentifiers.Add(connectionIdentifierFound);
                }
            }

            //write new conversation group to database:
            var conversationId = await _messageService.CreateConversation(creatorId, conversationMembers);

            var conversation = _detailsService.getConversationById(conversationId)!;
            var groupDescription = conversation.Description;
            var groupImage = conversation.GroupImage;

            var messageId = await _messageService.AddMessage(creatorId, _DEFAULT_TO_USER_ID, conversationId, "", false, false);


            foreach (var member in conversationMembers)
            {
                var lastMessage = new LastMessage
                {
                    FromUser = creatorId,
                    UserId = _DEFAULT_TO_USER_ID,
                    Content = "",
                    Datetime = DateTime.Now,
                    Id = messageId,
                    userDetails = await _messageService.GetConversationPartners(member, conversationId),
                    ConversationId = conversationId,
                    isImage = false,
                    isVideo = false,
                    ConversationDescription = groupDescription,
                    GroupImage = groupImage,
                    IsGroup = true
                };


                if (_connectionLinks.ContainsKey(member))
                {
                    await Clients.Clients(connectionIdentifiers.Where(x => x == _connectionLinks[member]).ToList()).SendAsync("Created group", JsonConvert.SerializeObject(lastMessage));
                }
            }


            var groupPartnersIds = conversationMembers
                .Where(x => x != creatorId)
                .ToList();
            var creatorInfo = _detailsService.getUserById(creatorId)!;
            var payload = NotificationPayloadBuilder.BuildPayload(NotificationUtilityInfo.CONVERSATION_SCREEN, new List<int> { conversationId }, new List<string>() { });
            await _notificationService.SendNotification(groupPartnersIds, "Sport Net", $"{creatorInfo.Firstname} {creatorInfo.Lastname} added you to a group", payload);

        }

        public async Task UpdateGroupDescription(int groupId, string newDescription, int userId)
        {
            var groupMembers = await _messageService.GetConversationMembers(groupId);

            var connectionIds = new List<string>();
            foreach (var member in groupMembers)
            {
                if (_connectionLinks.ContainsKey(member.Id))
                {
                    connectionIds.Add(_connectionLinks.GetValueOrDefault(member.Id)!);
                }
            }

            var groupDescription = _detailsService.getConversationById(groupId)!.Description;
            
            
            //update new description group name in database:
            await _messageService.UpdateGroupDescription(groupId, newDescription);


            await Clients.Clients(connectionIds).SendAsync("Updated Group Description", groupId, newDescription);


            var whoUpdatedInfo = _detailsService.getUserById(userId);
            var notificationReceivers = groupMembers
                .Where(x => x.Id != userId)
                .ToList()
                .Select(x => x.Id)
                .ToList();
            var payload = NotificationPayloadBuilder.BuildPayload(NotificationUtilityInfo.CONVERSATION_SCREEN, new List<int> { groupId }, new List<string>() { });
            await _notificationService.SendNotification(notificationReceivers, "Sport Net", $"{whoUpdatedInfo!.Firstname} {whoUpdatedInfo!.Firstname} updated group description from '{groupDescription!}' to '{newDescription}", payload);

        }


        public async Task UpdateGroupImage(int groupId, List<int> newImage, int userId)
        {
            var groupMembers = await _messageService.GetConversationMembers(groupId);

            var connectionIds = new List<string>();
            foreach (var member in groupMembers)
            {
                if (_connectionLinks.ContainsKey(member.Id))
                {
                    connectionIds.Add(_connectionLinks.GetValueOrDefault(member.Id)!);
                }
            }


            //update new description group name in database:
            await _messageService.UpdateGroupImage(groupId, newImage);

            var content = new GroupImageTransport
            {
                GroupId = groupId,
                GroupImage = newImage
            };

            var negative = newImage.Any(x => x < 0);


            await Clients.Clients(connectionIds).SendAsync("Updated Group Image",JsonConvert.SerializeObject(content));

            var groupDescription = _detailsService.getConversationById(groupId)!.Description;
            var whoUpdatedInfo = _detailsService.getUserById(userId);
            var notificationReceivers = groupMembers
                .Where(x => x.Id != userId)
                .ToList()
                .Select(x => x.Id)
                .ToList();
            var payload = NotificationPayloadBuilder.BuildPayload(NotificationUtilityInfo.CONVERSATION_SCREEN, new List<int> { groupId }, new List<string>() { });
            await _notificationService.SendNotification(notificationReceivers, "Sport Net", $"{whoUpdatedInfo!.Firstname} {whoUpdatedInfo!.Firstname} updated {groupDescription}' group image", payload);

        }

        public async Task LeaveChatGroup(int conversationId, int userId)
        {
            var groupMembers = await _messageService.GetConversationMembers(conversationId);

            var connectionIds = new List<string>();
            foreach (var member in groupMembers)
            {
                if (_connectionLinks.ContainsKey(member.Id))
                {
                    connectionIds.Add(_connectionLinks.GetValueOrDefault(member.Id)!);
                }
            }

            var oldGroupDescription = _detailsService.getConversationById(conversationId)!.Description;

            // remove member from group in database:
            string groupName = await _messageService.LeaveChatGroup(conversationId, userId);

            var content = new ChatGroupLeavingModel
            {
                ConversationId = conversationId,
                UserId = userId,
                NewGroupName = groupName
            };

            await Clients.Clients(connectionIds).SendAsync("Member Left Chat Group", JsonConvert.SerializeObject(content));


            var whoUpdatedInfo = _detailsService.getUserById(userId);
            var notificationReceivers = groupMembers
                .Where(x => x.Id != userId)
                .ToList()
                .Select(x => x.Id)
                .ToList();
            var payload = NotificationPayloadBuilder.BuildPayload(NotificationUtilityInfo.CONVERSATION_SCREEN, new List<int> { conversationId }, new List<string>() { });
            await _notificationService.SendNotification(notificationReceivers, "Sport Net", $"{whoUpdatedInfo!.Firstname} {whoUpdatedInfo!.Firstname} left '{oldGroupDescription}' group", payload);
        }


        public async Task AddUserToChatGroup(int userWhoAdded, int groupId, List<int> usersToAdd)
        {
            //add user(s) to chat group in database
            await _messageService.AddUserToChatGroup(usersToAdd, groupId);

            //renew group members list
            var groupMembers = await _messageService.GetConversationMembers(groupId);

            var connectionIds = new List<string>();
            foreach (var member in groupMembers)
            {
                if (_connectionLinks.ContainsKey(member.Id))
                {
                    connectionIds.Add(_connectionLinks.GetValueOrDefault(member.Id)!);
                }
            }

            //build content to send to partners:
            var conversation = _detailsService.getConversationById(groupId)!;
            var message = await _messageService.GetLastMessage(conversation.Id);
            var addedUsers = usersToAdd.Select(x => _detailsService.getUserById(x)!).ToList();

            foreach (var user in groupMembers)
            {
                var groupPartners = await _messageService.GetConversationPartners(user.Id, conversation.Id);

                var lastMessage = new LastMessage
                {
                    FromUser = userWhoAdded,
                    UserId = _DEFAULT_TO_USER_ID,
                    Content = message.Content,
                    Datetime = DateTime.Now,
                    Id = message.Id,
                    userDetails = groupPartners,
                    ConversationId = conversation.Id,
                    isImage = message.IsImage,
                    isVideo = message.IsVideo,
                    ConversationDescription = conversation.Description,
                    GroupImage = conversation.GroupImage,
                    IsGroup = conversation.IsGroup,
                    FromUserDetails = _detailsService.getUserById(message.FromUser)!
                    
                };

                var content = new AddUserToChatGroupModel
                {
                    UserWhoAdded = userWhoAdded,
                    NewGroupPartnerList = groupPartners,
                    ChatListItem = lastMessage,
                    AddedUsers = addedUsers
                };

                if (_connectionLinks.ContainsKey(user.Id))
                {
                    await Clients.Clients(connectionIds.Where(x => x == _connectionLinks[user.Id]).ToList()).SendAsync("Added Members To Chat Group", JsonConvert.SerializeObject(content));
                }
            }


            var whoAddedInfo = _detailsService.getUserById(userWhoAdded);
            var notificationReceivers = usersToAdd;
            var payload = NotificationPayloadBuilder.BuildPayload(NotificationUtilityInfo.CONVERSATION_SCREEN, new List<int> { groupId }, new List<string>() { });
            await _notificationService.SendNotification(notificationReceivers, "Sport Net", $"{whoAddedInfo!.Firstname} {whoAddedInfo!.Firstname} added you to '{conversation.Description}' group", payload);


        }


        public async Task ReactToMessage(int userId, int messageId, int conversationId)
        {
            var userHasAlreadyReactedToMessage = _messageService.CheckIfUserHasAlreadyReactedToMessage(userId, messageId);
            if (userHasAlreadyReactedToMessage) return;

            var conversationMembers = await _messageService.GetConversationMembers(conversationId);
            var connectionIds = new List<string>();
            foreach (var member in conversationMembers)
            {
                if (_connectionLinks.ContainsKey(member.Id))
                {
                    connectionIds.Add(_connectionLinks.GetValueOrDefault(member.Id)!);
                }
            }

            var message = await _messageService.GetMessageById(messageId);
            var conversationDescription = _detailsService.getConversationById(conversationId)!.Description;
            


            // add reaction in database
            await _messageService.ReactToMessage(userId, messageId);

            var content = new MessageReactionObject
            {
                ReactedMessageId = messageId,
                ConversationId = conversationId,
                WhoReacted = _detailsService.getUserById(userId)!
            };

            await Clients.Clients(connectionIds).SendAsync("User Reacted To Message", JsonConvert.SerializeObject(content));

            if (conversationMembers.Any(x => x.Id == message.FromUser)) {
                var whoReacted = _detailsService.getUserById(userId)!;
                var payload = NotificationPayloadBuilder.BuildPayload(NotificationUtilityInfo.CONVERSATION_SCREEN, new List<int> { conversationId }, new List<string>() { });
                await _notificationService.SendNotification(new List<int> { message.FromUser }, $"{conversationDescription}", $"{whoReacted.Firstname} {whoReacted.Lastname} reacted to your message", payload);
            }
        }

        public async Task RemoveReactionFromMessage(int userId, int messageId, int conversationId)
        {
            var userHasReactedToMessage = _messageService.CheckIfUserHasAlreadyReactedToMessage(userId, messageId);
            if (!userHasReactedToMessage) return;

            var conversationMembers = await _messageService.GetConversationMembers(conversationId);
            var connectionIds = new List<string>();
            foreach (var member in conversationMembers)
            {
                if (_connectionLinks.ContainsKey(member.Id))
                {
                    connectionIds.Add(_connectionLinks.GetValueOrDefault(member.Id)!);
                }
            }

            // remove reaction from database
            await _messageService.RemoveReactionFromMessage(userId, messageId);


            var content = new RemoveMessageReactionObject
            {
                MessageId = messageId,
                ConversationId = conversationId,
                WhoRemovedReaction = userId
            };

            await Clients.Clients(connectionIds).SendAsync("User Removed Reaction To Message", JsonConvert.SerializeObject(content));


        }


        public override Task OnConnectedAsync()
        {
            var userId = _contextUser.requestUser()!.Id;

            if (!_connectionLinks.ContainsKey(userId))
                _connectionLinks.Add(userId, Context.ConnectionId);

            return base.OnConnectedAsync();
        }


        public override Task OnDisconnectedAsync(Exception? exception)
        {
            _connectionLinks.Remove(_contextUser.requestUser()!.Id);

            return base.OnDisconnectedAsync(exception);
        }
    }
}
