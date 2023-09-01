namespace AuthService.DTOs
{
    public class GeneratePasswordResetCodeResponse: BasicResponse
    {
        public bool WrongEmail { get; set; }
    }
}
