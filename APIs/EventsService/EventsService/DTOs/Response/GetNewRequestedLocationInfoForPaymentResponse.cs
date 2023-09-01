namespace EventsService.DTOs.Response
{
    public class GetNewRequestedLocationInfoForPaymentResponse: BasicResponse
    {
        public SportCategoryObject SportCategory { get; set; } = null!;
        public CoordinatesObject Coordinates { get; set; } = null!;
        public string City { get; set; } = string.Empty;
        public string LocationName { get; set; } = string.Empty;
        public int ApprovedLocationId { get; set; }
        public string OwnerEmail { get; set; } = string.Empty;
        public bool Found { get; set; }
        public bool AlreadyUsed { get; set; }
    }
}
