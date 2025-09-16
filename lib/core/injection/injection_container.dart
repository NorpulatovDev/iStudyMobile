// lib/core/injection/injection_container.dart
import 'package:get_it/get_it.dart';
import '../../features/reports/data/repositories/report_repository.dart';
import '../../features/reports/presentation/bloc/report_bloc.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';


final sl = GetIt.instance;

Future<void> setupLocator() async {
  // Core services
  sl.registerLazySingleton<StorageService>(() => StorageService());
  sl.registerLazySingleton<ApiService>(() => ApiService());

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepository(sl<ApiService>(), sl<StorageService>()),
  );
  sl.registerLazySingleton<ReportRepository>(
    () => ReportRepository(sl<ApiService>()),
  );



  // BLoCs
  sl.registerLazySingleton<AuthBloc>(() => AuthBloc(sl<AuthRepository>()));
  sl.registerLazySingleton<ReportBloc>(() => ReportBloc(sl<ReportRepository>()));

}