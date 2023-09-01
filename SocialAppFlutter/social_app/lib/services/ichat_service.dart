import 'package:social_app/services/chat/get_common_stuff_response.dart';
import 'package:social_app/services/chat/get_friend_requests_response.dart';
import 'package:social_app/services/chat/get_friends_response.dart';
import 'package:social_app/services/chat/retrieve_messages_response.dart';

import 'chat/retrieve_chatlist_response.dart';

abstract class IChatService {
  Future<RetrieveChatListResponse?> getChatList(int userId);
  Future<RetrieveMessagesResponse?> getMessages(int userId, int conversationId);
  Future<GetFriendRequestsResponse?> getFriendRequests(int userId);
  Future<GetFriendsResponse?> getFriends(int userId);
  Future<GetCommonStuffResponse?> getCommonStuff(int userId1, int userId2);
}
