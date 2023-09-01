namespace EventsService.DTOs.Response
{
    public class RetrieveEventReviewInfoResponse: BasicResponse
    {
        public IEnumerable<EventReviewInfo> EventReviewInfos { get; set; } = null!;
    }
}
