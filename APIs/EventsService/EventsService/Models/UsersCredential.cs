using System;
using System.Collections.Generic;

namespace EventsService.Models
{
    public partial class UsersCredential
    {
        public int UserId { get; set; }
        public string Username { get; set; } = null!;
        public byte[] Password { get; set; } = null!;
        public byte[] Salt { get; set; } = null!;
        public string? RefreshToken { get; set; }

        public virtual User User { get; set; } = null!;
    }
}
