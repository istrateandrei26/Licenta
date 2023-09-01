using Microsoft.AspNetCore.Mvc;
using AuthService.DTOs;
using Microsoft.AspNetCore.Authorization;
using AuthService.Services.Email;
using AuthService.Services.Identity;
using AuthService.Services.Authentication;
using AuthorizeAttribute = AuthService.Services.Authorization.AuthorizeAttribute;

namespace AuthService.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    
    public class AuthController : ControllerBase
    {
        private IRegisterService _registerService;
        private ILoginService _loginservice;
        private IIdentityService _identityService;
        private IEmailService _emailService;
        public AuthController(IRegisterService registerService, ILoginService loginservice, IIdentityService identityService, IEmailService emailService)
        {
            _registerService = registerService;
            _loginservice = loginservice;
            _identityService = identityService;
            _emailService = emailService;
        }

        
        [HttpPost("register")]
        public async Task<IActionResult> Register(UserRegisterDto request)
        {
            var response = await _registerService.RegisterUser(request.Username, request.Email, request.Firstname, request.Lastname, request.Password);

            if(response == null)    
                return BadRequest();

            return Ok(response);
        }

        
        [HttpPost("login")]
        public async Task<IActionResult> Login(UserLoginDto request)
        {
            var response = await _loginservice.Login(request.Username, request.Password);

            if (response == null)
                return BadRequest();

            return Ok(response);

        }

        
        [HttpPost("refreshToken")]
        public async Task<IActionResult> RefreshToken(RefreshTokenRequest request)
        {
            var response = await _identityService.RefreshToken(request);

            if(response.RefreshToken == string.Empty)
            {
                return BadRequest(response);
            }

            return Ok(response);
        }

        [Authorize]
        [HttpPost("changePassword")]
        public async Task<IActionResult> ChangePassword(ChangePasswordRequest request)
        {
            var response = await _identityService.ChangePassword(request);

            return Ok(response);
        }

        //[Authorize]
        [HttpPost("getUserProfile")]
        public async Task<IActionResult> GetUserProfile(GetUserProfileRequest request)
        {
            var user = _identityService.getUserById(request.UserProfileId);
            var isFriend = await _identityService.CheckIfUserIsFriend(request.CurrentUserId, request.UserProfileId);
            //check this functions TODO :
            var eventsAttended = _identityService.GetAttendedEvents(request.UserProfileId);
            var admirers = _identityService.GetAdmirers(request.UserProfileId);
            var myOwnEventAverages = _identityService.GetMyEventsAverages(request.UserProfileId);
            var honors = _identityService.getNumberOfHonors(request.UserProfileId);
            var givenHonors = _identityService.getGivenHonors(request.UserProfileId);
            var attendedCategories = _identityService.GetAttendedCategories(request.UserProfileId);
            var friendRequestSent = _identityService.CheckFriendRequestSent(request.CurrentUserId, request.UserProfileId);


            if(user == null)    
                return NotFound();


            var response = new GetUserProfileResponse
            {
                User = user,
                IsFriend = isFriend,
                EventsAttended = eventsAttended,
                Admirers = admirers,
                MyOwnEvents = myOwnEventAverages,
                Honors = honors,
                GivenHonors = givenHonors,
                AttendedCategories = attendedCategories,
                FriendRequestSent = friendRequestSent,
                Message = "Succesfully gathered user profile",
                Type = DTOs.Type.Ok,
                StatusCode = 200
            };


            return Ok(response);
        }

        
        [HttpPost("googleSignIn")]
        public async Task<IActionResult> SignInWithGoogle(GoogleSignInRequest request)
        {
            var response = await _loginservice.SignInWithGoogle(request.Email, request.Firstname, request.Lastname, request.ProfileImageBytes);

            if (response == null)
                return BadRequest();

            return Ok(response);
        }

        [Authorize]
        [HttpPost("uploadProfileImage")]
        public async Task<IActionResult> UploadProfileImage([FromForm] ProfileImageModel profileImageModel)
        {
            try
            {
                var profileImage = await _identityService.SaveProfileImage(profileImageModel.file, int.Parse(profileImageModel.UserId));

                var response = new UploadProfileImageResponse
                {
                    ProfileImage = profileImage,
                    Message = "Succesfully uploaded profile image",
                    Type = DTOs.Type.Ok,
                    StatusCode = 200
                };

                return Ok(response);

            }
            catch (Exception ex)
            {
                return Ok(ex.Message);
            }

        }

        [Authorize]
        [HttpPost("addDeviceId")]
        public async Task<IActionResult> AddDeviceId(AddDeviceIdRequest request)
        {
            try
            {
                await _identityService.AddDeviceId(request.UserId, request.DeviceId);

                var response = new AddDeviceIdResponse
                {
                    Message = $"Succesfully added device id for user with id {request.UserId}",
                    Type = DTOs.Type.Ok,
                    StatusCode = 200
                };

                return Ok(response);

            }
            catch (Exception ex)
            {
                return Ok(ex.Message);
            }
        }

        [Authorize]
        [HttpPost("removeDeviceId")]
        public async Task<IActionResult> RemoveDeviceId(RemoveDeviceIdRequest request)
        {
            try
            {
                await _identityService.RemoveDeviceId(request.UserId, request.DeviceId);

                var response = new RemoveDeviceIdResponse
                {
                    Message = $"Succesfully removed device id for user with id {request.UserId}",
                    Type = DTOs.Type.Ok,
                    StatusCode = 200
                };

                return Ok(response);
            }
            catch(Exception ex)
            {
                return Ok(ex.Message);
            }
        }

        //[Authorize]
        [HttpPost("getLoggedInProfileInfo")]
        public async Task<IActionResult> GetLoggedInProfileInfo(GetLoggedInProfileInfoRequest request)
        {
            var response = await _identityService.GetLoggedInProfileInfo(request.UserId);

            return Ok(response);
        }

        
        [HttpPost("generatePasswordResetCode")]
        public async Task<IActionResult> GeneratePasswordResetCode(GeneratePasswordResetCodeRequest request)
        {
            var response = new GeneratePasswordResetCodeResponse
            {
                Type = DTOs.Type.Ok,
                StatusCode = 200,
                WrongEmail = false
            };

            var emailExists = _identityService.CheckEmailExists(request.Email);
            if(!emailExists)
            {
                response.Message = $"We are sorry, the provided email does not exist";
                response.WrongEmail = true;

                return Ok(response);
            }

            // generate reset code and send email with it
            await _emailService.SendResetPasswordEmail(request.Email);

            response.Message = $"Succesfully generated password reset code for ${request.Email}";

            return Ok(response);
        }


        
        [HttpPost("resetPassword")]
        public async Task<IActionResult> ResetPassword(ResetPasswordRequest request)
        {
            var resetCodeAlreadyUsed = _identityService.CheckIfPasswordResetCodeIsAlreadyUsed(request.ResetCode);
            var resetCodeExpired = _identityService.CheckIfPasswordResetCodeIsExpired(request.ResetCode);
            var resetCodeExists = _identityService.CheckIfResetCodeExists(request.ResetCode);


            if((!resetCodeAlreadyUsed) && (!resetCodeExpired) && (resetCodeExists))
            {
                await _identityService.ResetPassword(request.NewPassword, request.ResetCode);
            }

            string message = "";
            if (resetCodeAlreadyUsed || resetCodeExpired) message = "The code has been already used or expired";
            else if (!resetCodeExists) message = "Invalid Reset Code";
            else message = "The password has been successfully changed";
            

            var response = new ResetPasswordResponse
            {
                Message = message,
                Type = DTOs.Type.Ok,
                StatusCode = 200,
                CodeExpired = resetCodeExpired,
                CodeAlreadyUsed = resetCodeAlreadyUsed,
                CodeDoesNotExist = !resetCodeExists
            };

            return Ok(response);

        }

    }
}
