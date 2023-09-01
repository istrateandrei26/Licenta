using System;
using System.Collections.Generic;

namespace AuthService.Models
{
    public partial class LocationCoordinate
    {
        public LocationCoordinate()
        {
            Locations = new HashSet<Location>();
        }

        public int Id { get; set; }
        public decimal Latitude { get; set; }
        public decimal Longitude { get; set; }

        public virtual ICollection<Location> Locations { get; set; }
    }
}
