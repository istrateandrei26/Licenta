using System;
using System.Collections.Generic;

namespace ChatService.Models
{
    public partial class EventMember
    {
        public int Id { get; set; }
        public int EventId { get; set; }
        public int MemberId { get; set; }

        public virtual Event Event { get; set; } = null!;
        public virtual User Member { get; set; } = null!;
    }
}
