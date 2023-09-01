using System;
using System.Collections.Generic;

namespace AuthService.Models
{
    public partial class UsersProfileImage
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public byte[] ProfileImage { get; set; } = null!;

        public virtual User User { get; set; } = null!;
    }
}
