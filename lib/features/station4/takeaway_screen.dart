import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../app/theme.dart';
import '../../core/game_canvas.dart';
import '../../core/widgets/artwork_stage.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station4_data.dart';
import '../../data/stations.dart';
import '../../services/progress_service.dart';

class Station4TakeawayScreen extends StatefulWidget {
  const Station4TakeawayScreen({super.key});

  @override
  State<Station4TakeawayScreen> createState() => _Station4TakeawayScreenState();
}

class _Station4TakeawayScreenState extends State<Station4TakeawayScreen> {
  /// Background artwork aspect; panels are placed as fractions of the
  /// artwork so they stay on the drawn frame on any screen shape.
  static const double _artAspect = 3072 / 1376;

  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final score = scoreStation4TakeawayAnswer(text);

    final progress = context.read<ProgressService>();
    final router = GoRouter.of(context);
    await progress.recordAssessment('station4_takeaway', score, 5);
    await progress.markTakeawayComplete('station4');
    if (!mounted) return;
    router.go(stationHubRoute('station4'));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: BioColors.forest),
        Positioned.fill(
          child: ArtworkBackdrop(
            asset: kStation4TakeawayBackgroundAsset,
            aspect: _artAspect,
            label: 'Background',
          ),
        ),
        GameCanvas(
          letterboxColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
            child: Column(
              children: [
                _topBar(context),
                const SizedBox(height: 8),
                const Expanded(child: SizedBox.shrink()),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: ArtworkOverlay(
            aspect: _artAspect,
            slots: [
              ArtworkSlot(
                region: Rect.fromLTRB(0.315, 0.665, 0.75, 0.88),
                child: _answerField(),
              ),
              ArtworkSlot(
                region: Rect.fromLTRB(0.38, 0.885, 0.685, 0.97),
                child: _footer(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _topBar(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.white,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => context.go(stationHubRoute('station4')),
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.arrow_back, color: BioColors.forest, size: 26),
            ),
          ),
        ),
      ],
    );
  }

  Widget _answerField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 4),
      child: TextField(
        controller: _controller,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: const TextStyle(
          fontSize: 17,
          height: 1.45,
          color: BioColors.ink,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Write your answer here...',
          hintStyle: TextStyle(
            fontSize: 16,
            color: BioColors.ink.withValues(alpha: 0.45),
          ),
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Widget _footer() {
    return Center(
      child: PrimaryButton(
        label: 'Submit Answer',
        icon: Icons.send,
        color: BioColors.sun,
        fontSize: 15,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        onTap: _controller.text.trim().isNotEmpty ? _submit : null,
      ),
    );
  }
}
