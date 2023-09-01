using System;
using System.Collections.Generic;

namespace ChatService.Models
{
    public partial class Event
    {
        public Event()
        {
            EventMembers = new HashSet<EventMember>();
            GoogleCalendarEvents = new HashSet<GoogleCalendarEvent>();
            Honors = new HashSet<Honor>();
            Invitations = new HashSet<Invitation>();
            RatedEvents = new HashSet<RatedEvent>();
        }

        public int Id { get; set; }
        public DateTime StartDatetime { get; set; }
        public double Duration { get; set; }
        public int SportCategory { get; set; }
        public int LocationId { get; set; }
        public int CreatorId { get; set; }
        public int RequiredMembersTotal { get; set; }

        public virtual User Creator { get; set; } = null!;
        public virtual Location Location { get; set; } = null!;
        public virtual SportCategory SportCategoryNavigation { get; set; } = null!;
        public virtual ICollection<EventMember> EventMembers { get; set; }
        public virtual ICollection<GoogleCalendarEvent> GoogleCalendarEvents { get; set; }
        public virtual ICollection<Honor> Honors { get; set; }
        public virtual ICollection<Invitation> Invitations { get; set; }
        public virtual ICollection<RatedEvent> RatedEvents { get; set; }
    }
}
