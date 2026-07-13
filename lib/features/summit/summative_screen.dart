import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../app/theme.dart';
import '../../data/summit_data.dart';
import '../../services/progress_service.dart';
import '../common/quiz_screen.dart';

class SummativeScreen extends StatelessWidget {
  const SummativeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return QuizScreen(
      title: 'Summative Test',
      questions: kSummative,
      continueLabel: 'View My Certificate',
      gradient: const [BioColors.deepSky, BioColors.leaf],
      onBack: () => context.go('/summit'),
      onComplete: (score, total) async {
        await context
            .read<ProgressService>()
            .recordAssessment('summative', score, total);
        if (context.mounted) context.go('/summit/certificate');
      },
    );
  }
}
