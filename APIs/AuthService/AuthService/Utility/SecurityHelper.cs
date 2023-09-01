using AuthService.Models;
using Microsoft.IdentityModel.Tokens;
using Org.BouncyCastle.Utilities;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;

namespace AuthService.Utility
{
    public class SecurityHelper
    {
        public static byte[] ComputeHash(byte[] content)
        {
            var hash = SHA256.HashData(content);

            return hash;
        }

        public static byte[] GenerateSalt(int len)
        {
            var salt = RandomNumberGenerator.GetBytes(len);

            return salt;
        }

        public static byte[] GenerateRandomPassword(int len)
        {
            var randomPassword = RandomNumberGenerator.GetBytes(len);

            return randomPassword;
        }


        public static string GeneratePasswordResetCode(int len)
        {
            var passwordResetCode = RandomNumberGenerator.GetBytes(len);

            return Convert.ToBase64String(passwordResetCode);
        }

        public static string GenerateAccessToken(UsersCredential user)
        {
            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.ASCII.GetBytes(Environment.GetEnvironmentVariable("JWT_SIGNING_KEY")!);
            //var key = Encoding.ASCII.GetBytes("1111111111111111");                          //16 bytes symmetric key
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new[] { new Claim("id", user.UserId.ToString()) }),
                Expires = DateTime.Now.AddDays(1),
                SigningCredentials = new SigningCredentials(
                    new SymmetricSecurityKey(key),
                    SecurityAlgorithms.HmacSha256Signature)
            };

            var token = tokenHandler.CreateToken(tokenDescriptor);
            return tokenHandler.WriteToken(token);
        }

        public static string GenerateRefreshToken()
        {
            var random = new byte[32];

            using (var rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(random);
                return Convert.ToBase64String(random);
            }

        }
        public static ClaimsPrincipal GetPrincipalFromExpiredToken(string token)
        {
            var tokenHandler = new JwtSecurityTokenHandler();

            //var key = Encoding.UTF8.GetBytes("1111111111111111");
            var key = Encoding.ASCII.GetBytes(Environment.GetEnvironmentVariable("JWT_SIGNING_KEY")!);

            var principal = tokenHandler.ValidateToken(token, new TokenValidationParameters
            {
                ValidateIssuerSigningKey = true,
                IssuerSigningKey = new SymmetricSecurityKey(key),
                ValidateIssuer = false,
                ValidateAudience = false,
                ValidateLifetime = false,
            }, out SecurityToken validatedToken);

            var obtainedToken = (JwtSecurityToken)validatedToken;
            if (obtainedToken == null || !obtainedToken.Header.Alg.Equals(SecurityAlgorithms.HmacSha256, StringComparison.InvariantCulture))
                throw new SecurityTokenException("Invalid Token");

            return principal;
        }
    }
}
