using System;
using System.Collections.Generic;

namespace EventsService.Models
{
    public partial class RequestedLocation
    {
        public RequestedLocation()
        {
            PaymentDetails = new HashSet<PaymentDetail>();
        }

        public int Id { get; set; }
        public string City { get; set; } = null!;
        public string LocationName { get; set; } = null!;
        public decimal Latitude { get; set; }
        public decimal Longitude { get; set; }
        public bool Approved { get; set; }
        public string OwnerEmail { get; set; } = null!;
        public int SportCategoryId { get; set; }

        public virtual SportCategory SportCategory { get; set; } = null!;
        public virtual ICollection<PaymentDetail> PaymentDetails { get; set; }
    }
}
