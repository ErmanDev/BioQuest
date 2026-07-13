import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../data/stations.dart';
import '../../../services/progress_service.dart';

enum StationStep { mission, checkpoint }

/// Redirects to the station hub when a subpart is not yet unlocked.
class StationStepGate extends StatelessWidget {
  const StationStepGate({
    super.key,
    required this.stationKey,
    required this.step,
    required this.child,
  });

  final String stationKey;
  final StationStep step;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressService>();
    final unlocked = switch (step) {
      StationStep.mission => progress.isMissionUnlocked(stationKey),
      StationStep.checkpoint => progress.isCheckpointUnlocked(stationKey),
    };

    if (!unlocked) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go(stationHubRoute(stationKey));
      });
      return const SizedBox.shrink();
    }

    return child;
  }
}
