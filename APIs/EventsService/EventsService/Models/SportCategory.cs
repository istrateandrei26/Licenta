using System;
using System.Collections.Generic;

namespace EventsService.Models
{
    public partial class SportCategory
    {
        public SportCategory()
        {
            Events = new HashSet<Event>();
            LocationsSportCategories = new HashSet<LocationsSportCategory>();
            RequestedLocations = new HashSet<RequestedLocation>();
        }

        public int Id { get; set; }
        public string Name { get; set; } = null!;
        public string? Image { get; set; }

        public virtual ICollection<Event> Events { get; set; }
        public virtual ICollection<LocationsSportCategory> LocationsSportCategories { get; set; }
        public virtual ICollection<RequestedLocation> RequestedLocations { get; set; }
    }
}
