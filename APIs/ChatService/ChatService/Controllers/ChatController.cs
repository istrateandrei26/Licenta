using ChatService.DTOs;
using ChatService.Models;
using ChatService.Services;
using ChatService.Services.Authorization;
using ChatService.Services.Chat;
using ChatService.Services.Details;
using ChatService.Services.Notification;
using ChatService.Services.User;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace ChatService.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class ChatController : ControllerBase
    {
        private IDetailsService _detailsService;
        private IMessageService _messageService;
        private IUserService _userService;
        private INotificationService _notificationService;

        public ChatController(IDetailsService detailsService, IMessageService message, IUserService userService, INotificationService notificationService)
        {
            _detailsService = detailsService;
            _messageService = message;
            _userService = userService;
            _notificationService = notificationService;
        }

        [HttpPost("getChatList")]
        public async Task<IActionResult> GetChatList(RetrieveChatListRequest request)
        {
            var userFound = _detailsService.getUserById(request.userId);
            
            if(userFound == null)
            {
                return Ok(new RetrieveChatListResponse
                {
                    LastMessages = new List<LastMessage>(),
                    Type = DTOs.Type.UserNotFound,
                    Message = "User Not Found",
                    StatusCode = 200
                });
            }

            var recommendations = _messageService.RecommendFriends(request.userId);
            var friends = await _userService.getUserFriends(request.userId);
            var lastMessages = await _messageService.getLastMessages(request.userId);

            var response = new RetrieveChatListResponse
            {
                StatusCode = 200,
                Message = "Ok",
                Type = DTOs.Type.Ok,
                Friends = friends,
                LastMessages = lastMessages,
                User = userFound,
                RecommendedPersons = recommendations
            };

            return Ok(response);

        }


        [HttpPost("getMessages")]
        public async Task<IActionResult> GetMessages(RetrieveMessagesRequest request)
        {
            var messages = await _messageService.GetMessages(request.UserId, request.ConversationId);
            var conversationPartners = await _messageService.GetConversationPartners(request.UserId, request.ConversationId);
            var conversation = _detailsService.getConversationById(request.ConversationId)!;
            var friends = await _userService.getUserFriends(request.UserId);

            var response = new RetrieveMessagesResponse
            {
                StatusCode = 200,
                Message = "Ok",
                Type = DTOs.Type.Ok,
                Messages = messages,
                ConversationPartners = conversationPartners,
                groupImage = conversation.GroupImage,
                groupName = conversation.Description,
                IsGroup = conversation.IsGroup,
                Friends = friends
            };



            return Ok(response);
        }

        [HttpPost("getFriendRequests")]
        public async Task<IActionResult> GetFriendRequests(GetFriendRequestsRequest request)
        {
            var friendRequests = await _messageService.GetFriendRequests(request.UserId);
            var numberOfFriends = _detailsService.GetNumberOfFriends(request.UserId);

            var response = new GetFriendRequestsResponse
            {
                StatusCode = 200,
                Message = "OK",
                Type = DTOs.Type.Ok,
                FriendRequests = friendRequests,
                NumberOfFriends = numberOfFriends
            };


            return Ok(response);
        }

        [HttpPost("getUserFriends")]
        public async Task<IActionResult> GetFriends(GetFriendsRequest request)
        {

            var friends = await _userService.getUserFriends(request.userId);

            var response = new GetFriendsResponse
            {
                StatusCode = 200,
                Message = "OK",
                Type = DTOs.Type.Ok,
                Friends = friends
            };


            return Ok(response);
        }

        [HttpPost("getCommonStuff")]
        public async Task<IActionResult> GetCommonStuff(GetCommonStuffRequest request)
        {

            var commonAttendedCategories = await _userService.getCommonAttendedCategories(request.UserId1, request.UserId2);
            var commonGroups = await _userService.getCommonGroups(request.UserId1, request.UserId2);

            var response = new GetCommonStuffResponse
            {
                StatusCode = 200,
                Message = "OK",
                Type = DTOs.Type.Ok,
                CommonAttendedCategories = commonAttendedCategories,
                CommonGroups = commonGroups
            };

            return Ok(response);
        }

        [HttpPost("firebaseNotificationTest")]
        public async Task<IActionResult> SendNotificationTest(List<int> to)
        {
            var payload = NotificationPayloadBuilder.BuildPayload(NotificationUtilityInfo.CONVERSATION_SCREEN, new List<int> { 2 }, new List<string>() { });
            var response = await _notificationService.SendNotificationToUserTest(payload);

            //await _notificationService.SendNotification(to, "Title", body);

            if (response.IsSuccessStatusCode)
            {
                return Ok("Notification sent successfully");
            }
            else
            {
                return Ok($"Failed to send notification: {response.StatusCode} - {await response.Content.ReadAsStringAsync()}");
            }


            //return Ok("Notification sent successfully");


        }

    }
}
