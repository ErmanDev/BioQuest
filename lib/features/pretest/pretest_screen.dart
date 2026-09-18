import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/pretest_data.dart';
import '../../services/progress_service.dart';
import '../common/quiz_screen.dart';

class PretestScreen extends StatelessWidget {
  const PretestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return QuizScreen(
      title: 'Pretest',
      questions: kPretest,
      backgroundAsset: 'assets/images/backgrounds/pretest.jpg',
      backgroundLabel: 'Pretest background',
      fullBleedBackground: true,
      scrimOpacity: 0.48,
      promptFontSize: 30,
      optionFontSize: 32,
      stimulusFontSize: 18,
      nextFontSize: 26,
      showNextIcon: false,
      titleFontSize: 28,
      onBack: () => context.go('/basecamp'),
      continueLabel: 'Go to Expedition Map',
      onComplete: (score, total) async {
        await context.read<ProgressService>().recordAssessment(
              'pretest',
              score,
              total,
            );
        if (context.mounted) context.go('/map');
      },
    );
  }
}
