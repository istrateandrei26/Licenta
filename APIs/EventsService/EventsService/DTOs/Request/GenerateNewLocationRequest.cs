namespace EventsService.DTOs.Request
{
    public class GenerateNewLocationRequest
    {
        public string City { get; set; } = string.Empty;
        public string LocationName { get; set; } = string.Empty;
        public double Latitude { get; set; }
        public double Longitude { get; set; }
        public string OwnerEmail { get; set; } = string.Empty;
        public int SportCategoryId { get; set; }
    }
}
