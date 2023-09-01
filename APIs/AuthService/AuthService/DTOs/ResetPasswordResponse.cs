namespace AuthService.DTOs
{
    public class ResetPasswordResponse: BasicResponse
    {
        public bool CodeExpired { get; set; }
        public bool CodeAlreadyUsed { get; set; }
        public bool CodeDoesNotExist { get; set; }
    }
}
