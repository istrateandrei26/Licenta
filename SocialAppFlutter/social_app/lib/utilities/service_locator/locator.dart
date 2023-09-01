import 'package:get_it/get_it.dart';
import 'package:social_app/services/auth_service.dart';
import 'package:social_app/services/chat/chat_hub/chat_hub.dart';
import 'package:social_app/services/chat_service.dart';
import 'package:social_app/services/cloudstorage_service.dart';
import 'package:social_app/services/events/event_hub/event_hub.dart';
import 'package:social_app/services/events_service.dart';
import 'package:social_app/services/google/google_calendar_service.dart';
import 'package:social_app/services/google/igoogle_calendar_service.dart';
import 'package:social_app/services/iauth_service.dart';
import 'package:social_app/services/ichat_service.dart';
import 'package:social_app/services/icloudstorage_service.dart';
import 'package:social_app/services/ievents_service.dart';

final provider = GetIt.instance;

void setupServices() {
  provider.registerLazySingleton<IAuthService>(() => AuthService());
  provider.registerLazySingleton<IChatService>(() => ChatService());
  provider.registerLazySingleton<IEventsService>(() => EventsService());
  provider.registerLazySingleton<ChatHub>(() => ChatHub());
  provider.registerLazySingleton<EventHub>(() => EventHub());
  provider
      .registerLazySingleton<ICloudStorageService>(() => CloudStorageService());
  provider
      .registerLazySingleton<IGoogleCalendarService>(() => GoogleCalendarService());
}
