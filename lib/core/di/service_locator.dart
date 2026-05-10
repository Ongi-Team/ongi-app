import 'package:get_it/get_it.dart';
import 'package:ongi_app/data/network/api_client.dart';
import 'package:ongi_app/data/repositories/secure_storage_repository.dart';
import 'package:ongi_app/data/services/auth_service.dart';
import 'package:ongi_app/data/services/auth_session.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<SecureStorageRepository>(
    () => SecureStorageRepository(),
  );
  getIt.registerLazySingleton<AuthSession>(() => AuthSession());
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(),
  );
  getIt.registerLazySingleton<AuthService>(
    () => AuthService(
      getIt<ApiClient>().dio,
      getIt<SecureStorageRepository>(),
    ),
  );
}
