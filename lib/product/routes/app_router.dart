import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../feature/auth/login_view.dart';
import '../../feature/auth/register_view.dart';
import '../../feature/home/bloc/flashcard_cubit.dart';
import '../../feature/home/bloc/notes_cubit.dart';
import '../../feature/home/home_view.dart';
import '../../feature/onboarding/onboarding_view.dart';
import '../../feature/settings/bloc/settings_cubit.dart';
import '../../feature/settings/settings_view.dart';
import '../../feature/splash/splash_view.dart';
import '../constants/app_constants.dart';

/// Uygulama route yönetimi
///
/// Best Practice: Route tanımlamaları merkezi bir yerde yönetilir
class AppRouter {
  const AppRouter._();

  /// Route tablosu
  ///
  /// Not: AuthCubit zaten root level'da olduğu için
  /// burada tekrar oluşturulmaz, sadece ihtiyaç duyulan
  /// sayfaya özel Cubit'ler eklenir
  static Map<String, WidgetBuilder> get routes => {
    AppConstants.routeSplash: (_) => const SplashView(),
    AppConstants.routeOnboarding: (_) => const OnboardingView(),
    AppConstants.routeLogin: (_) => const LoginView(),
    AppConstants.routeRegister: (_) => const RegisterView(),
    AppConstants.routeHome: (_) => MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NotesCubit()),
        BlocProvider(create: (_) => FlashcardCubit()),
      ],
      child: const HomeView(),
    ),
    AppConstants.routeSettings: (_) =>
        BlocProvider(create: (_) => SettingsCubit(), child: const SettingsView()),
  };

  /// Unknown route handler
  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(body: Center(child: Text('Sayfa bulunamadı: ${settings.name}'))),
    );
  }
}
