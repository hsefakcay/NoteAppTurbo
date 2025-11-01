import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Modern ve özelleştirilebilir TextField widget'ı
///
/// Özellikler:
/// - Tema uyumlu
/// - Validation desteği
/// - Password field desteği
/// - Prefix/Suffix icon desteği
/// - Özelleştirilebilir stil
class CustomTextField extends StatefulWidget {
  /// TextField için controller
  final TextEditingController? controller;

  /// Placeholder metni
  final String? hintText;

  /// Label metni
  final String? labelText;

  /// Prefix icon
  final IconData? prefixIcon;

  /// Suffix icon
  final IconData? suffixIcon;

  /// Suffix icon'a tıklandığında çağrılacak fonksiyon
  final VoidCallback? onSuffixIconTap;

  /// Password alanı mı?
  final bool isPassword;

  /// Keyboard tipi
  final TextInputType? keyboardType;

  /// Input formatters
  final List<TextInputFormatter>? inputFormatters;

  /// Validation fonksiyonu
  final String? Function(String?)? validator;

  /// onChanged callback
  final void Function(String)? onChanged;

  /// onSubmitted callback
  final void Function(String)? onFieldSubmitted;

  /// Maksimum satır sayısı
  final int? maxLines;

  /// Minimum satır sayısı
  final int? minLines;

  /// TextField aktif mi?
  final bool enabled;

  /// Read only mi?
  final bool readOnly;

  /// Text capitalization
  final TextCapitalization textCapitalization;

  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.isPassword = false,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.readOnly = false,
    this.textCapitalization = TextCapitalization.none,
  });

  /// Email input factory
  factory CustomTextField.email({
    TextEditingController? controller,
    String? hintText = 'Email adresiniz',
    String? labelText = 'Email',
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return CustomTextField(
      controller: controller,
      hintText: hintText,
      labelText: labelText,
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      validator: validator ?? _defaultEmailValidator,
      onChanged: onChanged,
    );
  }

  /// Password input factory
  factory CustomTextField.password({
    TextEditingController? controller,
    String? hintText = 'Şifreniz',
    String? labelText = 'Şifre',
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return CustomTextField(
      controller: controller,
      hintText: hintText,
      labelText: labelText,
      prefixIcon: Icons.lock_outline,
      isPassword: true,
      validator: validator ?? _defaultPasswordValidator,
      onChanged: onChanged,
    );
  }

  /// Search input factory
  factory CustomTextField.search({
    TextEditingController? controller,
    String? hintText = 'Ara...',
    void Function(String)? onChanged,
    VoidCallback? onSuffixIconTap,
  }) {
    return CustomTextField(
      controller: controller,
      hintText: hintText,
      prefixIcon: Icons.search,
      suffixIcon: Icons.clear,
      onSuffixIconTap: onSuffixIconTap,
      onChanged: onChanged,
    );
  }

  /// Multiline text field factory
  factory CustomTextField.multiline({
    TextEditingController? controller,
    String? hintText,
    String? labelText,
    int minLines = 3,
    int maxLines = 6,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return CustomTextField(
      controller: controller,
      hintText: hintText,
      labelText: labelText,
      minLines: minLines,
      maxLines: maxLines,
      validator: validator,
      onChanged: onChanged,
    );
  }

  static String? _defaultEmailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email gerekli';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Geçerli bir email giriniz';
    }
    return null;
  }

  static String? _defaultPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Şifre gerekli';
    }
    if (value.length < 6) {
      return 'Şifre en az 6 karakter olmalı';
    }
    return null;
  }

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword && _obscureText,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      minLines: widget.minLines,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      textCapitalization: widget.textCapitalization,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, color: theme.colorScheme.primary.withOpacity(0.7))
            : null,
        suffixIcon: _buildSuffixIcon(theme),
      ),
    );
  }

  Widget? _buildSuffixIcon(ThemeData theme) {
    if (widget.isPassword) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: theme.colorScheme.primary.withOpacity(0.7),
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }

    if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(widget.suffixIcon, color: theme.colorScheme.primary.withOpacity(0.7)),
        onPressed: widget.onSuffixIconTap,
      );
    }

    return null;
  }
}
