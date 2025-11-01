import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:note_app_turbo/product/widgets/gradient_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../core/di/service_locator.dart';
import '../../product/constants/app_constants.dart';
import '../../product/models/onboarding_page.dart';
import '../../product/service/onboarding_service.dart';

/// Onboarding ekranı
final class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

final class _OnboardingViewState extends State<OnboardingView> {
  final _pageController = PageController();
  final _onboardingService = serviceLocator<OnboardingService>();

  int _currentPage = 0;

  // Onboarding sayfaları
  late final List<OnboardingPageModel> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const OnboardingPageModel(
        icon: Icons.notes_rounded,
        titleKey: 'onboarding.welcome.title',
        descriptionKey: 'onboarding.welcome.description',
        color: Colors.blue,
      ),
      const OnboardingPageModel(
        icon: Icons.auto_awesome,
        titleKey: 'onboarding.aiFlashcard.title',
        descriptionKey: 'onboarding.aiFlashcard.description',
        badgeKey: 'onboarding.aiFlashcard.badge',
        color: Colors.purple,
      ),
      const OnboardingPageModel(
        icon: Icons.cloud_sync_rounded,
        titleKey: 'onboarding.sync.title',
        descriptionKey: 'onboarding.sync.description',
        color: Colors.green,
      ),
      const OnboardingPageModel(
        icon: Icons.rocket_launch_rounded,
        titleKey: 'onboarding.ready.title',
        descriptionKey: 'onboarding.ready.description',
        color: Colors.orange,
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    await _onboardingService.completeOnboarding();
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(AppConstants.routeLogin);
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Skip butonu
            _buildSkipButton(theme),

            // Sayfa içeriği
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index], theme);
                },
              ),
            ),

            // Page indicator
            _buildPageIndicator(theme),

            SizedBox(height: context.sized.dynamicHeight(0.03)),

            // Action butonları
            _buildActionButtons(theme),

            SizedBox(height: context.sized.dynamicHeight(0.02)),
          ],
        ),
      ),
    );
  }

  Widget _buildSkipButton(ThemeData theme) {
    final skipButtonHeight = context.sized.dynamicHeight(0.065).clamp(50.0, 56.0);

    if (_currentPage == _pages.length - 1) {
      return SizedBox(height: skipButtonHeight);
    }

    return Padding(
      padding: context.padding.horizontalLow,
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: _skipOnboarding,
          child: Text(
            'onboarding.skip'.tr(),
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: context.sized.dynamicHeight(0.02).clamp(14.0, 16.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPageModel page, ThemeData theme) {
    final iconSize = context.sized.dynamicHeight(0.15).clamp(80.0, 120.0);

    return SingleChildScrollView(
      padding: context.padding.normal,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Top spacing
          SizedBox(height: context.sized.dynamicHeight(0.08)),

          // Icon container
          Container(
            padding: EdgeInsets.all(context.sized.dynamicHeight(0.05).clamp(30.0, 50.0)),
            decoration: BoxDecoration(
              color: (page.color ?? theme.colorScheme.primary).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(page.icon, size: iconSize, color: page.color ?? theme.colorScheme.primary),
          ),

          SizedBox(height: context.sized.dynamicHeight(0.04)),

          // Badge (sadece AI sayfasında)
          if (page.badgeKey != null) ...[
            Container(
              padding: context.padding.low,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.purple.shade400, Colors.blue.shade400]),
                borderRadius: context.border.normalBorderRadius,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.stars, color: Colors.white, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    page.badgeKey!.tr(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.sized.dynamicHeight(0.02)),
          ],

          // Title
          Padding(
            padding: context.padding.horizontalNormal,
            child: Text(
              page.titleKey.tr(),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
                fontSize: context.sized.dynamicHeight(0.032).clamp(20.0, 28.0),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          SizedBox(height: context.sized.dynamicHeight(0.025)),

          // Description
          Padding(
            padding: context.padding.horizontalNormal,
            child: Text(
              page.descriptionKey.tr(),
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                height: 1.5,
                fontSize: context.sized.dynamicHeight(0.019).clamp(14.0, 16.0),
              ),
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Bottom spacing
          SizedBox(height: context.sized.dynamicHeight(0.08)),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(ThemeData theme) {
    return SmoothPageIndicator(
      controller: _pageController,
      count: _pages.length,
      effect: ExpandingDotsEffect(
        activeDotColor: theme.colorScheme.primary,
        dotColor: theme.colorScheme.surfaceContainerHighest,
        dotHeight: 8,
        dotWidth: 8,
        expansionFactor: 4,
        spacing: 8,
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    final isLastPage = _currentPage == _pages.length - 1;
    final buttonHeight = context.sized.dynamicHeight(0.065).clamp(50.0, 56.0);

    if (isLastPage) {
      return Padding(
        padding: context.padding.normal,
        child: Column(
          children: [
            // Giriş Yap butonu
            SizedBox(
              width: double.infinity,
              height: buttonHeight,
              child: GradientButton(
                onPressed: _completeOnboarding,
                text: 'onboarding.ready.login'.tr(),
              ),
            ),

            SizedBox(height: context.sized.dynamicHeight(0.015)),
          ],
        ),
      );
    }

    // Next butonu (diğer sayfalarda)
    return Padding(
      padding: context.padding.normal,
      child: SizedBox(
        width: double.infinity,
        height: buttonHeight,
        child: GradientButton(onPressed: _nextPage, text: 'onboarding.next'.tr()),
      ),
    );
  }
}
