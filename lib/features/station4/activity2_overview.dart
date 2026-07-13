import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/text_format.dart';
import '../../core/widgets/game_image.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station4_data.dart';
import 'interpret_results_table.dart';

/// Scrollable Activity 2 briefing before the phytochemical screening task.
class Activity2Overview extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onContinue;

  const Activity2Overview({
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
          child: Scrollbar(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _overviewCard(),
                  const SizedBox(height: 10),
                  _goalsCard(),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: PrimaryButton(
            label: 'Begin Screening',
            icon: Icons.science,
            color: BioColors.forest,
            fontSize: 20,
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 14,
            ),
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
          colors: [
            BioColors.forest,
            BioColors.forest.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
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
          const SizedBox(height: 6),
          Text(
            kStation4Activity2Subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.92),
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: const [
              _MossChip(label: 'Genus Pyrrhobryum'),
              _MossChip(label: 'Genus Ectropothecium'),
            ],
          ),
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

  Widget _overviewCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BioColors.parchment.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BioColors.bark.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.menu_book, color: BioColors.forest, size: 26),
              SizedBox(width: 8),
              Text(
                'Activity Overview',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: BioColors.forest,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _bodyText(kStation4Activity2OverviewPart1),
          const SizedBox(height: 10),
          _bodyText(kStation4Activity2OverviewPart2),
          const SizedBox(height: 10),
          _bodyText(kStation4Activity2OverviewPart3),
          const SizedBox(height: 10),
          _bodyText(kStation4Activity2OverviewPart4),
          const SizedBox(height: 14),
          const InterpretResultsTable(fontSize: 15),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: SizedBox(
                  width: constraints.maxWidth,
                  child: GameImage(
                    asset: kStation4CommonPhytochemicalTestsAsset,
                    label: 'Common Phytochemical Tests',
                    fit: BoxFit.contain,
                    color: BioColors.moss,
                    icon: Icons.science,
                    cacheWidth: 1280,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _goalsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BioColors.forest.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.checklist, color: BioColors.forest, size: 26),
              SizedBox(width: 8),
              Text(
                'What You Will Do',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: BioColors.forest,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < kStation4Activity2Goals.length; i++) ...[
            if (i > 0) const SizedBox(height: 8),
            _goalRow(kStation4Activity2Goals[i]),
          ],
        ],
      ),
    );
  }

  Widget _bodyText(String text) {
    return Text.rich(
      readingTextSpan(text, fontSize: 17, color: BioColors.ink),
      style: const TextStyle(height: 1.45),
    );
  }

  Widget _goalRow(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 26,
          height: 26,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: BioColors.correct.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: BioColors.correct),
          ),
          child: const Icon(Icons.check, size: 16, color: BioColors.correct),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, height: 1.35),
          ),
        ),
      ],
    );
  }
}

class _MossChip extends StatelessWidget {
  final String label;

  const _MossChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.grass, color: BioColors.leaf.withValues(alpha: 0.95), size: 18),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
