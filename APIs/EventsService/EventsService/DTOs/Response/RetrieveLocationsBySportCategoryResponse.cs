namespace EventsService.DTOs.Response
{
    public class RetrieveLocationsBySportCategoryResponse : BasicResponse
    {
        public IEnumerable<LocationObject> Locations { get; set; } = null!;
        public IEnumerable<AttendedLocation> AttendedLocations { get; set; } = null!;
    }
}
