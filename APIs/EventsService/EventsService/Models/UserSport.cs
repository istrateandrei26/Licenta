using System;
using System.Collections.Generic;

namespace EventsService.Models
{
    public partial class UserSport
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public int SportId { get; set; }
    }
}
