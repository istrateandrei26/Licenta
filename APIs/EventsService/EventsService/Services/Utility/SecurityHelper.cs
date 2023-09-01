using System.Security.Cryptography;

namespace EventsService.Services.Utility
{
    public class SecurityHelper
    {
        public static string GenerateNewLocationVerificationCode(int len)
        {
            var verificationCode = RandomNumberGenerator.GetBytes(len);

            return Convert.ToBase64String(verificationCode);
        }


        public static byte[] ComputeHash(byte[] content)
        {
            var hash = SHA256.HashData(content);

            return hash;
        }
    }
}
