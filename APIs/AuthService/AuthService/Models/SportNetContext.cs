using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace AuthService.Models
{
    public partial class SportNetContext : DbContext
    {
        public SportNetContext()
        {
        }

        public SportNetContext(DbContextOptions<SportNetContext> options)
            : base(options)
        {
        }

        public virtual DbSet<AccountPasswordReset> AccountPasswordResets { get; set; } = null!;
        public virtual DbSet<Conversation> Conversations { get; set; } = null!;
        public virtual DbSet<ConversationMember> ConversationMembers { get; set; } = null!;
        public virtual DbSet<Event> Events { get; set; } = null!;
        public virtual DbSet<EventMember> EventMembers { get; set; } = null!;
        public virtual DbSet<FriendRequest> FriendRequests { get; set; } = null!;
        public virtual DbSet<Friendship> Friendships { get; set; } = null!;
        public virtual DbSet<GoogleCalendarEvent> GoogleCalendarEvents { get; set; } = null!;
        public virtual DbSet<Honor> Honors { get; set; } = null!;
        public virtual DbSet<Invitation> Invitations { get; set; } = null!;
        public virtual DbSet<Location> Locations { get; set; } = null!;
        public virtual DbSet<LocationCoordinate> LocationCoordinates { get; set; } = null!;
        public virtual DbSet<LocationsSportCategory> LocationsSportCategories { get; set; } = null!;
        public virtual DbSet<Message> Messages { get; set; } = null!;
        public virtual DbSet<MessageReaction> MessageReactions { get; set; } = null!;
        public virtual DbSet<PaymentDetail> PaymentDetails { get; set; } = null!;
        public virtual DbSet<RatedEvent> RatedEvents { get; set; } = null!;
        public virtual DbSet<RequestedLocation> RequestedLocations { get; set; } = null!;
        public virtual DbSet<SportCategory> SportCategories { get; set; } = null!;
        public virtual DbSet<User> Users { get; set; } = null!;
        public virtual DbSet<UserDevice> UserDevices { get; set; } = null!;
        public virtual DbSet<UserSport> UserSports { get; set; } = null!;
        public virtual DbSet<UsersCredential> UsersCredentials { get; set; } = null!;
        public virtual DbSet<UsersProfileImage> UsersProfileImages { get; set; } = null!;

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
//#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
                optionsBuilder.UseSqlServer("Server=ISTRATE;Database=SportNet;Trusted_Connection=True;");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<AccountPasswordReset>(entity =>
            {
                entity.ToTable("AccountPasswordReset");

                entity.Property(e => e.ExpiryDate).HasColumnType("datetime");

                entity.Property(e => e.ResetCode)
                    .HasMaxLength(32)
                    .IsFixedLength();

                entity.HasOne(d => d.User)
                    .WithMany(p => p.AccountPasswordResets)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_AccountPasswordReset_Users");
            });

            modelBuilder.Entity<Conversation>(entity =>
            {
                entity.Property(e => e.Description).HasMaxLength(50);
            });

            modelBuilder.Entity<ConversationMember>(entity =>
            {
                entity.HasKey(e => new { e.UserId, e.ConversationId });

                entity.Property(e => e.UserId).HasColumnName("UserID");

                entity.Property(e => e.ConversationId).HasColumnName("ConversationID");

                entity.Property(e => e.JoinedDatetime).HasColumnType("datetime");

                entity.Property(e => e.LeftDatetime).HasColumnType("datetime");

                entity.HasOne(d => d.Conversation)
                    .WithMany(p => p.ConversationMembers)
                    .HasForeignKey(d => d.ConversationId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_GroupMember_Conversation");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.ConversationMembers)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_GroupMember_User");
            });

            modelBuilder.Entity<Event>(entity =>
            {
                entity.Property(e => e.StartDatetime).HasColumnType("datetime");

                entity.HasOne(d => d.Creator)
                    .WithMany(p => p.Events)
                    .HasForeignKey(d => d.CreatorId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Events_Users");

                entity.HasOne(d => d.Location)
                    .WithMany(p => p.Events)
                    .HasForeignKey(d => d.LocationId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Events_Locations");

                entity.HasOne(d => d.SportCategoryNavigation)
                    .WithMany(p => p.Events)
                    .HasForeignKey(d => d.SportCategory)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Events_SportCategory");
            });

            modelBuilder.Entity<EventMember>(entity =>
            {
                entity.HasOne(d => d.Event)
                    .WithMany(p => p.EventMembers)
                    .HasForeignKey(d => d.EventId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_EventMembers_Events");

                entity.HasOne(d => d.Member)
                    .WithMany(p => p.EventMembers)
                    .HasForeignKey(d => d.MemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_EventMembers_Users");
            });

            modelBuilder.Entity<FriendRequest>(entity =>
            {
                entity.HasOne(d => d.FromUser)
                    .WithMany(p => p.FriendRequestFromUsers)
                    .HasForeignKey(d => d.FromUserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_FriendRequests_FriendRequests");

                entity.HasOne(d => d.ToUser)
                    .WithMany(p => p.FriendRequestToUsers)
                    .HasForeignKey(d => d.ToUserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_FriendRequests_Users");
            });

            modelBuilder.Entity<Friendship>(entity =>
            {
                entity.ToTable("Friendship");

                entity.HasOne(d => d.Friend)
                    .WithMany(p => p.FriendshipFriends)
                    .HasForeignKey(d => d.FriendId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Friendship_Users1");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.FriendshipUsers)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Friendship_Users");
            });

            modelBuilder.Entity<GoogleCalendarEvent>(entity =>
            {
                entity.ToTable("GoogleCalendarEvent");

                entity.Property(e => e.GoogleCalendarEventId).HasMaxLength(50);

                entity.HasOne(d => d.Event)
                    .WithMany(p => p.GoogleCalendarEvents)
                    .HasForeignKey(d => d.EventId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_GoogleCalendarEvent_Events");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.GoogleCalendarEvents)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_GoogleCalendarEvent_Users");
            });

            modelBuilder.Entity<Honor>(entity =>
            {
                entity.HasOne(d => d.Event)
                    .WithMany(p => p.Honors)
                    .HasForeignKey(d => d.EventId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Honors_Events");

                entity.HasOne(d => d.From)
                    .WithMany(p => p.HonorFroms)
                    .HasForeignKey(d => d.FromId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Honors_Users");

                entity.HasOne(d => d.To)
                    .WithMany(p => p.HonorTos)
                    .HasForeignKey(d => d.ToId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Honors_Users1");
            });

            modelBuilder.Entity<Invitation>(entity =>
            {
                entity.HasOne(d => d.Event)
                    .WithMany(p => p.Invitations)
                    .HasForeignKey(d => d.EventId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Invitations_Events");

                entity.HasOne(d => d.From)
                    .WithMany(p => p.InvitationFroms)
                    .HasForeignKey(d => d.FromId)
                    .HasConstraintName("FK_Invitations_Users");

                entity.HasOne(d => d.To)
                    .WithMany(p => p.InvitationTos)
                    .HasForeignKey(d => d.ToId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Invitations_Users1");
            });

            modelBuilder.Entity<Location>(entity =>
            {
                entity.Property(e => e.City).HasMaxLength(100);

                entity.Property(e => e.LocationName)
                    .HasMaxLength(100)
                    .IsFixedLength();

                entity.HasOne(d => d.Coordinates)
                    .WithMany(p => p.Locations)
                    .HasForeignKey(d => d.CoordinatesId)
                    .HasConstraintName("FK_Locations_LocationCoordinates");
            });

            modelBuilder.Entity<LocationCoordinate>(entity =>
            {
                entity.Property(e => e.Latitude).HasColumnType("decimal(8, 6)");

                entity.Property(e => e.Longitude).HasColumnType("decimal(9, 6)");
            });

            modelBuilder.Entity<LocationsSportCategory>(entity =>
            {
                entity.HasOne(d => d.Location)
                    .WithMany(p => p.LocationsSportCategories)
                    .HasForeignKey(d => d.LocationId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_LocationsSportCategories_Locations");

                entity.HasOne(d => d.SportCategory)
                    .WithMany(p => p.LocationsSportCategories)
                    .HasForeignKey(d => d.SportCategoryId)
                    .HasConstraintName("FK_LocationsSportCategories_SportCategory");
            });

            modelBuilder.Entity<Message>(entity =>
            {
                entity.Property(e => e.Content).HasMaxLength(1000);

                entity.Property(e => e.ConversationId).HasColumnName("ConversationID");

                entity.Property(e => e.Datetime).HasColumnType("datetime");

                entity.Property(e => e.IsImage).HasColumnName("isImage");

                entity.Property(e => e.IsVideo).HasColumnName("isVideo");

                entity.HasOne(d => d.Conversation)
                    .WithMany(p => p.Messages)
                    .HasForeignKey(d => d.ConversationId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Messages_Conversations");

                entity.HasOne(d => d.FromUserNavigation)
                    .WithMany(p => p.MessageFromUserNavigations)
                    .HasForeignKey(d => d.FromUser)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Message_Conversation");

                entity.HasOne(d => d.ToUserNavigation)
                    .WithMany(p => p.MessageToUserNavigations)
                    .HasForeignKey(d => d.ToUser)
                    .HasConstraintName("FK_Messages_Users");
            });

            modelBuilder.Entity<MessageReaction>(entity =>
            {
                entity.HasOne(d => d.Message)
                    .WithMany(p => p.MessageReactions)
                    .HasForeignKey(d => d.MessageId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_MessageReactions_Messages");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.MessageReactions)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_MessageReactions_Users");
            });

            modelBuilder.Entity<PaymentDetail>(entity =>
            {
                entity.Property(e => e.VerificationCode)
                    .HasMaxLength(32)
                    .IsFixedLength();

                entity.HasOne(d => d.RequestedLocation)
                    .WithMany(p => p.PaymentDetails)
                    .HasForeignKey(d => d.RequestedLocationId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_PaymentDetails_RequestedLocation");
            });

            modelBuilder.Entity<RatedEvent>(entity =>
            {
                entity.HasOne(d => d.Event)
                    .WithMany(p => p.RatedEvents)
                    .HasForeignKey(d => d.EventId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_RatedEvents_Events");

                entity.HasOne(d => d.From)
                    .WithMany(p => p.RatedEvents)
                    .HasForeignKey(d => d.FromId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_RatedEvents_Users");
            });

            modelBuilder.Entity<RequestedLocation>(entity =>
            {
                entity.ToTable("RequestedLocation");

                entity.Property(e => e.City).HasMaxLength(100);

                entity.Property(e => e.Latitude).HasColumnType("decimal(8, 6)");

                entity.Property(e => e.LocationName).HasMaxLength(100);

                entity.Property(e => e.Longitude).HasColumnType("decimal(8, 6)");

                entity.Property(e => e.OwnerEmail).HasMaxLength(100);

                entity.HasOne(d => d.SportCategory)
                    .WithMany(p => p.RequestedLocations)
                    .HasForeignKey(d => d.SportCategoryId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_RequestedLocation_SportCategory");
            });

            modelBuilder.Entity<SportCategory>(entity =>
            {
                entity.ToTable("SportCategory");

                entity.Property(e => e.Image).HasMaxLength(100);

                entity.Property(e => e.Name).HasMaxLength(100);
            });

            modelBuilder.Entity<User>(entity =>
            {
                entity.Property(e => e.Email).HasMaxLength(100);

                entity.Property(e => e.Firstname).HasMaxLength(100);

                entity.Property(e => e.Lastname).HasMaxLength(100);
            });

            modelBuilder.Entity<UserDevice>(entity =>
            {
                entity.ToTable("UserDevice");

                entity.HasOne(d => d.User)
                    .WithMany(p => p.UserDevices)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_UserDevice_Users");
            });

            modelBuilder.Entity<UsersCredential>(entity =>
            {
                entity.HasKey(e => e.UserId);

                entity.Property(e => e.UserId)
                    .ValueGeneratedNever()
                    .HasColumnName("UserID");

                entity.Property(e => e.Password)
                    .HasMaxLength(32)
                    .IsFixedLength();

                entity.Property(e => e.RefreshToken).HasMaxLength(44);

                entity.Property(e => e.Salt)
                    .HasMaxLength(8)
                    .IsFixedLength();

                entity.Property(e => e.Username).HasMaxLength(100);

                entity.HasOne(d => d.User)
                    .WithOne(p => p.UsersCredential)
                    .HasForeignKey<UsersCredential>(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_UsersCredentials_User");
            });

            modelBuilder.Entity<UsersProfileImage>(entity =>
            {
                entity.HasOne(d => d.User)
                    .WithMany(p => p.UsersProfileImages)
                    .HasForeignKey(d => d.UserId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_UsersProfileImages_Users");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
