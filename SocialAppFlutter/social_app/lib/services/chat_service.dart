import 'dart:convert';

import 'package:social_app/services/chat/get_common_stuff_request.dart';
import 'package:social_app/services/chat/get_common_stuff_response.dart';
import 'package:social_app/services/chat/get_friend_requests_request.dart';
import 'package:social_app/services/chat/get_friend_requests_response.dart';
import 'package:social_app/services/chat/get_friends_request.dart';
import 'package:social_app/services/chat/get_friends_response.dart';
import 'package:social_app/services/chat/retrieve_chatlist_request.dart';
import 'package:social_app/services/chat/retrieve_chatlist_response.dart';
import 'package:social_app/services/chat/retrieve_messages_request.dart';
import 'package:social_app/services/chat/retrieve_messages_response.dart';
import 'package:social_app/services/ichat_service.dart';
import 'package:http/http.dart' as http;
import 'package:social_app/services/profile_service.dart';

import '../utilities/api_utility/api_manager.dart';

class ChatService implements IChatService {
  final httpClient = http.Client();

  @override
  Future<RetrieveChatListResponse?> getChatList(int userId) async {
    var request = RetrieveChatListRequest(userId);

    var url =
        Uri.parse("${ApiManager.chatServiceBaseUrl}${ApiManager.getChatList}");
    var response = await httpClient.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${ProfileService.accessToken}'
        },
        body: jsonEncode(request.toJson()));

    var chatListResponse =
        RetrieveChatListResponse.fromJson(jsonDecode(response.body));

    if (chatListResponse.statusCode == 200) {
      return chatListResponse;
    }

    return null;
  }

  @override
  Future<RetrieveMessagesResponse?> getMessages(
      int userId, int conversationId) async {
    var request = RetrieveMessagesRequest(userId, conversationId);

    var url =
        Uri.parse("${ApiManager.chatServiceBaseUrl}${ApiManager.getMessages}");
    var response = await httpClient.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${ProfileService.accessToken}'
        },
        body: jsonEncode(request.toJson()));

    var messagesResponse =
        RetrieveMessagesResponse.fromJson(jsonDecode(response.body));

    if (messagesResponse.statusCode == 200) {
      return messagesResponse;
    }

    return null;
  }

  @override
  Future<GetFriendRequestsResponse?> getFriendRequests(int userId) async {
    var request = GetFriendRequestsRequest(userId);

    var url = Uri.parse(
        "${ApiManager.chatServiceBaseUrl}${ApiManager.getFriendRequests}");
    var response = await httpClient.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${ProfileService.accessToken}'
        },
        body: jsonEncode(request.toJson()));

    var friendRequestsResponse =
        GetFriendRequestsResponse.fromJson(jsonDecode(response.body));

    if (friendRequestsResponse.statusCode == 200) {
      return friendRequestsResponse;
    }

    return null;
  }

  @override
  Future<GetFriendsResponse?> getFriends(int userId) async{
    var request = GetFriendsRequest(userId);

    var url = Uri.parse(
        "${ApiManager.chatServiceBaseUrl}${ApiManager.getFriends}");
    var response = await httpClient.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${ProfileService.accessToken}'
        },
        body: jsonEncode(request.toJson()));

    var friendsResponse =
        GetFriendsResponse.fromJson(jsonDecode(response.body));

    if (friendsResponse.statusCode == 200) {
      return friendsResponse;
    }

    return null;
  }

  @override
  Future<GetCommonStuffResponse?> getCommonStuff(int userId1, int userId2) async {
    var request = GetCommonStuffRequest(userId1, userId2);

    var url = Uri.parse(
        "${ApiManager.chatServiceBaseUrl}${ApiManager.getCommonStuff}");
    var response = await httpClient.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${ProfileService.accessToken}'
        },
        body: jsonEncode(request.toJson()));

    var getCommonStuffResponse =
        GetCommonStuffResponse.fromJson(jsonDecode(response.body));

    if (getCommonStuffResponse.statusCode == 200) {
      return getCommonStuffResponse;
    }

    return null;
  }
}
