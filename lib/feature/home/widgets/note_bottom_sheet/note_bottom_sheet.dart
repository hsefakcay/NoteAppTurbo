import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../../../../product/models/note.dart';
import 'models/note_form_result.dart';
import 'widgets/note_bottom_sheet_actions.dart';
import 'widgets/note_bottom_sheet_drag_handle.dart';
import 'widgets/note_bottom_sheet_header.dart';
import 'widgets/note_content_field.dart';
import 'widgets/note_pin_option.dart';
import 'widgets/note_title_field.dart';

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
                const NoteBottomSheetDragHandle(),
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
                            NoteBottomSheetHeader(isEditing: widget.initialNote != null),
                            context.sized.emptySizedHeightBoxLow3x,
                            NoteTitleField(controller: _titleCtrl),
                            context.sized.emptySizedHeightBoxLow,
                            NoteContentField(controller: _contentCtrl),
                            context.sized.emptySizedHeightBoxLow,
                            NotePinOption(
                              pinned: _pinned,
                              onChanged: (value) => setState(() => _pinned = value),
                            ),
                            context.sized.emptySizedHeightBoxLow,
                            NoteBottomSheetActions(
                              isEditing: widget.initialNote != null,
                              onCancel: _handleCancel,
                              onSave: _handleSave,
                            ),
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

