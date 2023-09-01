using Microsoft.CodeAnalysis.CSharp.Syntax;

namespace AuthService.DTOs
{
    public class ChangePasswordResponse : BasicResponse
    {
        public string ResetCode { get; set; } = string.Empty;
    }
}
