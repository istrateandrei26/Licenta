using ChatService.DTOs;

namespace ChatService.Services.Authorization
{
    public class ContextUser
    {
        IHttpContextAccessor _httpContext;

        public ContextUser(IHttpContextAccessor httpContext)
        {
            _httpContext = httpContext;
        }

        public UserObject? requestUser()
        {
            if (_httpContext != null)
                return (UserObject?)_httpContext.HttpContext?.Items["User"];

            return null;
        }
    }
}
