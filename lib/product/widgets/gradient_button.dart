import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import '../constants/app_theme.dart';

/// Modern gradient buton widget'ı - Best Practice ile
///
/// Özellikler:
/// - Gradient arka plan desteği
/// - Loading state desteği
/// - Özelleştirilebilir padding, radius ve boyut
/// - Tema uyumlu
/// - Accessibility desteği
class GradientButton extends StatelessWidget {
  /// Buton metni
  final String text;

  /// Butona tıklandığında çağrılacak fonksiyon
  final VoidCallback? onPressed;

  /// Loading durumu - true ise CircularProgressIndicator gösterir
  final bool isLoading;

  /// Gradient renkler - null ise tema renklerini kullanır
  final Gradient? gradient;

  /// Buton genişliği - null ise parent'ın genişliğini alır
  final double? width;

  /// Buton yüksekliği
  final double height;

  /// İç padding
  final EdgeInsetsGeometry? padding;

  /// Köşe yuvarlaklığı
  final double borderRadius;

  /// Buton içindeki icon (opsiyonel)
  final Widget? icon;

  /// Text stili (opsiyonel) - null ise default stil kullanılır
  final TextStyle? textStyle;

  /// Outlined stil mi?
  final bool _isOutlined;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.gradient,
    this.width,
    this.height = 56,
    this.padding,
    this.borderRadius = 16,
    this.icon,
    this.textStyle,
  }) : _isOutlined = false;

  /// Küçük boyutlu buton factory
  factory GradientButton.small({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    Gradient? gradient,
    Widget? icon,
  }) {
    return GradientButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      gradient: gradient,
      icon: icon,
      height: 44,
      borderRadius: 10,
    );
  }

  /// Outline stili buton factory
  const GradientButton.outlined({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.width,
    this.height = 56,
    this.icon,
  }) : gradient = null,
       padding = null,
       borderRadius = 0,
       textStyle = null,
       _isOutlined = true;

  @override
  Widget build(BuildContext context) {
    if (_isOutlined) {
      return _buildOutlinedButton(context);
    }
    return _buildGradientButton(context);
  }

  Widget _buildGradientButton(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Loading durumunda butonu disable et
    final isEnabled = onPressed != null && !isLoading;

    // Gradient belirleme
    final buttonGradient = gradient ?? (isDark ? AppTheme.darkGradient : AppTheme.primaryGradient);

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: context.border.normalBorderRadius,
          child: Ink(
            decoration: BoxDecoration(
              gradient: isEnabled ? buttonGradient : null,
              color: isEnabled ? null : theme.colorScheme.surface.withOpacity(0.5),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Container(
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              alignment: Alignment.center,
              child: _buildContent(theme, isForOutlined: false),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOutlinedButton(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = onPressed != null && !isLoading;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isEnabled
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surface.withOpacity(0.5),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            alignment: Alignment.center,
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: _buildContent(theme, isForOutlined: true),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme, {required bool isForOutlined}) {
    if (isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            isForOutlined ? theme.colorScheme.primary : Colors.white,
          ),
        ),
      );
    }

    final textWidget = Text(
      text,
      style:
          textStyle ??
          TextStyle(
            color: isForOutlined ? theme.colorScheme.primary : Colors.white,
            fontSize: theme.textTheme.titleMedium?.fontSize,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
    );

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [icon!, const SizedBox(width: 8), textWidget],
      );
    }

    return textWidget;
  }
}
