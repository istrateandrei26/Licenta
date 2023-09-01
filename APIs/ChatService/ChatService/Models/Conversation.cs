using System;
using System.Collections.Generic;

namespace ChatService.Models
{
    public partial class Conversation
    {
        public Conversation()
        {
            ConversationMembers = new HashSet<ConversationMember>();
            Messages = new HashSet<Message>();
        }

        public int Id { get; set; }
        public string? Description { get; set; }
        public byte[]? GroupImage { get; set; }
        public bool IsGroup { get; set; }

        public virtual ICollection<ConversationMember> ConversationMembers { get; set; }
        public virtual ICollection<Message> Messages { get; set; }
    }
}
