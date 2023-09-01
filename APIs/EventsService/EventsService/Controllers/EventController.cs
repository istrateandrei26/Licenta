using EventsService.DTOs.Request;
using EventsService.DTOs.Response;
using EventsService.Services.Details;
using EventsService.Services.Email;
using EventsService.Services.Events;
using EventsService.Services.Notification;
using Microsoft.AspNetCore.Mvc;
using AuthorizeAttribute = EventsService.Services.Authorization.AuthorizeAttribute;

namespace EventsService.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EventController : ControllerBase
    {
        private IDetailsService _detailsService;
        private IEventsGatherService _eventsService;
        private INotificationService _notificationService;
        private IEmailService _emailService;

        public EventController(IDetailsService detailsService, IEventsGatherService eventsService, INotificationService notificationService, IEmailService emailService)
        {
            _detailsService = detailsService;
            _eventsService = eventsService;
            _notificationService = notificationService;
            _emailService = emailService;
        }
        [Authorize]
        [HttpGet("getEvents")]
        public async Task<IActionResult> GetEvents()
        {
            var events = await _eventsService.getAllEvents();
            var categories = await _eventsService.getAllCategories();

            var response = new RetrieveEventsResponse
            {
                StatusCode = 200,
                Message = "Ok",
                Type = DTOs.Response.Type.Ok,
                Events = events,
                Categories = categories
            };


            return Ok(response);
        }

        [Authorize]
        [HttpPost("getEventDetails")]
        public async Task<IActionResult> GetEventDetails(RetrieveEventDetailsRequest request)
        {
            var eventFound = await _eventsService.getEventDetailsAsync(request.EventId);
            var eventMembers = await _detailsService.getEventMembersAsync(request.EventId);
            var friends = await _detailsService.GetUserFriendsAsync(request.UserId);

            var response = new RetrieveEventDetailsResponse
            {
                StatusCode = 200,
                Message = "Ok",
                Type = DTOs.Response.Type.Ok,
                Event = eventFound!,
                Members = eventMembers!,
                Friends = friends
            };

            return Ok(response);
        }

        [Authorize]
        [HttpPost("getLocationsBySportCategory")]
        public async Task<IActionResult> GetLocationsBySportCategory(RetrieveLocationsBySportCategoryRequest request)
        {
            var locations = await _detailsService.getLocationsBySportCategoryId(request.SportCategoryId);
            var attendedLocations = await _detailsService.GetAttendedLocations(request.UserId);

            var response = new RetrieveLocationsBySportCategoryResponse
            {
                Message = "Ok",
                StatusCode = 200,
                Type = DTOs.Response.Type.Ok,
                Locations = locations,
                AttendedLocations = attendedLocations
            };

            return Ok(response);
        }

        
        [HttpPost("createNewLocation")]
        public async Task<IActionResult> CreateNewLocation(CreateNewLocationRequest request)
        {
            var locationId = await _detailsService.CreateNewLocation(request.Latitude, request.Longitude, request.City, request.LocationName, request.SportCategoryId, true);

            var response = new CreateNewLocationResponse
            {
                Message = "Ok",
                StatusCode = 200,
                Type = DTOs.Response.Type.Ok,
                LocationId = locationId
            };

            return Ok(response);
        }

        [Authorize]
        [HttpPost("createEvent")]
        public async Task<IActionResult> CreateEvent(CreateEventRequest request)
        {
            //check order
            var userHasAnotherEventScheduled = await _eventsService.CheckIfEventCreatorIsBusy(request.StartDatetime, request.Duration, request.CreatorId);
            int eventId;
            if (!userHasAnotherEventScheduled)
            {
                eventId = await _eventsService.createEvent(request.SportCategoryId, request.LocationId, request.CreatorId, request.RequiredMembers, request.AllMembers, request.StartDatetime, request.Duration, request.CreateNewLocation, request.Lat, request.Long, request.City, request.LocationName);
            }
            else
            {
                eventId = -1;
            }

            var response = new CreateEventResponse
            {

                Message = "Ok",
                StatusCode = 200,
                Type = DTOs.Response.Type.Ok,
                SuccessfullyCreated = (!userHasAnotherEventScheduled) && (eventId != 0),
                BusyCreator = userHasAnotherEventScheduled,
                Overlaps = eventId == 0,
                EventId = eventId
            };

            return Ok(response);
            
        }


        [Authorize]
        [HttpPost("checkEventToJoin")]
        public async Task<IActionResult> CheckEventStatus(CheckEventToJoinRequest request)
        {
            var eventIsExpired = _eventsService.CheckIfEventIsExpired(request.EventId);
            var eventIsFull = _eventsService.CheckIfEventIsFull(request.EventId);
            var userHasAnotherEventScheduled = await _eventsService.CheckIfEventIntersectsWithAnotherEvents(request.EventId, request.UserId);

            var response = new CheckEventToJoinResponse
            {
                Message = "Ok",
                StatusCode = 200,
                Type = DTOs.Response.Type.Ok,
                Expired = eventIsExpired,
                Busy = userHasAnotherEventScheduled,
                Full = eventIsFull
            };



            return Ok(response);
        }

        [Authorize]
        [HttpPost("getEventInvites")]
        public async Task<IActionResult> GetEventsInvitations(RetrieveEventInvitesRequest request)
        {
            var invites = await _eventsService.getEventsInvitations(request.UserId);

            var response = new RetrieveEventInvitesResponse
            {
                Message = "Ok",
                StatusCode = 200,
                Type = DTOs.Response.Type.Ok,
                Invites = invites
            };

            return Ok(response);
        }

        [Authorize]
        [HttpPost("getAttendedLocations")]
        public async Task<IActionResult> GetAttendedLocations(GetAttendedLocationsRequest request)
        {
            var attendedLocations = await _detailsService.GetAttendedLocations(request.UserId);

            var response = new GetAttendedLocationsResponse
            {
                Message = "Ok",
                StatusCode = 200,
                Type = DTOs.Response.Type.Ok,
                AttendedLocations = attendedLocations
            };


            return Ok(response);
        }

        [Authorize]
        [HttpPost("getEventsWithoutReview")]
        public async Task<IActionResult> GetEventsWithoutReview(RetrieveEventReviewInfoRequest request)
        {
            // search for events which have not been reviewed, then return them along with details and members: 

            var eventsFound = await _eventsService.getEventsWithoutReview(request.UserId);

            var response = new RetrieveEventReviewInfoResponse
            {
                Message = "Ok",
                StatusCode = 200,
                Type = DTOs.Response.Type.Ok,
                EventReviewInfos = eventsFound
            };

            return Ok(response);
        }

        [Authorize]
        [HttpPost("reviewEventAsIgnored")]
        public async Task<IActionResult> ReviewEventAsIgnored(ReviewEventAsIgnoredRequest request)
        {
            await _eventsService.ReviewEventAsIgnored(request.EventId, request.FromId);

            var response = new ReviewEventAsIgnoredResponse
            {
                Message = "Ok",
                StatusCode = 200,
                Type = DTOs.Response.Type.Ok,
            };

            return Ok(response);
        }

        [Authorize]
        [HttpPost("acceptEventInvitation")]
        public async Task<IActionResult> AcceptEventInvitation(AcceptEventInvitationRequest request)
        {

            // check order!
            var eventToAttend = _detailsService.getEventByInvitationId(request.InvitationId);

            var eventIsExpired = _eventsService.CheckIfEventIsExpired(eventToAttend.Id);

            var eventIsFull = _eventsService.CheckIfEventIsFull(eventToAttend.Id);


            bool userHasAnotherEventScheduled;
            if (eventIsExpired || eventIsFull)
            {
                userHasAnotherEventScheduled = false;
            }
            else
            {
                userHasAnotherEventScheduled = await _eventsService.AcceptEventInvitation(request.InvitationId, request.UserId);
            }


            var response = new AcceptEventInvitationResponse
            {
                Message = "Ok",
                StatusCode = 200,
                Type = DTOs.Response.Type.Ok,
                Expired = eventIsExpired,
                Busy = userHasAnotherEventScheduled,
                Full = eventIsFull
            };



            return Ok(response);
        }

        
        [Authorize]
        [HttpPost("addGoogleCalendarEvent")]
        public async Task<IActionResult> AddGoogleCalendarEvent(AddGoogleCalendarEventRequest request)
        {
            await _eventsService.AddGoogleCalendarEvent(request.GoogleCalendarEventId, request.UserId, request.EventId);

            var response = new AddGoogleCalendarEventResponse
            {
                Message = "Ok",
                StatusCode = 200,
                Type = DTOs.Response.Type.Ok,
            };

            return Ok(response);

        }
        [Authorize]
        [HttpPost("removeGoogleCalendarEvent")]
        public async Task<IActionResult> RemoveGoogleCalendarEvent(RemoveGoogleCalendarEventRequest request)
        {
            await _eventsService.RemoveGoogleCalendarEvent(request.UserId, request.EventId);

            var response = new RemoveGoogleCalendarEventResponse
            {
                Message = "Ok",
                StatusCode = 200,
                Type = DTOs.Response.Type.Ok,
            };

            return Ok(response);
        }
        [Authorize]
        [HttpPost("getGoogleCalendarEventId")]
        public async Task<IActionResult> GetGoogleCalendarEventId(GetGoogleCalendarEventRequest request)
        {
            var idFound = await _eventsService.GetGoogleCalendarEventId(request.EventId, request.UserId);

            var response = new GetGoogleCalendarEventResponse
            {
                Message = "Ok",
                StatusCode = 200,
                Type = DTOs.Response.Type.Ok,
                Id = idFound,
                Found = idFound == "" ? false : true

            };

            return Ok(response);
        }

        
        [HttpPost("generateNewLocationRequest")]
        public async Task<IActionResult> GenerateNewLocationRequest(GenerateNewLocationRequest request)
        {
            //add in database new record, mark it unapproved and unpaid
            var success = await _detailsService.AddNewLocationRequest(request.Latitude, request.Longitude, request.City, request.LocationName, request.OwnerEmail, request.SportCategoryId);

            var response = new GenerateNewLocationResponse
            {
                StatusCode = 200,
                Type = DTOs.Response.Type.Ok,
                Success = success
            };

            
            response.Message = success ? "Our technical staff will inspect your new location request. Good luck!" : "Something went wrong";

            return Ok(response);
        }

        
        [HttpPost("approveLocation")]
        public async Task<IActionResult> ApproveNewLocation(ApproveNewLocationRequest request)
        {
            await _emailService.SendNewLocationApprovalVerificationCode(request.ApprovedLocationId);

            var response = new ApproveNewLocationResponse
            {
                Message = "Successfully approved location",
                StatusCode = 200,
                Type = DTOs.Response.Type.Ok,
            };

            return Ok(response);
        }

        
        [HttpPost("confirmNewLocationPayment")] 
        public async Task<IActionResult> ConfirmNewLocationPayment(ConfirmNewLocationPaymentRequest request) 
        {
            await _detailsService.ConfirmNewLocationPayment(request.ApprovedLocationId);

            var response = new ConfirmNewLocationPaymentResponse
            {
                Message = "Successfully paid. Your location is now added in our app",
                StatusCode = 200,
                Type = DTOs.Response.Type.Ok,
            };


            return Ok(response);
        }

        
        [HttpPost("getNewRequestedLocationInfoForPayment")]
        public async Task<IActionResult> GetNewRequestedLocationInfoForPayment(GetNewRequestedLocationInfoForPaymentRequest request)
        {
            var response = await _detailsService.GetRequestedLocationInfoForPayment(request.VerificationCode);

            response.Message = "Ok";
            response.StatusCode = 200;
            response.Type = DTOs.Response.Type.Ok;

            return Ok(response);
        }


        
        [HttpPost("firebaseNotificationTest")]
        public async Task<IActionResult> SendNotificationTest(List<int> to, string screen, string body = "")
        {
            var response = await _notificationService.SendNotificationToUserTest(screen);

            //await _notificationService.SendNotification(to, "Title", body);

            if (response.IsSuccessStatusCode)
            {
                return Ok("Notification sent successfully");
            }
            else
            {
                return Ok($"Failed to send notification: {response.StatusCode} - {await response.Content.ReadAsStringAsync()}");
            }


            


        }

        
        [HttpGet("getRequestedLocationsForApproval")]
        public async Task<IActionResult> GetRequestedLocationsForApproval()
        {
            var requestedLocations = await _eventsService.GetRequestedLocations();

            var response = new GetRequestedLocationsResponse
            {
                RequestedLocations = requestedLocations
            };



            return Ok(response);
        }

        
        [HttpGet("recommendFriends")]
        public async Task<IActionResult> RecommendFriends(GetRecommendedFriendsRequest request)
        {

            var recommendations = _eventsService.RecommendFriends(request.UserId);

            return Ok(recommendations);
        }
    }
}
