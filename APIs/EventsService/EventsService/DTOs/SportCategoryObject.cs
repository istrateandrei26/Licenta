﻿using Newtonsoft.Json;

namespace EventsService.DTOs
{
    public class SportCategoryObject
    {
        [JsonProperty("id")]
        public int Id{ get; set; }
        [JsonProperty("name")]
        public string Name { get; set; } = null!;
        [JsonProperty("image")]
        public string Image { get; set; } = null!;
    }
}
