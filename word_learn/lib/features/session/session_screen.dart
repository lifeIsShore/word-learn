import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../shared/models/flashcard_item.dart';
import '../../shared/state/session_provider.dart';
import '../../shared/state/session_state.dart';

/// WL-060, WL-070: Flashcard loop — front (word), tap to reveal back, then rate HARD/FAMILIAR/OK/EASY.
class SessionScreen extends ConsumerStatefulWidget {
  const SessionScreen({super.key});

  @override
  ConsumerState<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends ConsumerState<SessionScreen> {
  bool _revealed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final session = ref.read(sessionProvider);
    if (session.cards.isEmpty && !session.isComplete) {
      context.go(AppRoutes.home);
      return;
    }
    if (session.isComplete) {
      context.go(AppRoutes.sessionComplete);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final card = session.currentCard;

    if (session.isComplete) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go(AppRoutes.sessionComplete);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (card == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go(AppRoutes.home);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.paperWhite,
      appBar: AppBar(
        title: Text(
          'Card ${session.reviewedCount + 1} of ${session.totalCount}',
          style: AppTypography.labelLarge.copyWith(color: AppColors.darkGray),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _Flashcard(
                  card: card,
                  revealed: _revealed,
                  onTap: () => setState(() => _revealed = true),
                ),
              ),
              if (_revealed) ...[
                SizedBox(height: AppSpacing.lg),
                Text(
                  'How well did you know it?',
                  style: AppTypography.labelLarge.copyWith(color: AppColors.mediumGray),
                ),
                SizedBox(height: AppSpacing.sm),
                _DifficultyButtons(
                  onRating: (rating) {
                    ref.read(sessionProvider.notifier).submitRating(rating);
                    setState(() => _revealed = false);
                    final next = ref.read(sessionProvider);
                    if (next.isComplete && mounted) {
                      context.go(AppRoutes.sessionComplete);
                    }
                  },
                ),
              ] else
                Padding(
                  padding: EdgeInsets.only(top: AppSpacing.lg),
                  child: Text(
                    'Tap card to reveal',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.mediumGray),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Flashcard extends StatelessWidget {
  const _Flashcard({
    required this.card,
    required this.revealed,
    required this.onTap,
  });

  final FlashcardItem card;
  final bool revealed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: revealed ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: revealed ? AppColors.primaryTeal : AppColors.lightGray,
            width: revealed ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: revealed ? _BackContent(card: card) : _FrontContent(card: card),
      ),
    );
  }
}

class _FrontContent extends StatelessWidget {
  const _FrontContent({required this.card});

  final FlashcardItem card;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            card.word,
            style: AppTypography.displayMedium.copyWith(
              color: AppColors.darkGray,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _BackContent extends StatelessWidget {
  const _BackContent({required this.card});

  final FlashcardItem card;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            card.word,
            style: AppTypography.labelLarge.copyWith(color: AppColors.primaryTeal),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            card.meaning,
            style: AppTypography.displayMedium.copyWith(
              color: AppColors.darkGray,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            card.exampleSentence,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.darkGray,
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            card.exampleTranslation,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.mediumGray),
          ),
        ],
      ),
    );
  }
}

class _DifficultyButtons extends StatelessWidget {
  const _DifficultyButtons({required this.onRating});

  final void Function(DifficultyRating) onRating;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _DiffButton(
            label: 'HARD',
            onTap: () => onRating(DifficultyRating.hard),
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _DiffButton(
            label: 'FAMILIAR',
            onTap: () => onRating(DifficultyRating.familiar),
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _DiffButton(
            label: 'OK',
            onTap: () => onRating(DifficultyRating.ok),
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _DiffButton(
            label: 'EASY',
            onTap: () => onRating(DifficultyRating.easy),
          ),
        ),
      ],
    );
  }
}

class _DiffButton extends StatelessWidget {
  const _DiffButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onTap,
      style: FilledButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
        backgroundColor: AppColors.primaryTeal,
      ),
      child: Text(
        label,
        style: AppTypography.labelLarge.copyWith(
          color: Colors.white,
          fontSize: 10,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
