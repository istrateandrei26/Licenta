using System;
using System.Collections.Generic;

namespace AuthService.Models
{
    public partial class Message
    {
        public Message()
        {
            MessageReactions = new HashSet<MessageReaction>();
        }

        public int Id { get; set; }
        public int FromUser { get; set; }
        public int? ToUser { get; set; }
        public string Content { get; set; } = null!;
        public DateTime Datetime { get; set; }
        public int ConversationId { get; set; }
        public bool IsImage { get; set; }
        public bool IsVideo { get; set; }

        public virtual Conversation Conversation { get; set; } = null!;
        public virtual User FromUserNavigation { get; set; } = null!;
        public virtual User? ToUserNavigation { get; set; }
        public virtual ICollection<MessageReaction> MessageReactions { get; set; }
    }
}
