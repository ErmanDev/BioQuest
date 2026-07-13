import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../core/text_format.dart';
import '../../core/widgets/game_image.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station2_data.dart';

/// Activity 2 — Stratified Sampling Investigation (scrollable, readable).
class StratifiedSamplingActivity extends StatefulWidget {
  final void Function(int score) onComplete;

  const StratifiedSamplingActivity({super.key, required this.onComplete});

  @override
  State<StratifiedSamplingActivity> createState() =>
      _StratifiedSamplingActivityState();
}

class _StratifiedSamplingActivityState extends State<StratifiedSamplingActivity> {
  static const _markerSize = 44.0;

  static const _lineColors = {
    200: Color(0xFF1565C0),
    400: Color(0xFF2E7D32),
    600: Color(0xFF6A1B9A),
  };

  final Set<int> _placedLines = {};
  final _zoneControllers = {
    for (final z in kStation2StratifiedZones) z.zone: TextEditingController(),
  };
  final _totalCtrl = TextEditingController();
  String? _feedback;
  bool _submitted = false;
  int _activityScore = 0;

  bool get _allLinesPlaced =>
      kStation2StratifiedElevationLines.every(_placedLines.contains);

  @override
  void dispose() {
    for (final c in _zoneControllers.values) {
      c.dispose();
    }
    _totalCtrl.dispose();
    super.dispose();
  }

  Station2PlantSpecies? _species(String id) {
    for (final s in kStation2PlantSpecies) {
      if (s.id == id) return s;
    }
    return null;
  }

  void _placeLine(int meters) {
    setState(() {
      _placedLines.add(meters);
      _feedback = null;
      _submitted = false;
      _activityScore = 0;
    });
  }

  void _submit() {
    if (!_allLinesPlaced) {
      setState(() => _feedback = 'Place all three elevation lines first.');
      return;
    }

    final expected = station2ExpectedMossPerZone();
    var score = 0;
    for (final info in kStation2StratifiedZones) {
      final entered =
          int.tryParse(_zoneControllers[info.zone]!.text.trim());
      if (entered == expected[info.zone]) score++;
    }
    final totalEntered = int.tryParse(_totalCtrl.text.trim());
    if (totalEntered == kStation2ExpectedMossTotal) score++;

    final maxScore = kStation2StratifiedZones.length + 1;
    setState(() {
      _submitted = true;
      _activityScore = score;
      _feedback = score == maxScore
          ? 'Excellent! Your moss counts match every elevation zone.'
          : 'You scored $score out of $maxScore. Tap Next Activity to continue.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _instructions(),
            const SizedBox(height: 14),
            _speciesGuide(),
            const SizedBox(height: 14),
            _mountainSection(),
            const SizedBox(height: 14),
            _lineButtons(),
            const SizedBox(height: 14),
            _dataTable(),
            if (_feedback != null) ...[
              const SizedBox(height: 12),
              _feedbackBanner(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _instructions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BioColors.parchment.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BioColors.bark.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'ACTIVITY 2: STRATIFIED SAMPLING INVESTIGATION',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: BioColors.forest,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 10),
          Text.rich(
            readingTextSpan(
              kStation2StratifiedIntro,
              fontSize: 16,
              color: BioColors.ink,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < kStation2StratifiedSteps.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text.rich(
                readingTextSpan(
                  '${i + 1}. ${kStation2StratifiedSteps[i]}',
                  fontSize: 16,
                  color: BioColors.ink,
                ),
              ),
            ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: BioColors.paleLeaf.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: BioColors.forest.withValues(alpha: 0.35)),
            ),
            child: Text.rich(
              readingTextSpan(
                kStation2StratifiedReminder,
                fontSize: 15,
                color: BioColors.forest,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _speciesGuide() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: BioColors.parchment.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BioColors.bark.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'SAMPLE SPECIES GUIDE',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: BioColors.forest,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Count only MOSS. Other plants help you practice identifying '
            'what to ignore.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, height: 1.35),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < kStation2PlantSpecies.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            _speciesRow(kStation2PlantSpecies[i]),
          ],
        ],
      ),
    );
  }

  Widget _speciesRow(Station2PlantSpecies species) {
    final countMoss = species.id == 'moss';
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: countMoss
            ? BioColors.paleLeaf.withValues(alpha: 0.7)
            : Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: countMoss ? BioColors.forest : BioColors.leaf.withValues(alpha: 0.5),
          width: countMoss ? 2.5 : 1,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 64,
              height: 64,
              child: GameImage(
                asset: species.imageAsset,
                label: species.name,
                fit: BoxFit.cover,
                color: BioColors.moss,
                icon: Icons.eco,
                cacheWidth: 140,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  countMoss ? '${species.name.toUpperCase()} (COUNT THIS)' : species.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: countMoss ? BioColors.forest : BioColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  species.description,
                  style: const TextStyle(fontSize: 15, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mountainSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'MOUNTAIN STUDY AREA',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: BioColors.forest,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _allLinesPlaced
              ? 'Count the moss icons in each zone between the lines.'
              : 'Place the three elevation lines below to divide the mountain.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        AspectRatio(
          aspectRatio: 16 / 10,
          child: _mountainView(),
        ),
      ],
    );
  }

