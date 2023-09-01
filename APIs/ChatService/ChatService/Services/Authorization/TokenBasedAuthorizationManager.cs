using ChatService.Services.Details;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Text;

namespace ChatService.Services.Authorization
{
    public class TokenBasedAuthorizationManager
    {
        private readonly RequestDelegate _requestDelegate;


        public TokenBasedAuthorizationManager(RequestDelegate requestDelegate)
        {
            _requestDelegate = requestDelegate;
        }

        public async Task Invoke(HttpContext context, IDetailsService detailsService)
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
                attachAccountToContext(context, detailsService, token);
            }


            await _requestDelegate(context);
        }

        private void attachAccountToContext(HttpContext context, IDetailsService detailsService, string token)
        {
            try
            {
                var tokenHandler = new JwtSecurityTokenHandler();
                var key = Encoding.ASCII.GetBytes(Environment.GetEnvironmentVariable("JWT_SIGNING_KEY")!);
                //var key = Encoding.ASCII.GetBytes("1111111111111111");
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

                context.Items["User"] = detailsService.getUserById(accountId);
            }
            catch (Exception e)
            {

                throw;
            }
        }

    }
}
