using ChatService.DTOs;
using ChatService.Models;
using ChatService.Services.Details;
using Microsoft.EntityFrameworkCore;

namespace ChatService.Services.User
{
    public class UserService : IUserService
    {
        SportNetContext _context;
        IDetailsService _detailsService;

        public UserService(SportNetContext context, IDetailsService detailsService)
        {
            _context = context;
            _detailsService = detailsService;
        }

        public async Task<IEnumerable<UserObject>> getUserFriends(int userId)
        {
            var friendships = await _context.Friendships.Where(x => x.UserId == userId).ToListAsync(); 

            var result = friendships.Select(x =>  _detailsService.getUserById(x.FriendId));


            if (result != null)
            {
                return result!;
            }
            else
            {
                return new List<UserObject>();
            }


        }


        public async Task<IEnumerable<ConversationObject>> getUserConversations(int userId)
        {
            var conversations = await _context.ConversationMembers.Where(x => x.UserId == userId).ToListAsync();

            var result = conversations.Select(x => _detailsService.getConversationById(x.ConversationId));

            if (result != null)
            {
                return result!;
            }
            else
            {
                return new List<ConversationObject>();
            }
        }

        private async Task<IEnumerable<AttendedCategory>> GetAttendedCategories(int userId)
        {
            var attendedCategoriesWithHonor = (
                    from honor in _context.Honors
                    join ev in _context.Events
                    on honor.EventId equals ev.Id
                    join cat in _context.SportCategories
                    on ev.SportCategory equals cat.Id
                    where honor.ToId == userId
                    group cat by cat.Id into g
                    select new
                    {
                        SportCategoryId = g.Key,
                        Honors = g.Count()
                    }
                )
                .ToList()
                .Select(x => new AttendedCategory
                {
                    SportCategory = _detailsService.getSportCategoryById(x.SportCategoryId)!,
                    Honors = x.Honors
                })
                .ToList();

            var attendedCategories = await (
                from E in _context.Events
                join EM in _context.EventMembers on E.Id equals EM.EventId
                join SP in _context.SportCategories on E.SportCategory equals SP.Id
                join U in _context.Users on EM.MemberId equals U.Id
                where U.Id == userId
                group SP by SP.Id into g
                select g.Key
            ).ToListAsync();


            foreach (var attendedCat in attendedCategories)
            {
                var foundCategory = attendedCategoriesWithHonor.Find(x => x.SportCategory.Id == attendedCat);
                if (foundCategory == null)
                    attendedCategoriesWithHonor.Add(new AttendedCategory
                    {
                        SportCategory = _detailsService.getSportCategoryById(attendedCat)!,
                        Honors = 0
                    });
            }


            return attendedCategoriesWithHonor;
        }

        public async Task<IEnumerable<AttendedCategory>> getCommonAttendedCategories(int userId1, int userId2)
        {
            var attendedCategoriesForUser1 = await GetAttendedCategories(userId1);
            var attendedCategoriesForUser2 = await GetAttendedCategories(userId2);

            var commonAttendedCategories = new List<AttendedCategory>();

            foreach(var attendedByUser1 in attendedCategoriesForUser1)
            {
                if(attendedCategoriesForUser2.Select(x => x.SportCategory.Id).ToList().Contains(attendedByUser1.SportCategory.Id))
                    commonAttendedCategories.Add(attendedByUser1);
            }


            return commonAttendedCategories;

        }

        private async Task<IEnumerable<GroupObject>> getUserGroups(int userId)
        {
            var userGroups = await (
                from conv in _context.Conversations
                join convMemb in _context.ConversationMembers
                on conv.Id equals convMemb.ConversationId
                where conv.IsGroup == true && convMemb.UserId == userId
                select conv
                )
                .ToListAsync();

            var groups = userGroups
                .Select(x => new GroupObject
                {
                    Id = x.Id,
                    GroupName = x.Description!,
                    GroupImage = x.GroupImage != null ? x.GroupImage?.Select(x => (int)x).ToList() : null
                })
                .ToList();

            
            //foreach(var group in groups)
            //{
            //    group.GroupImage = group.GroupImage != null ? group.GroupImage?.Select(x => (int)x).ToList() : null;
            //}

            return groups;
        }

        public async Task<IEnumerable<GroupObject>> getCommonGroups(int userId1, int userId2)
        {
            var groupsForUser1 = await getUserGroups(userId1);
            var groupsForUser2 = await getUserGroups(userId2);

            var commonGroups = new List<GroupObject>();

            foreach (var groupOfUser1 in groupsForUser1)
            {
                if (groupsForUser2.Select(x => x.Id).ToList().Contains(groupOfUser1.Id))
                    commonGroups.Add(groupOfUser1);
            }


            return commonGroups;
        }
    }
}
