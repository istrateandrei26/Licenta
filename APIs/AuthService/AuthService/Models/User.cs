using System;
using System.Collections.Generic;

namespace AuthService.Models
{
    public partial class User
    {
        public User()
        {
            AccountPasswordResets = new HashSet<AccountPasswordReset>();
            ConversationMembers = new HashSet<ConversationMember>();
            EventMembers = new HashSet<EventMember>();
            Events = new HashSet<Event>();
            FriendRequestFromUsers = new HashSet<FriendRequest>();
            FriendRequestToUsers = new HashSet<FriendRequest>();
            FriendshipFriends = new HashSet<Friendship>();
            FriendshipUsers = new HashSet<Friendship>();
            GoogleCalendarEvents = new HashSet<GoogleCalendarEvent>();
            HonorFroms = new HashSet<Honor>();
            HonorTos = new HashSet<Honor>();
            InvitationFroms = new HashSet<Invitation>();
            InvitationTos = new HashSet<Invitation>();
            MessageFromUserNavigations = new HashSet<Message>();
            MessageReactions = new HashSet<MessageReaction>();
            MessageToUserNavigations = new HashSet<Message>();
            RatedEvents = new HashSet<RatedEvent>();
            UserDevices = new HashSet<UserDevice>();
            UsersProfileImages = new HashSet<UsersProfileImage>();
        }

        public int Id { get; set; }
        public string Email { get; set; } = null!;
        public string Firstname { get; set; } = null!;
        public string Lastname { get; set; } = null!;
        public byte[]? ProfileImage { get; set; }

        public virtual UsersCredential UsersCredential { get; set; } = null!;
        public virtual ICollection<AccountPasswordReset> AccountPasswordResets { get; set; }
        public virtual ICollection<ConversationMember> ConversationMembers { get; set; }
        public virtual ICollection<EventMember> EventMembers { get; set; }
        public virtual ICollection<Event> Events { get; set; }
        public virtual ICollection<FriendRequest> FriendRequestFromUsers { get; set; }
        public virtual ICollection<FriendRequest> FriendRequestToUsers { get; set; }
        public virtual ICollection<Friendship> FriendshipFriends { get; set; }
        public virtual ICollection<Friendship> FriendshipUsers { get; set; }
        public virtual ICollection<GoogleCalendarEvent> GoogleCalendarEvents { get; set; }
        public virtual ICollection<Honor> HonorFroms { get; set; }
        public virtual ICollection<Honor> HonorTos { get; set; }
        public virtual ICollection<Invitation> InvitationFroms { get; set; }
        public virtual ICollection<Invitation> InvitationTos { get; set; }
        public virtual ICollection<Message> MessageFromUserNavigations { get; set; }
        public virtual ICollection<MessageReaction> MessageReactions { get; set; }
        public virtual ICollection<Message> MessageToUserNavigations { get; set; }
        public virtual ICollection<RatedEvent> RatedEvents { get; set; }
        public virtual ICollection<UserDevice> UserDevices { get; set; }
        public virtual ICollection<UsersProfileImage> UsersProfileImages { get; set; }
    }
}
