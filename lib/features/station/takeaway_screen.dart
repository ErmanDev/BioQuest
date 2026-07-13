import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../app/theme.dart';
import '../../core/widgets/bio_scaffold.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station_content.dart';
import '../../data/stations.dart';
import '../../services/progress_service.dart';

/// Generic takeaway: a free-text question scored 1-5 with a keyword/length
/// heuristic rubric, then continues to the station's Trail Checkpoint.
class StationTakeawayScreen extends StatefulWidget {
  final String stationKey;
  const StationTakeawayScreen({super.key, required this.stationKey});

  @override
  State<StationTakeawayScreen> createState() => _StationTakeawayScreenState();
}

class _StationTakeawayScreenState extends State<StationTakeawayScreen> {
  final _controller = TextEditingController();
  int? _score;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _scoreAnswer(String text, List<String> keywords) {
    final lower = text.toLowerCase();
    final words = lower.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
    final matched = keywords.where((k) => lower.contains(k.toLowerCase())).length;
    int s;
    if (matched >= 4) {
      s = 5;
    } else if (matched == 3) {
      s = 4;
    } else if (matched == 2) {
      s = 3;
    } else if (matched == 1) {
      s = 2;
    } else {
      s = 1;
    }
    if (words < 4 && s > 2) s = 2;
    return s;
  }

  Future<void> _submit() async {
    final content = contentOf(widget.stationKey);
    final s = _scoreAnswer(_controller.text, content.takeawayKeywords);
    setState(() => _score = s);
    await context
        .read<ProgressService>()
        .recordAssessment('${widget.stationKey}_takeaway', s, 5);
  }

  @override
  Widget build(BuildContext context) {
    final content = contentOf(widget.stationKey);
    final info = stationByKey(widget.stationKey);
    return BioScaffold(
      title: 'Takeaway Question',
      backgroundAsset: 'assets/images/stations/${widget.stationKey}.png',
      backgroundLabel: info.title,
      gradient: [info.color, BioColors.leaf],
      onBack: () => context.go(stationHubRoute(widget.stationKey)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: BioColors.parchment.withValues(alpha: 0.97),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              content.takeawayPrompt,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _score == null ? _input() : _feedback(context, content),
          ),
        ],
      ),
    );
  }

  Widget _input() {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: BioColors.bark, width: 2),
            ),
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: const TextStyle(fontSize: 18, height: 1.4),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Type your answer here...',
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: PrimaryButton(
            label: 'Submit Answer',
            icon: Icons.send,
            color: BioColors.sun,
            onTap: _submit,
          ),
        ),
      ],
    );
  }

  Widget _feedback(BuildContext context, StationContent content) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: BioColors.parchment.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.star, color: BioColors.sun, size: 32),
              const SizedBox(width: 8),
              Text(
                'Your score: $_score / 5',
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: BioColors.forest),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Sample answer:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
          const SizedBox(height: 6),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                content.takeawayModel,
                style: const TextStyle(fontSize: 17, height: 1.4),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: PrimaryButton(
              label: 'Proceed Outside',
              icon: Icons.exit_to_app,
              onTap: () async {
                final progress = context.read<ProgressService>();
                final router = GoRouter.of(context);
                await progress.markTakeawayComplete(widget.stationKey);
                if (!context.mounted) return;
                router.go(stationHubRoute(widget.stationKey));
              },
            ),
          ),
        ],
      ),
    );
  }
}
