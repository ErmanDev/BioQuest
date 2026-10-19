import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../core/game_canvas.dart';
import '../../core/mixins/auto_narrate_on_enter.dart';
import '../../core/widgets/game_image.dart';
import '../../core/widgets/voiceover_toggle.dart';
import '../../data/station1_data.dart';
import '../../data/station2_data.dart';
import '../../data/station3_data.dart';
import '../../data/station5_data.dart';
import '../../data/station_content.dart';
import '../../data/stations.dart';
import '../../services/narration_helper.dart';
import 'widgets/station_hub_buttons.dart';

/// Full-screen station title card with optional intro voiceover and subparts.
class StationSplashScreen extends StatefulWidget {
  final String stationKey;
  const StationSplashScreen({super.key, required this.stationKey});

  @override
  State<StationSplashScreen> createState() => _StationSplashScreenState();
}

class _StationSplashScreenState extends State<StationSplashScreen>
    with RouteAware, AutoNarrateOnEnter {
  String get _intro => contentOf(widget.stationKey).intro;

  String get _narrationText {
    switch (widget.stationKey) {
      case 'station1':
        return kStation1IntroNarration;
      case 'station2':
        return kStation2IntroNarration;
      case 'station3':
        return kStation3IntroNarration;
      case 'station5':
        return kStation5IntroNarration;
      default:
        return _intro;
    }
  }

  @override
  String? get autoNarrateText =>
      _narrationText.trim().isEmpty ? null : _narrationText;

  @override
  Widget build(BuildContext context) {
    final info = stationByKey(widget.stationKey);
    final asset = info.splashAsset;
    if (asset == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go('/station/${widget.stationKey}/intro');
      });
      return const SizedBox.shrink();
    }

    final hasIntro = _narrationText.trim().isNotEmpty;

    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: BioColors.forest),
        Positioned.fill(
          child: GameImage(
            asset: asset,
            label: info.title,
            fit: BoxFit.contain,
            color: info.color,
            icon: Icons.landscape,
            cacheWidth: 1280,
          ),
        ),
        GameCanvas(
          letterboxColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Material(
                      color: Colors.white.withValues(alpha: 0.92),
                      shape: const CircleBorder(),
                      elevation: 3,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          stopNarration(context).then((_) {
                            if (context.mounted) context.go('/map');
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Icon(
                            Icons.arrow_back,
                            color: BioColors.forest,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (hasIntro) const VoiceoverToggle(),
                  ],
                ),
                const Spacer(),
                StationHubButtons(
                  stationKey: widget.stationKey,
                  elevated: true,
                  stopNarrationOnTap: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
