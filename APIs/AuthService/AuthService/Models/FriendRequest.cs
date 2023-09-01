using System;
using System.Collections.Generic;

namespace AuthService.Models
{
    public partial class FriendRequest
    {
        public int Id { get; set; }
        public int FromUserId { get; set; }
        public int ToUserId { get; set; }
        public bool Accepted { get; set; }

        public virtual User FromUser { get; set; } = null!;
        public virtual User ToUser { get; set; } = null!;
    }
}
