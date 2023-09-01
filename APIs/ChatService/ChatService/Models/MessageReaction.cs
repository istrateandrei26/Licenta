﻿using System;
using System.Collections.Generic;

namespace ChatService.Models
{
    public partial class MessageReaction
    {
        public int Id { get; set; }
        public int MessageId { get; set; }
        public int UserId { get; set; }

        public virtual Message Message { get; set; } = null!;
        public virtual User User { get; set; } = null!;
    }
}
