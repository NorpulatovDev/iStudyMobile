import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:istudy/core/injection/injection_container.dart';
import 'package:istudy/core/theme/app_theme.dart';
import 'package:istudy/features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/home/presentation/pages/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>()..add(AuthCheckRequested()),
      child: MaterialApp(
        title: "iStudy SuperAdmin",
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            print("🔍 Current auth state: ${state.runtimeType}");

            if (state is AuthAuthenticated) {
              print("✅ Authenticated: ${state.user.username}");
              return const HomePage();
            }

            print("❌ Showing login page");
            return const LoginPage();
            // if (state is AuthLoading) {
            //   return Scaffold(
            //     body: Center(child: CircularProgressIndicator.adaptive()),
            //   );
            // }

            // if (state is AuthAuthenticated) {
            //   return HomePage();
            // }
            // return LoginPage();
          },
        ),
      ),
    );
  }
}
