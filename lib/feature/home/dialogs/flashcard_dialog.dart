import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kartal/kartal.dart';

import '../../../product/models/flashcard.dart';

/// Flashcard gösterim ve etkileşim dialogu
class FlashcardDialog extends StatefulWidget {
  const FlashcardDialog({required this.flashcards, required this.noteTitle, super.key});

  final List<Flashcard> flashcards;
  final String noteTitle;

  @override
  State<FlashcardDialog> createState() => _FlashcardDialogState();
}

class _FlashcardDialogState extends State<FlashcardDialog> {
  int _currentIndex = 0;
  bool _isAnswerVisible = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentCard = widget.flashcards[_currentIndex];

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: 500,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(theme),
            Flexible(
              child: SingleChildScrollView(
                padding: context.padding.normal,
                child: _buildCardContent(theme, currentCard),
              ),
            ),
            _buildFooter(theme),
          ],
        ),
      ),
    );
  }

  /// Header - Başlık ve kapatma butonu
  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Flashcards',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.noteTitle,
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.9)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: Colors.white),
            tooltip: 'Kapat',
          ),
        ],
      ),
    );
  }

  /// Flashcard içeriği
  Widget _buildCardContent(ThemeData theme, Flashcard card) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: _isAnswerVisible ? _buildAnswer(theme, card) : _buildQuestion(theme, card),
    );
  }

  /// Soru görünümü
  Widget _buildQuestion(ThemeData theme, Flashcard card) {
    return Container(
      key: const ValueKey('question'),
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'SORU',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
          context.sized.emptySizedHeightBoxLow,
          Text(
            card.question,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextButton.icon(
            onPressed: () {
              HapticFeedback.mediumImpact();
              setState(() => _isAnswerVisible = true);
            },
            icon: Icon(Icons.visibility_outlined, size: 20),
            label: const Text('Cevabı Göster'),
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  /// Cevap görünümü
  Widget _buildAnswer(ThemeData theme, Flashcard card) {
    return Container(
      key: const ValueKey('answer'),
      width: double.infinity,
      padding: context.padding.normal,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(0.15),
            theme.colorScheme.primary.withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'CEVAP',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
          context.sized.emptySizedHeightBoxLow,
          Text(
            card.answer,
            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500, height: 1.6),
            textAlign: TextAlign.center,
          ),
          context.sized.emptySizedHeightBoxLow3x,
          TextButton.icon(
            onPressed: () {
              HapticFeedback.mediumImpact();
              setState(() => _isAnswerVisible = false);
            },
            icon: Icon(Icons.visibility_off_outlined, size: 20),
            label: const Text('Cevabı Gizle'),
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  /// Footer - Navigasyon ve bilgi
  Widget _buildFooter(ThemeData theme) {
    return Container(
      padding: context.padding.normal,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        border: Border(
          top: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.1), width: 1),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _currentIndex > 0
                ? () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _currentIndex--;
                      _isAnswerVisible = false;
                    });
                  }
                : null,
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            tooltip: 'Önceki',
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_currentIndex + 1} / ${widget.flashcards.length}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: _currentIndex < widget.flashcards.length - 1
                ? () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _currentIndex++;
                      _isAnswerVisible = false;
                    });
                  }
                : null,
            icon: const Icon(Icons.arrow_forward_ios, size: 20),
            tooltip: 'Sonraki',
          ),
        ],
      ),
    );
  }
}
