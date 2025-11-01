import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/theme_cubit.dart';
import 'product/initialize/application_start.dart';
import 'feature/auth/bloc/auth_cubit.dart';
import 'feature/auth/login_view.dart';
import 'feature/auth/register_view.dart';
import 'feature/home/bloc/notes_cubit.dart';
import 'feature/home/home_view.dart';
import 'feature/settings/bloc/settings_cubit.dart';
import 'feature/settings/settings_view.dart';
import 'feature/splash/splash_view.dart';
import 'product/constants/app_constants.dart';
import 'product/constants/app_theme.dart';

Future<void> main() async {
  await ApplicationStart.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Note App Turbo',

            // Tema yapılandırması
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.themeMode,

            initialRoute: AppConstants.routeSplash,
            routes: {
              AppConstants.routeSplash: (_) =>
                  BlocProvider(create: (_) => AuthCubit(), child: const SplashView()),
              AppConstants.routeLogin: (_) =>
                  BlocProvider(create: (_) => AuthCubit(), child: const LoginView()),
              AppConstants.routeRegister: (_) =>
                  BlocProvider(create: (_) => AuthCubit(), child: const RegisterView()),
              AppConstants.routeHome: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(create: (_) => AuthCubit()),
                  BlocProvider(create: (_) => NotesCubit()),
                ],
                child: const HomeView(),
              ),
              AppConstants.routeSettings: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(create: (_) => SettingsCubit()),
                  BlocProvider(create: (_) => AuthCubit()),
                ],
                child: const SettingsView(),
              ),
            },
          );
        },
      ),
    );
  }
}
