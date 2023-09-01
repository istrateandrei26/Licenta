﻿using System;
using System.Collections.Generic;

namespace EventsService.Models
{
    public partial class UserDevice
    {
        public int Id { get; set; }
        public int UserId { get; set; }
        public string DeviceId { get; set; } = null!;

        public virtual User User { get; set; } = null!;
    }
}