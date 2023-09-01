using System;
using System.Collections.Generic;

namespace AuthService.Models
{
    public partial class AccountPasswordReset
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public byte[] ResetCode { get; set; } = null!;
        public DateTime ExpiryDate { get; set; }
        public bool Used { get; set; }

        public virtual User User { get; set; } = null!;
    }
}
