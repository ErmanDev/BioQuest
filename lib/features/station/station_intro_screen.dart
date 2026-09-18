import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../core/mixins/auto_narrate_on_enter.dart';
import '../../core/widgets/bio_scaffold.dart';
import '../../core/widgets/voiceover_toggle.dart';
import '../../data/station1_data.dart';
import '../../data/station2_data.dart';
import '../../data/station3_data.dart';
import '../../data/station5_data.dart';
import '../../data/station_content.dart';
import '../../data/stations.dart';
import 'widgets/station_hub_buttons.dart';

/// Per-station welcome with intro text and the three clickable subparts.
class StationIntroScreen extends StatefulWidget {
  final String stationKey;
  const StationIntroScreen({super.key, required this.stationKey});

  @override
  State<StationIntroScreen> createState() => _StationIntroScreenState();
}

class _StationIntroScreenState extends State<StationIntroScreen>
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
    return BioScaffold(
      title: info.title,
      backgroundAsset: 'assets/images/stations/${widget.stationKey}.png',
      backgroundLabel: info.title,
      gradient: [info.color, BioColors.leaf],
      onBack: () => context.go('/map'),
      actions: const [VoiceoverToggle()],
      body: Column(
        children: [
          const Spacer(),
          Expanded(
            flex: 3,
            child: StationHubButtons(stationKey: widget.stationKey),
          ),
        ],
      ),
    );
  }
}
