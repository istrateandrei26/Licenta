using System;
using System.Collections.Generic;

namespace AuthService.Models
{
    public partial class Location
    {
        public Location()
        {
            Events = new HashSet<Event>();
            LocationsSportCategories = new HashSet<LocationsSportCategory>();
        }

        public int Id { get; set; }
        public string City { get; set; } = null!;
        public string LocationName { get; set; } = null!;
        public int? CoordinatesId { get; set; }
        public bool MapChosen { get; set; }

        public virtual LocationCoordinate? Coordinates { get; set; }
        public virtual ICollection<Event> Events { get; set; }
        public virtual ICollection<LocationsSportCategory> LocationsSportCategories { get; set; }
    }
}
