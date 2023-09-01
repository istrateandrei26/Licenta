namespace EventsService.DTOs.Request
{
    public class CreateEventRequest
    {
        public int SportCategoryId { get; set; }
        public int LocationId { get; set; }
        public int CreatorId { get; set; }
        public int RequiredMembers { get; set; }
        public List<int> AllMembers { get; set; } = null!;
        public DateTime StartDatetime { get; set; }
        public double Duration { get; set; }
        public bool CreateNewLocation { get; set; }
        public double Lat { get; set; }
        public double Long { get; set; }
        public string City { get; set; } = string.Empty;
        public string LocationName { get; set; } = string.Empty;
    }
}
