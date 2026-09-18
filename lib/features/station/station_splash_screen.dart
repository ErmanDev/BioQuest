import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../core/game_canvas.dart';
import '../../core/mixins/auto_narrate_on_enter.dart';
import '../../core/text_format.dart';
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
  bool _introDismissed = false;

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

  bool get _showIntroDialog =>
      widget.stationKey == 'station3' &&
      !_introDismissed &&
      _narrationText.trim().isNotEmpty;

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
                          child: Icon(Icons.arrow_back, color: BioColors.forest),
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (hasIntro) const VoiceoverToggle(),
                  ],
                ),
                if (_showIntroDialog) ...[
                  const SizedBox(height: 8),
                  Expanded(
                    child: _Station3IntroDialog(
                      text: kStation3Intro,
                      onDismiss: () {
                        stopNarration(context);
                        setState(() => _introDismissed = true);
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                ] else
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

class _Station3IntroDialog extends StatelessWidget {
  const _Station3IntroDialog({
    required this.text,
    required this.onDismiss,
  });

  final String text;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 720,
              maxHeight: constraints.maxHeight,
            ),
            child: Material(
              color: BioColors.parchment.withValues(alpha: 0.97),
              elevation: 8,
              shadowColor: Colors.black54,
              borderRadius: BorderRadius.circular(18),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: BioColors.forest, width: 2.5),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 12, 8, 0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: BioColors.forest,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Green Growth Lab',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            tooltip: 'Close',
                            onPressed: onDismiss,
                            icon: const Icon(
                              Icons.close,
                              color: BioColors.forest,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 6),
                      child: Text(
                        'Welcome, young researchers!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: BioColors.forest,
                        ),
                      ),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                        child: Text.rich(
                          readingTextSpan(
                            text.replaceFirst(
                              'Welcome, young researchers! ',
                              '',
                            ),
                            fontSize: 17,
                            color: BioColors.ink,
                            height: 1.45,
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
      },
    );
  }
}
