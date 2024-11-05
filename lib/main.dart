import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lsdc_man/blocs/daily_entry/daily_entry_bloc.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_event.dart';
import 'blocs/auth/auth_state.dart';
import 'features/auth/screens/authenticated_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'repositories/auth_repository.dart';
import 'repositories/daily_entry_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final getIt = GetIt.instance;
  // Initialize AuthRepository with persistent store
  final authRepo = await AuthRepository.initialize();
  getIt.registerSingleton<AuthRepository>(authRepo);

  // Register DailyEntryRepository
  getIt.registerSingleton<DailyEntryRepository>(
    DailyEntryRepository(authRepo.pb),
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            authRepository: GetIt.I<AuthRepository>(),
          )..add(AuthCheckRequested()),
        ),
        BlocProvider(
          create: (context) => DailyEntryBloc(
            dailyEntryRepository: GetIt.I<DailyEntryRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return switch (state.status) {
              AuthStatus.initial => const Center(
                  child: CircularProgressIndicator(),
                ),
              AuthStatus.authenticated => const AuthenticatedScreen(),
              AuthStatus.unauthenticated => const LoginScreen(),
            };
          },
        ),
      ),
    );
  }
}
