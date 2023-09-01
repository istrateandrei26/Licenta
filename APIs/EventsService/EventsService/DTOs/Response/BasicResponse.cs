namespace EventsService.DTOs.Response
{
    public enum Type
    {
        InvalidUsernameOrPassword,
        Ok,
        ExistingEmail,
        ExistingUsername,
        UserNotFound,
        InvalidTokenRequest,
        InvalidOldPassword,
        EventExists,
    }
    public class BasicResponse
    {
        public int StatusCode { get; set; }
        public string Message { get; set; } = string.Empty;
        public Type Type { get; set; }
    }
}
