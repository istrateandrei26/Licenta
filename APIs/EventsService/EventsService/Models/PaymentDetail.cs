using System;
using System.Collections.Generic;

namespace EventsService.Models
{
    public partial class PaymentDetail
    {
        public int Id { get; set; }
        public int RequestedLocationId { get; set; }
        public byte[]? VerificationCode { get; set; }
        public bool Paid { get; set; }

        public virtual RequestedLocation RequestedLocation { get; set; } = null!;
    }
}
