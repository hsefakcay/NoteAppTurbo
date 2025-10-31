import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../product/constants/app_constants.dart';
import '../auth/bloc/auth_cubit.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final auth = context.read<AuthCubit>();
      await auth.checkAuth();
      if (!mounted) return;
      if (auth.state.isAuthenticated) {
        Navigator.of(context).pushReplacementNamed(AppConstants.routeHome);
      } else {
        Navigator.of(context).pushReplacementNamed(AppConstants.routeLogin);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
