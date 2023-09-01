namespace AuthService.DTOs
{
    public enum Type
    {
        InvalidUsernameOrPassword,
        Ok,
        ExistingEmail,
        ExistingUsername,
        UserNotFound,
        InvalidTokenRequest,
        InvalidOldPassword
    }
    public class BasicResponse
    {
        public int StatusCode { get; set; }
        public string Message { get; set; } = string.Empty;
        public Type Type { get; set; }
    }
}
