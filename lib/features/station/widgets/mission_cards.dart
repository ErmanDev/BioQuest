import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../../../core/widgets/primary_button.dart';

/// Intro card shown at the start of a Research Mission.
class MissionStoryCard extends StatelessWidget {
  final String title;
  final String story;
  final VoidCallback onStart;
  final String startLabel;

  const MissionStoryCard({
    super.key,
    required this.title,
    required this.story,
    required this.onStart,
    this.startLabel = 'Tap here to Start',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 760,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: BioColors.parchment.withValues(alpha: 0.97),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: BioColors.forest, width: 3),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: BioColors.forest),
            ),
            const SizedBox(height: 12),
            Text(story,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, height: 1.4)),
            const SizedBox(height: 20),
            PrimaryButton(
              label: startLabel,
              color: BioColors.forest,
              onTap: onStart,
            ),
          ],
        ),
      ),
    );
  }
}

/// Result card shown when a Research Mission is finished.
class MissionCompleteCard extends StatelessWidget {
  final int score;
  final int total;
  final String message;
  final VoidCallback onContinue;
  final String continueLabel;

  const MissionCompleteCard({
    super.key,
    required this.score,
    required this.total,
    required this.message,
    required this.onContinue,
    this.continueLabel = 'Continue to Takeaway',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 700,
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: BioColors.parchment,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: BioColors.forest, width: 4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.verified, color: BioColors.correct, size: 60),
            const SizedBox(height: 8),
            Text('Activity Score: $score / $total',
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: BioColors.forest)),
            const SizedBox(height: 10),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, height: 1.35)),
            const SizedBox(height: 20),
            PrimaryButton(
              label: continueLabel,
              icon: Icons.edit_note,
              color: BioColors.sun,
              onTap: onContinue,
            ),
          ],
        ),
      ),
    );
  }
}
