using System;
using System.Collections.Generic;

namespace ChatService.Models
{
    public partial class LocationsSportCategory
    {
        public int Id { get; set; }
        public int LocationId { get; set; }
        public int? SportCategoryId { get; set; }

        public virtual Location Location { get; set; } = null!;
        public virtual SportCategory? SportCategory { get; set; }
    }
}
