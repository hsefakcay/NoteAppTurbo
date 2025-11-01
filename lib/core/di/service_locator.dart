import 'package:get_it/get_it.dart';

import '../../product/repository/notes_repository.dart';
import '../../product/service/connectivity_service.dart';
import '../../product/service/note_service.dart';
import '../../product/service/notes_sort_filter_service.dart';
import '../../product/service/offline_sync_coordinator.dart';
import '../../product/service/sync_queue_service.dart';
import '../network/api_client.dart';

final GetIt serviceLocator = GetIt.instance;

/// Dependency Injection kurulumu (Clean Architecture)
Future<void> setupServiceLocator() async {
  // Core services
  final apiClient = ApiClient();
  serviceLocator.registerLazySingleton<ApiClient>(() => apiClient);

  // Connectivity service
  serviceLocator.registerLazySingleton<ConnectivityService>(
    () => ConnectivityService(apiClient.client),
  );

  // Note service
  serviceLocator.registerLazySingleton<NoteService>(() => NoteService(serviceLocator<ApiClient>()));

  // Sync queue service
  serviceLocator.registerLazySingleton<SyncQueueService>(
    () => SyncQueueService(serviceLocator<NoteService>()),
  );

  // Repository
  serviceLocator.registerLazySingleton<NotesRepository>(() => NotesRepository());

  // Sort & Filter service
  serviceLocator.registerLazySingleton<NotesSortFilterService>(() => NotesSortFilterService());

  // Offline sync coordinator
  serviceLocator.registerLazySingleton<OfflineSyncCoordinator>(
    () => OfflineSyncCoordinator(
      noteService: serviceLocator<NoteService>(),
      syncQueue: serviceLocator<SyncQueueService>(),
      connectivity: serviceLocator<ConnectivityService>(),
    ),
  );
}
