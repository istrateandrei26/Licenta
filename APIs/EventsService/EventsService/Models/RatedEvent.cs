using System;
using System.Collections.Generic;

namespace EventsService.Models
{
    public partial class RatedEvent
    {
        public int Id { get; set; }
        public int FromId { get; set; }
        public int EventId { get; set; }
        public int? Rating { get; set; }

        public virtual Event Event { get; set; } = null!;
        public virtual User From { get; set; } = null!;
    }
}
