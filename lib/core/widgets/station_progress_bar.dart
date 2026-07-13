import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../data/stations.dart';
import '../../models/station_progress.dart';
import '../../services/progress_service.dart';

/// Horizontal progress chart of the 5 stations + summit flag.
class StationProgressBar extends StatelessWidget {
  final ProgressService progress;
  const StationProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (final s in kStations) ...[
          _dot(
            label: '${s.order}',
            status: progress.progressOf(s.key).status,
            color: s.color,
          ),
          if (s.order < kStations.length) _connector(),
        ],
        _connector(),
        _summitFlag(progress.isUnlocked('summit')),
      ],
    );
  }

  Widget _dot({
    required String label,
    required StationStatus status,
    required Color color,
  }) {
    final completed = status == StationStatus.completed;
    final unlocked = status != StationStatus.locked;
    return Container(
      width: 38,
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: completed ? color : (unlocked ? color.withValues(alpha: 0.4) : Colors.grey.shade400),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: completed
          ? const Icon(Icons.check, color: Colors.white, size: 20)
          : unlocked
              ? Text(label,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))
              : const Icon(Icons.lock, color: Colors.white, size: 16),
    );
  }

  Widget _connector() => Container(
        width: 22,
        height: 4,
        color: BioColors.bark.withValues(alpha: 0.5),
      );

  Widget _summitFlag(bool unlocked) => Icon(
        Icons.flag,
        color: unlocked ? BioColors.danger : Colors.grey,
        size: 30,
      );
}