  Widget _mountainView() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BioColors.moss, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const GameImage(
              asset: kStation2MountainDiversityBg,
              label: 'Mountain',
              fit: BoxFit.cover,
              color: BioColors.forest,
              icon: Icons.terrain,
              cacheWidth: 1200,
            ),
            _elevationAxis(),
            if (_allLinesPlaced) ..._zoneTintOverlays(),
            for (final m in _placedLines) _elevationLine(m),
            ..._plantMarkers(),
          ],
        ),
      ),
    );
  }

  Widget _elevationAxis() {
    const labels = [600, 400, 200, 0];
    return Positioned(
      left: 4,
      top: 8,
      bottom: 8,
      width: 52,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.82),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            const Text(
              'm',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (final m in labels)
                    Text(
                      '$m',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: BioColors.forest,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _zoneTintOverlays() {
    final bands = <(double top, double bottom, Color color)>[
      (0, station2ElevationLineY(600), BioColors.sky.withValues(alpha: 0.12)),
      (
        station2ElevationLineY(600),
        station2ElevationLineY(400),
        BioColors.moss.withValues(alpha: 0.10),
      ),
      (
        station2ElevationLineY(400),
        station2ElevationLineY(200),
        BioColors.sun.withValues(alpha: 0.08),
      ),
      (station2ElevationLineY(200), 1, BioColors.bark.withValues(alpha: 0.08)),
    ];

    return [
      for (final (top, bottom, color) in bands)
        Positioned(
          left: 56,
          right: 0,
          top: 0,
          bottom: 0,
          child: Align(
            alignment: Alignment(0, (top + bottom) - 1),
            child: FractionallySizedBox(
              widthFactor: 1,
              heightFactor: (bottom - top).clamp(0.01, 1.0),
              child: ColoredBox(color: color),
            ),
          ),
        ),
    ];
  }

  Widget _elevationLine(int meters) {
    final color = _lineColors[meters] ?? BioColors.forest;
    return Positioned(
      left: 56,
      right: 8,
      top: 0,
      bottom: 0,
      child: Align(
        alignment: Alignment(0, station2ElevationLineY(meters) * 2 - 1),
        child: Container(
          height: 4,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.5),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _plantMarkers() {
    return [
      for (final marker in kStation2StratifiedMarkers)
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: Align(
            alignment: Alignment(
              marker.x * 2 - 1,
              marker.y * 2 - 1,
            ),
            child: _markerWidget(marker),
          ),
        ),
    ];
  }

  Widget _markerWidget(({String speciesId, double x, double y}) marker) {
    final species = _species(marker.speciesId);
    if (species == null) return const SizedBox.shrink();

    final isMoss = marker.speciesId == 'moss';
    if (isMoss && !_allLinesPlaced) return const SizedBox.shrink();

    return Opacity(
      opacity: isMoss ? 1 : 0.4,
      child: Container(
        width: _markerSize,
        height: _markerSize,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isMoss ? BioColors.forest : Colors.white,
            width: isMoss ? 2.5 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: GameImage(
            asset: species.imageAsset,
            label: species.name,
            fit: BoxFit.cover,
            color: BioColors.moss,
            icon: Icons.eco,
            cacheWidth: 120,
          ),
        ),
      ),
    );
  }

  Widget _lineButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'PLACE ELEVATION LINES',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: BioColors.forest,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Tap each button to place a horizontal line on the mountain.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15),
        ),
        const SizedBox(height: 10),
        for (final meters in kStation2StratifiedElevationLines) ...[
          _lineButton(meters),
          const SizedBox(height: 8),
        ],
      ],
    );
  }

  Widget _lineButton(int meters) {
    final placed = _placedLines.contains(meters);
    final color = _lineColors[meters] ?? BioColors.forest;
    return Material(
      color: placed ? color.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.95),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: placed ? null : () => _placeLine(meters),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color, width: placed ? 2.5 : 2),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  placed
                      ? '$meters m line placed'
                      : 'Place $meters m elevation line',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: placed ? color : BioColors.ink,
                  ),
                ),
              ),
              if (placed)
                Icon(Icons.check_circle, color: color, size: 26),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dataTable() {
    final canSubmit = _allLinesPlaced && !_submitted;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: BioColors.parchment.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BioColors.bark.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'DATA TABLE',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: BioColors.forest,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Number of moss plants in each elevation zone.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, height: 1.35),
          ),
          const SizedBox(height: 14),
          for (final info in kStation2StratifiedZones) ...[
            _zoneRow(info),
            const SizedBox(height: 10),
          ],
          _totalRow(),
          const SizedBox(height: 14),
          PrimaryButton(
            label: _submitted ? 'Next Activity' : 'Submit Answers',
            icon: _submitted ? Icons.arrow_forward : Icons.fact_check,
            color: BioColors.moss,
            fontSize: 18,
            expand: true,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            onTap: _submitted
                ? () => widget.onComplete(_activityScore)
                : (canSubmit ? _submit : null),
          ),
        ],
      ),
    );
  }

  Widget _zoneRow(Station2StratifiedZoneInfo info) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BioColors.leaf.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info.label,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: BioColors.forest,
                  ),
                ),
                Text(
                  info.elevationRange,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 88,
            child: TextField(
              controller: _zoneControllers[info.zone],
              enabled: _allLinesPlaced && !_submitted,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: _allLinesPlaced
                    ? Colors.white
                    : BioColors.paleLeaf.withValues(alpha: 0.4),
                hintText: '0',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: BioColors.forest, width: 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalRow() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: BioColors.paleLeaf.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BioColors.forest, width: 2),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'TOTAL NUMBER OF MOSS PLANTS',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: BioColors.forest,
              ),
            ),
          ),
          SizedBox(
            width: 88,
            child: TextField(
              controller: _totalCtrl,
              enabled: _allLinesPlaced && !_submitted,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: _allLinesPlaced
                    ? Colors.white
                    : BioColors.paleLeaf.withValues(alpha: 0.4),
                hintText: '0',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: BioColors.forest, width: 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _feedbackBanner() {
    final maxScore = kStation2StratifiedZones.length + 1;
    final perfect = _activityScore == maxScore;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: (perfect ? BioColors.correct : BioColors.sun)
            .withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: perfect ? BioColors.correct : BioColors.sun,
          width: 2,
        ),
      ),
      child: Text(
        _feedback!,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          height: 1.4,
          color: perfect ? BioColors.correct : BioColors.bark,
        ),
      ),
    );
  }
}
