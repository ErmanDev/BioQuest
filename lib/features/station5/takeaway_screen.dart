import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../app/theme.dart';
import '../../core/game_canvas.dart';
import '../../core/widgets/game_image.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station5_data.dart';
import '../../data/stations.dart';
import '../../services/progress_service.dart';

class Station5TakeawayScreen extends StatefulWidget {
  const Station5TakeawayScreen({super.key});

  @override
  State<Station5TakeawayScreen> createState() => _Station5TakeawayScreenState();
}

class _Station5TakeawayScreenState extends State<Station5TakeawayScreen> {
  static const _answerLeft = 0.22;
  static const _answerRight = 0.78;
  static const _answerTop = 0.52;
  static const _answerBottom = 0.86;

  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final score = scoreStation5TakeawayAnswer(text);

    final progress = context.read<ProgressService>();
    final router = GoRouter.of(context);
    await progress.recordAssessment('station5_takeaway', score, 5);
    await progress.markTakeawayComplete('station5');
    if (!mounted) return;
    router.go('/station5/checkpoint');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: BioColors.forest),
        Positioned.fill(
          child: GameImage(
            asset: kStation5TakeawayBackgroundAsset,
            label: 'Takeaway',
            fit: BoxFit.cover,
            color: BioColors.forest,
            icon: Icons.landscape,
            cacheWidth: 1280,
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
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final w = constraints.maxWidth;
                      final h = constraints.maxHeight;
                      final left = w * _answerLeft;
                      final width = w * (_answerRight - _answerLeft);
                      final top = h * _answerTop;
                      final height = h * _answerBottom - top;

                      return Stack(
                        clipBehavior: Clip.hardEdge,
                        children: [
                          Positioned(
                            left: left,
                            top: top,
                            width: width,
                            height: height,
                            child: _answerField(),
                          ),
                          Positioned(
                            left: w * 0.22,
                            right: w * 0.22,
                            bottom: 0,
                            child: _footer(),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
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
            onTap: () => context.go(stationHubRoute('station5')),
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
      padding: const EdgeInsets.fromLTRB(16, 36, 16, 48),
      child: TextField(
        controller: _controller,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: const TextStyle(fontSize: 17, height: 1.45, color: BioColors.ink),
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
