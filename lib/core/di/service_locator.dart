import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../product/service/note_service.dart';
import '../network/api_client.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Hive init should be called in main before this in practice; keep here for safety in tests.
  if (!Hive.isBoxOpen('notes_box')) {
    // no-op here; box opens in main.
  }

  serviceLocator.registerLazySingleton<ApiClient>(() => ApiClient());
  serviceLocator.registerLazySingleton<NoteService>(() => NoteService(serviceLocator<ApiClient>()));
}
