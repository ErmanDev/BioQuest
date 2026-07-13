import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/station_content.dart';
import '../../data/stations.dart';
import '../../services/progress_service.dart';
import '../common/quiz_screen.dart';

/// Generic Trail Checkpoint: 10 MC, auto-scored. Completing it marks the
/// station done (awards the badge + unlocks the next stop).
class StationCheckpointScreen extends StatelessWidget {
  final String stationKey;
  const StationCheckpointScreen({super.key, required this.stationKey});

  @override
  Widget build(BuildContext context) {
    final content = contentOf(stationKey);
    final info = stationByKey(stationKey);
    return QuizScreen(
      title: 'Trail Checkpoint: Station ${info.order}',
      questions: content.checkpoint,
      continueLabel: 'Claim My Badge',
      gradient: [info.color, info.color],
      onBack: () => context.go(stationHubRoute(stationKey)),
      onComplete: (score, total) async {
        final progress = context.read<ProgressService>();
        await progress.recordAssessment('${stationKey}_checkpoint', score, total);
        await progress.completeStation(stationKey, score);
        if (context.mounted) context.go('/$stationKey/badge');
      },
    );
  }
}
