namespace EventsService.DTOs.Response
{
    public class GetRequestedLocationsResponse
    {
        public IEnumerable<RequestedLocationObject> RequestedLocations { get; set; } = null!;
    }
}
