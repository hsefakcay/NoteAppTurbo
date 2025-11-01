import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';

import '../../product/constants/app_constants.dart';
import '../../product/widgets/gradient_button.dart';
import '../auth/bloc/auth_cubit.dart';
import 'bloc/settings_cubit.dart';
import 'dialogs/coming_soon_dialog.dart';
import 'dialogs/language_dialog.dart';
import 'dialogs/sign_out_dialog.dart';
import 'dialogs/theme_dialog.dart';
import 'widgets/index.dart';

/// Ayarlar ekranı
class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const SettingsHeader(),
            Expanded(
              child: ListView(
                padding: context.padding.horizontalNormal,
                children: [
                  _buildProfileCard(user),
                  context.sized.emptySizedHeightBoxLow3x,
                  _buildPremiumButton(),
                  context.sized.emptySizedHeightBoxLow,
                  _buildAccountSection(context),
                  context.sized.emptySizedHeightBoxLow,
                  _buildSubscriptionSection(),
                  context.sized.emptySizedHeightBoxLow,
                  _buildSupportSection(),
                  context.sized.emptySizedHeightBoxNormal,
                  _buildSignOutButton(),
                  context.sized.emptySizedHeightBoxLow,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Profil kartı
  Widget _buildProfileCard(User? user) {
    final displayName = user?.displayName ?? user?.email?.split('@').first ?? 'User';
    final email = user?.email ?? 'user@example.com';

    return SettingsProfileCard(
      displayName: displayName,
      email: email,
      onTap: () => ComingSoonDialog.show(context),
    );
  }

  /// Premium butonu
  Widget _buildPremiumButton() {
    return GradientButton(
      text: 'settings.upgradePremium'.tr(),
      onPressed: () => ComingSoonDialog.show(context),
      icon: const Icon(Icons.star, color: Colors.white, size: 22),
      height: 64,
    );
  }

  /// Hesap ayarları bölümü
  Widget _buildAccountSection(BuildContext context) {
    return SettingsAccountSection(
      onLanguageChange: () => LanguageDialog.show(context),
      onThemeChange: () => ThemeDialog.show(context),
      onFailedUploads: () => ComingSoonDialog.show(context),
    );
  }

  /// Abonelik bölümü
  Widget _buildSubscriptionSection() {
    return SettingsSubscriptionSection(
      onCurrentPlan: () => ComingSoonDialog.show(context),
      onRestorePurchases: () => ComingSoonDialog.show(context),
      onAccessCode: () => ComingSoonDialog.show(context),
    );
  }

  /// Destek bölümü
  Widget _buildSupportSection() {
    return SettingsSupportSection(
      onContactSupport: () => ComingSoonDialog.show(context),
      onGoToWebsite: () => ComingSoonDialog.show(context),
    );
  }

  /// Çıkış yap butonu
  Widget _buildSignOutButton() {
    return GradientButton(
      text: 'auth.signOut'.tr(),
      onPressed: _handleSignOut,
      icon: const Icon(Icons.logout, color: Colors.white, size: 22),
    );
  }

  /// Çıkış yapma işlemi
  Future<void> _handleSignOut() async {
    final confirm = await SignOutDialog.show(context);

    if (confirm && mounted) {
      await context.read<AuthCubit>().signOut();
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(AppConstants.routeLogin, (_) => false);
    }
  }
}
