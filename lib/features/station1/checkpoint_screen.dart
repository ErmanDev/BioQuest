import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/station1_data.dart';
import '../../data/stations.dart';
import '../../services/progress_service.dart';
import '../common/quiz_screen.dart';

class Station1CheckpointScreen extends StatelessWidget {
  const Station1CheckpointScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return QuizScreen(
      title: 'Trail Checkpoint: Station 1',
      questions: kStation1Checkpoint,
      continueLabel: 'Claim My Badge',
      showAnswerFeedback: true,
      titleFontSize: 28,
      promptFontSize: 28,
      optionFontSize: 26,
      nextFontSize: 26,
      showNextIcon: false,
      backButtonSize: 72,
      onBack: () => context.go(stationHubRoute('station1')),
      onComplete: (score, total) async {
        final progress = context.read<ProgressService>();
        await progress.recordAssessment('station1_checkpoint', score, total);
        await progress.completeStation('station1', score);
        if (context.mounted) context.go('/station1/badge');
      },
    );
  }
}
