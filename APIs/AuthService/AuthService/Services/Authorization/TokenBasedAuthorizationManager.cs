using AuthService.Services.Identity;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Text;

namespace AuthService.Services.Authorization
{
    public class TokenBasedAuthorizationManager
    {
        private readonly RequestDelegate _requestDelegate;


        public TokenBasedAuthorizationManager(RequestDelegate requestDelegate)
        {
            _requestDelegate = requestDelegate;
        }

        public async Task Invoke(HttpContext context, IIdentityService identityService)
        {
            var token = context.Request.Headers["Authorization"].FirstOrDefault()?.Split(" ").Last();

            if (token == null)
            {
                token = context.Request.Headers["chathubbearer"];
            }

            if (token == null)
            {
                if (context.Request.Query.ContainsKey("accessToken"))
                {
                    token = context.Request.Query["accessToken"];
                }
            }


            if (token != null)
            {
                attachAccountToContext(context, identityService, token);
            }


            await _requestDelegate(context);
        }

        private void attachAccountToContext(HttpContext context, IIdentityService identityService, string token)
        {
            try
            {
                var tokenHandler = new JwtSecurityTokenHandler();
                //var key = Encoding.ASCII.GetBytes(Environment.GetEnvironmentVariable("JWT_SIGNING_KEY")!);
                var key = Encoding.ASCII.GetBytes("1111111111111111");
                tokenHandler.ValidateToken(token, new TokenValidationParameters
                {
                    ValidateIssuerSigningKey = true,
                    IssuerSigningKey = new SymmetricSecurityKey(key),
                    ValidateIssuer = false,
                    ValidateAudience = false,
                    ClockSkew = TimeSpan.Zero

                }, out SecurityToken validatedToken);

                var obtainedToken = (JwtSecurityToken)validatedToken;
                var accountId = int.Parse(obtainedToken.Claims.First(x => x.Type == "id").Value);

                //now inject user into secured http context

                context.Items["User"] = identityService.getUserById(accountId);
            }
            catch (Exception e)
            {

                throw;
            }
        }

    }
}
