import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/theme.dart';
import '../../../services/narration_helper.dart';
import '../../../services/progress_service.dart';

/// The three station subparts on splash / intro hubs, with sequential unlock.
class StationHubButtons extends StatelessWidget {
  const StationHubButtons({
    super.key,
    required this.stationKey,
    this.elevated = false,
    this.stopNarrationOnTap = false,
  });

  final String stationKey;
  final bool elevated;
  final bool stopNarrationOnTap;

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressService>();
    final missionUnlocked = progress.isMissionUnlocked(stationKey);
    final checkpointUnlocked = progress.isCheckpointUnlocked(stationKey);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _SubpartButton(
          label: 'Discovery Stop',
          icon: Icons.menu_book,
          color: BioColors.sky,
          route: '/station/$stationKey/discovery',
          enabled: true,
          elevated: elevated,
          stopNarrationOnTap: stopNarrationOnTap,
        ),
        _SubpartButton(
          label: 'Research Mission',
          icon: Icons.science,
          color: BioColors.sun,
          route: '/$stationKey/mission',
          enabled: missionUnlocked,
          lockedHint: 'Complete Discovery Stop first',
          elevated: elevated,
          stopNarrationOnTap: stopNarrationOnTap,
        ),
        _SubpartButton(
          label: 'Trail Checkpoint',
          icon: Icons.assignment_turned_in,
          color: BioColors.moss,
          route: '/$stationKey/checkpoint',
          enabled: checkpointUnlocked,
          lockedHint: 'Complete Takeaway Questions first',
          elevated: elevated,
          stopNarrationOnTap: stopNarrationOnTap,
        ),
      ],
    );
  }
}

class _SubpartButton extends StatelessWidget {
  const _SubpartButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.route,
    required this.enabled,
    required this.elevated,
    required this.stopNarrationOnTap,
    this.lockedHint,
  });

  final String label;
  final IconData icon;
  final Color color;
  final String route;
  final bool enabled;
  final String? lockedHint;
  final bool elevated;
  final bool stopNarrationOnTap;

  void _onTap(BuildContext context) {
    if (!enabled) return;
    void navigate() {
      if (context.mounted) context.push(route);
    }

    if (stopNarrationOnTap) {
      stopNarration(context).then((_) => navigate());
    } else {
      navigate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = enabled ? color : Colors.grey.shade400;
    final iconColor = enabled ? color : Colors.grey.shade500;

    return GestureDetector(
      onTap: enabled ? () => _onTap(context) : null,
      child: Opacity(
        opacity: enabled ? 1 : 0.55,
        child: Container(
          width: 220,
          padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor, width: 4),
            boxShadow: elevated
                ? const [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(icon, size: 60, color: iconColor),
                  if (!enabled)
                    Positioned(
                      right: -6,
                      bottom: -2,
                      child: Icon(
                        Icons.lock,
                        size: 22,
                        color: Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: enabled ? BioColors.ink : Colors.grey.shade600,
                ),
              ),
              if (!enabled && lockedHint != null) ...[
                const SizedBox(height: 6),
                Text(
                  lockedHint!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.25,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
