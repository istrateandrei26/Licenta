using System;
using System.Collections.Generic;

namespace EventsService.Models
{
    public partial class GoogleCalendarEvent
    {
        public int Id { get; set; }
        public string GoogleCalendarEventId { get; set; } = null!;
        public int UserId { get; set; }
        public int EventId { get; set; }

        public virtual Event Event { get; set; } = null!;
        public virtual User User { get; set; } = null!;
    }
}
