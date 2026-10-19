import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station4_data.dart';

/// Activity 2 screening instructions shown after the overview.
class Activity2Instructions extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onContinue;

  const Activity2Instructions({
    super.key,
    required this.onBack,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _titleBanner(),
        const SizedBox(height: 8),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final boxWidth = constraints.maxWidth > 1040
                  ? 1000.0
                  : constraints.maxWidth;

              return Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: boxWidth,
                  height: constraints.maxHeight,
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: BioColors.parchment.withValues(alpha: 0.96),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: BioColors.bark.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'INSTRUCTIONS:',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: BioColors.ink,
                              ),
                            ),
                            const SizedBox(height: 14),
                            _numberedStep(
                              1,
                              kStation4Activity2InstructionsStep1,
                            ),
                            const SizedBox(height: 16),
                            const Divider(color: BioColors.ink, thickness: 3),
                            const SizedBox(height: 16),
                            _numberedStep(
                              2,
                              kStation4Activity2InstructionsSteps[0],
                            ),
                            const SizedBox(height: 12),
                            _numberedStep(
                              3,
                              kStation4Activity2InstructionsSteps[1],
                            ),
                            const SizedBox(height: 8),
                            for (final level
                                in kStation4Activity2PhytochemicalLevels)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Text(
                                  '• $level',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    height: 1.4,
                                    color: BioColors.ink,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 6),
                            _numberedStep(
                              4,
                              kStation4Activity2InstructionsSteps[2],
                            ),
                            const SizedBox(height: 12),
                            _numberedStep(
                              5,
                              kStation4Activity2InstructionsSteps[3],
                            ),
                            const SizedBox(height: 12),
                            _numberedStep(
                              6,
                              kStation4Activity2InstructionsSteps[4],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: PrimaryButton(
            label: 'Start Activity',
            icon: Icons.science,
            color: BioColors.forest,
            fontSize: 20,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            onTap: onContinue,
          ),
        ),
      ],
    );
  }

  Widget _titleBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [BioColors.forest, BioColors.forest.withValues(alpha: 0.85)],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _backButton(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.eco,
                  color: BioColors.leaf.withValues(alpha: 0.9),
                  size: 22,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    kStation4Activity2Title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.25,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  Icons.eco,
                  color: BioColors.leaf.withValues(alpha: 0.9),
                  size: 22,
                ),
              ],
            ),
          ),
          const SizedBox(width: 46),
        ],
      ),
    );
  }

  Widget _backButton() {
    return Material(
      color: Colors.white.withValues(alpha: 0.95),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onBack,
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: Icon(Icons.arrow_back, color: BioColors.forest, size: 22),
        ),
      ),
    );
  }

  Widget _numberedStep(int number, String text) {
    return Text(
      '$number. $text',
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 22, height: 1.45, color: BioColors.ink),
    );
  }
}
