namespace ChatService.DTOs
{
    public class GetCommonStuffResponse: BasicResponse
    {
        public IEnumerable<AttendedCategory> CommonAttendedCategories { get; set; } = null!;
        public IEnumerable<GroupObject> CommonGroups { get; set; } = null!;
    }
}
