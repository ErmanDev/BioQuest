import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/theme.dart';
import '../../../core/text_format.dart';
import '../../../core/widgets/wooden_sign.dart';
import '../../../data/station_content.dart';
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _MissionTargetsButton(stationKey: stationKey, elevated: elevated),
        const SizedBox(height: 16),
        Row(
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
        ),
      ],
    );
  }
}

/// Button above the subpart row that opens the "Target Competency" overlay.
class _MissionTargetsButton extends StatelessWidget {
  const _MissionTargetsButton({
    required this.stationKey,
    required this.elevated,
  });

  final String stationKey;
  final bool elevated;

  void _showOverlay(BuildContext context) {
    final content = contentOf(stationKey);
    final competency = content.targetCompetency;
    final targets = content.missionTargets;
    showDialog<void>(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
            decoration: BoxDecoration(
              color: BioColors.parchment,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: BioColors.forest, width: 3),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 16,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.track_changes,
                      color: BioColors.forest,
                      size: 26,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'MISSION TARGETS',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: BioColors.forest,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Close',
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: BioColors.forest),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // The body scrolls so every objective stays readable when the
                // pop-up is taller than a short landscape phone screen.
                Flexible(
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(right: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (competency != null) ...[
                            const _TargetSectionLabel(
                              icon: Icons.gps_fixed,
                              text: 'TARGET COMPETENCY',
                            ),
                            const SizedBox(height: 6),
                            Text(
                              competency,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: BioColors.ink,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                          const _TargetSectionLabel(
                            icon: Icons.checklist_rtl,
                            text: 'TARGET OBJECTIVES',
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'By the end of this station, you should be able to:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: BioColors.ink,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 14),
                          for (final target in targets) ...[
                            _TargetItem(text: target),
                            const SizedBox(height: 10),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WoodenSignButton(
      badge: const SignBadge(size: 64, child: CompassFace()),
      title: 'MISSION TARGETS',
      titleSize: 25,
      onTap: () => _showOverlay(context),
    );
  }
}

class _TargetSectionLabel extends StatelessWidget {
  const _TargetSectionLabel({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 17, color: BioColors.moss),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: BioColors.moss,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}

class _TargetItem extends StatelessWidget {
  const _TargetItem({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 5),
          child: Icon(Icons.eco, size: 16, color: BioColors.moss),
        ),
        const SizedBox(width: 10),
        Expanded(
          // Objectives may mark words as **bold** / *italic*.
          child: Text.rich(
            readingTextSpan(
              text,
              fontSize: 15,
              height: 1.35,
              color: BioColors.ink,
            ),
          ),
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
      // Always navigate even if TTS stop hangs after hot reload.
      stopNarration(context).whenComplete(navigate);
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
          padding: EdgeInsets.symmetric(vertical: 26, horizontal: 8),
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
