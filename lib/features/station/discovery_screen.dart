import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../app/theme.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station_content.dart';
import '../../data/stations.dart';
import '../../services/progress_service.dart';
import '../common/reading_screen.dart';

/// Generic Discovery Stop: scrollable content + voiceover, with a footer
/// button that continues to the station's Research Mission.
class StationDiscoveryScreen extends StatelessWidget {
  final String stationKey;
  const StationDiscoveryScreen({super.key, required this.stationKey});

  @override
  Widget build(BuildContext context) {
    final content = contentOf(stationKey);
    final info = stationByKey(stationKey);
    return ReadingScreen(
      title: content.discoveryTitle,
      content: content.content,
      contentFontSize: 26,
      backgroundAsset: 'assets/images/stations/$stationKey.png',
      backgroundLabel: info.title,
      autoNarrate: true,
      footer: Align(
        alignment: Alignment.centerRight,
        child: PrimaryButton(
          label: 'Go to Research Mission',
          icon: Icons.science,
          color: BioColors.sun,
          fontSize: 24,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          onTap: () async {
            await context.read<ProgressService>().markDiscoveryComplete(stationKey);
            if (context.mounted) context.go('/$stationKey/mission');
          },
        ),
      ),
    );
  }
}
