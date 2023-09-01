namespace AuthService.DTOs
{
    public class GetUserProfileResponse : BasicResponse
    {
        public UserObject User { get; set; } = null!;
        public bool IsFriend { get; set; }
        public IEnumerable<UserObject> Admirers { get; set; } = null!;
        public IEnumerable<AttendedEvent> EventsAttended { get; set; } = null!;
        public IEnumerable<EventObjectAndRatingAverage> MyOwnEvents { get; set; } = null!;
        public int Honors { get; set; }
        public int GivenHonors { get; set; }
        public IEnumerable<AttendedCategory> AttendedCategories { get; set; } = null!;
        public bool FriendRequestSent { get; set; } = false;
    }
}
