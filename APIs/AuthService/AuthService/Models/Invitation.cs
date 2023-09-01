using System;
using System.Collections.Generic;

namespace AuthService.Models
{
    public partial class Invitation
    {
        public int Id { get; set; }
        public int? FromId { get; set; }
        public int ToId { get; set; }
        public int EventId { get; set; }
        public bool Accepted { get; set; }

        public virtual Event Event { get; set; } = null!;
        public virtual User? From { get; set; }
        public virtual User To { get; set; } = null!;
    }
}
