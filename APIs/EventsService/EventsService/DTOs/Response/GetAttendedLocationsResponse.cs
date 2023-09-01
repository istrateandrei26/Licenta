namespace EventsService.DTOs.Response
{
    public class GetAttendedLocationsResponse : BasicResponse
    {
        public IEnumerable<AttendedLocation> AttendedLocations { get; set; } = null!;
    }
}
