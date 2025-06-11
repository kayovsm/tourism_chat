// lib/app/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'data/datasources/auth_datasource.dart';
import 'data/datasources/message_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/message_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/message_repository.dart';
import 'domain/usecases/auth/login_usecase.dart';
import 'domain/usecases/auth/logout_usecase.dart';
import 'domain/usecases/auth/register_usecase.dart';
import 'domain/usecases/messages/get_message_usecase.dart';
import 'domain/usecases/messages/send_message_usecase.dart';
import 'presentation/stores/auth_store.dart';
import 'presentation/stores/message_store.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  // Data sources
  sl.registerLazySingleton<AuthDataSource>(
        () => FirebaseAuthDataSource(firebaseAuth: sl()),
  );
  sl.registerLazySingleton<MessageDataSource>(
        () => FirebaseMessageDataSource(firestore: sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<MessageRepository>(
        () => MessageRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => SendMessageUseCase(sl()));
  sl.registerLazySingleton(() => GetMessageUseCase(sl()));

  // Stores
  sl.registerLazySingleton(
        () => AuthStore(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(
        () => MessageStore(
      sendMessageUseCase: sl(),
      getMessageUseCase: sl(),
    ),
  );
}