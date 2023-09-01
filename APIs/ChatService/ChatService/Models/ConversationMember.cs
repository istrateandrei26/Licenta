using System;
using System.Collections.Generic;

namespace ChatService.Models
{
    public partial class ConversationMember
    {
        public int UserId { get; set; }
        public int ConversationId { get; set; }
        public DateTime JoinedDatetime { get; set; }
        public DateTime? LeftDatetime { get; set; }

        public virtual Conversation Conversation { get; set; } = null!;
        public virtual User User { get; set; } = null!;
    }
}
