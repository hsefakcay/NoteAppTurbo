import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../../../product/models/note.dart';
import '../../../product/widgets/index.dart';

/// Not ekleme/düzenleme sonucu
class NoteFormResult {
  const NoteFormResult({required this.title, required this.content, required this.pinned});

  final String title;
  final String content;
  final bool pinned;
}

/// Modern bottom sheet ile not ekleme/düzenleme
class NoteBottomSheet extends StatefulWidget {
  const NoteBottomSheet({this.initialNote, super.key});

  final Note? initialNote;

  @override
  State<NoteBottomSheet> createState() => _NoteBottomSheetState();
}

class _NoteBottomSheetState extends State<NoteBottomSheet> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _contentCtrl;
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  bool _pinned = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.initialNote?.title ?? '');
    _contentCtrl = TextEditingController(text: widget.initialNote?.content ?? '');
    _pinned = widget.initialNote?.pinned ?? false;

    // Animasyon kontrolcüsü
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeOut);
    _animationController.forward();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AnimatedPadding(
        padding: EdgeInsets.only(bottom: keyboardHeight),
        duration: const Duration(milliseconds: 100),
        child: Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDragHandle(theme),
                Flexible(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SingleChildScrollView(
                      padding: context.padding.normal,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(theme),
                            context.sized.emptySizedHeightBoxLow3x,
                            _buildTitleField(theme),
                            context.sized.emptySizedHeightBoxLow,
                            _buildContentField(theme),
                            context.sized.emptySizedHeightBoxLow3x,
                            _buildPinOption(theme),
                            context.sized.emptySizedHeightBoxLow3x,
                            _buildActionButtons(),
                            context.sized.emptySizedHeightBoxLow,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Üst çubuk (drag handle)
  Widget _buildDragHandle(ThemeData theme) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: theme.colorScheme.outline.withOpacity(0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  /// Başlık ve ikon
  Widget _buildHeader(ThemeData theme) {
    final isEditing = widget.initialNote != null;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.colorScheme.primary, theme.colorScheme.primary.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            isEditing ? Icons.edit_note_rounded : Icons.note_add_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? 'Notu Düzenle' : 'Yeni Not Oluştur',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                isEditing ? 'Notunuzu güncelleyin' : 'Fikirlerinizi kaydedin',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Başlık alanı
  Widget _buildTitleField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Başlık',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: _titleCtrl,
          hintText: 'Not başlığını girin',
          prefixIcon: Icons.title_rounded,
          validator: (v) => (v == null || v.isEmpty) ? 'Başlık zorunludur' : null,
        ),
      ],
    );
  }

  /// İçerik alanı
  Widget _buildContentField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'İçerik',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        context.sized.emptySizedHeightBoxLow,
        CustomTextField.multiline(
          controller: _contentCtrl,
          hintText: 'Notunuzu buraya yazın...',
          minLines: 8,
          maxLines: 10,
          validator: (v) => (v == null || v.isEmpty) ? 'İçerik zorunludur' : null,
        ),
      ],
    );
  }

  /// Pin seçeneği
  Widget _buildPinOption(ThemeData theme) {
    return InkWell(
      onTap: () => setState(() => _pinned = !_pinned),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _pinned ? theme.colorScheme.primary.withOpacity(0.08) : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _pinned
                    ? theme.colorScheme.primary.withOpacity(0.15)
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _pinned ? Icons.push_pin : Icons.push_pin_outlined,
                color: _pinned
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.6),
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Üste Sabitle',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: _pinned ? theme.colorScheme.primary : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Sabitlenmiş notlar listenin en üstünde görünür',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            AnimatedRotation(
              turns: _pinned ? 0.125 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                _pinned ? Icons.check_circle : Icons.circle_outlined,
                color: _pinned
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.3),
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Aksiyon butonları
  Widget _buildActionButtons() {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _handleCancel,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.3), width: 1.5),
              foregroundColor: theme.colorScheme.onSurface,
            ),
            child: Text(
              'İptal',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _handleSave,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: Text(
              widget.initialNote != null ? 'Güncelle' : 'Kaydet',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// İptal işlemi
  Future<void> _handleCancel() async {
    // Klavyeyi kapat
    FocusScope.of(context).unfocus();

    // Animasyon ile kapat
    await _animationController.reverse();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  /// Kaydetme işlemi
  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      // Klavyeyi kapat
      FocusScope.of(context).unfocus();

      // Sonucu döndür
      Navigator.of(context).pop(
        NoteFormResult(
          title: _titleCtrl.text.trim(),
          content: _contentCtrl.text.trim(),
          pinned: _pinned,
        ),
      );
    }
  }
}
