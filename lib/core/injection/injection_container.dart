import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:istudy/core/services/api_service.dart';
import 'package:istudy/core/services/storage_service.dart';
import 'package:istudy/features/auth/data/repositories/auth_repository.dart';
import 'package:istudy/features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  // Core services
  sl.registerLazySingleton<StorageService>(() => StorageService());
  sl.registerLazySingleton<ApiService>(() => ApiService());

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepository(sl<ApiService>(), sl<StorageService>()),
  );

  // BLoCs
  sl.registerLazySingleton<AuthBloc>(()=> AuthBloc(sl<AuthRepository>()));
}
