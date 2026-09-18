import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../core/text_format.dart';
import '../../core/widgets/game_image.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station2_data.dart';

/// Activity 1 — Mountain Plant Diversity Investigation (scrollable, readable).
class MountainDiversityActivity extends StatefulWidget {
  final void Function(int score) onComplete;

  const MountainDiversityActivity({super.key, required this.onComplete});

  @override
  State<MountainDiversityActivity> createState() =>
      _MountainDiversityActivityState();
}

class _MountainDiversityActivityState extends State<MountainDiversityActivity> {
  static const _plantMarkerSize = 48.0;

  Station2SamplingTool? _selectedTool;
  bool _toolPlaced = false;
  final _controllers = {
    for (final s in kStation2PlantSpecies) s.id: TextEditingController(),
  };
  final _focusNodes = {
    for (final s in kStation2PlantSpecies) s.id: FocusNode(),
  };
  /// null = not checked yet; true/false after the field loses focus.
  final Map<String, bool?> _fieldCorrect = {
    for (final s in kStation2PlantSpecies) s.id: null,
  };
  String? _feedback;
  bool _submitted = false;
  int _activityScore = 0;

  @override
  void initState() {
    super.initState();
    for (final entry in _focusNodes.entries) {
      entry.value.addListener(() {
        if (!entry.value.hasFocus) _validateField(entry.key);
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    for (final n in _focusNodes.values) {
      n.dispose();
    }
    super.dispose();
  }

  Station2PlantSpecies _species(String id) =>
      kStation2PlantSpecies.firstWhere((s) => s.id == id);

  void _selectTool(Station2SamplingTool tool) {
    setState(() {
      _selectedTool = tool;
      _toolPlaced = false;
      _feedback = null;
      _submitted = false;
      _activityScore = 0;
      for (final id in _fieldCorrect.keys) {
        _fieldCorrect[id] = null;
      }
    });
  }

  void _placeTool() {
    if (_selectedTool == null) {
      setState(() => _feedback = 'Select a sampling tool first.');
      return;
    }
    setState(() {
      _toolPlaced = true;
      _feedback = null;
    });
  }

  int _scoreFromFields() {
    var score = 0;
    for (final species in kStation2PlantSpecies) {
      if (_fieldCorrect[species.id] == true) score++;
    }
    return score;
  }

  void _validateField(String speciesId) {
    if (!_toolPlaced || _submitted || !mounted) return;
    final raw = _controllers[speciesId]!.text.trim();
    if (raw.isEmpty) {
      setState(() {
        _fieldCorrect[speciesId] = null;
        _activityScore = _scoreFromFields();
        _feedback = null;
      });
      return;
    }

    final entered = int.tryParse(raw);
    final expected = kStation2MountainDiversityAnswerKey[speciesId]!;
    setState(() {
      _fieldCorrect[speciesId] = entered == expected;
      _activityScore = _scoreFromFields();
      final checked = _fieldCorrect.values.where((v) => v != null).length;
      if (checked > 0) {
        _feedback =
            'Score: $_activityScore / ${kStation2PlantSpecies.length}';
      }
    });
  }

  void _submit() {
    if (_selectedTool == null || !_toolPlaced) {
      setState(
        () => _feedback = 'Select a tool and tap the study area to place it.',
      );
      return;
    }

    for (final species in kStation2PlantSpecies) {
      final entered = int.tryParse(_controllers[species.id]!.text.trim());
      final expected = kStation2MountainDiversityAnswerKey[species.id]!;
      _fieldCorrect[species.id] = entered == expected;
    }

    final score = _scoreFromFields();
    final total = kStation2PlantSpecies.length;
    setState(() {
      _submitted = true;
      _activityScore = score;
      _feedback = score == total
          ? 'Excellent! Your counts match the plants in your sample. '
              'Score: $score / $total'
          : 'You scored $score out of $total species. Tap Continue to takeaway.';
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
            _studyAreaSection(),
            const SizedBox(height: 14),
            _toolSection(),
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
            'ACTIVITY 1: MOUNTAIN PLANT DIVERSITY INVESTIGATION',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: BioColors.forest,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            kStation2MountainDiversityIntro,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, height: 1.45),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < kStation2MountainDiversitySteps.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text.rich(
                readingTextSpan(
                  '${i + 1}. ${kStation2MountainDiversitySteps[i]}',
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
                kStation2MountainDiversityReminder,
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
            'PLANT SPECIES GUIDE',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: BioColors.forest,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Match each plant in the study area to these pictures.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, height: 1.35),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final twoCol = constraints.maxWidth >= 520;
              if (twoCol) {
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final species in kStation2PlantSpecies)
                      SizedBox(
                        width: (constraints.maxWidth - 10) / 2,
                        child: _speciesCard(species),
                      ),
                  ],
                );
              }
              return Column(
                children: [
                  for (var i = 0; i < kStation2PlantSpecies.length; i++) ...[
                    if (i > 0) const SizedBox(height: 10),
                    _speciesCard(kStation2PlantSpecies[i]),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _speciesCard(Station2PlantSpecies species) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BioColors.leaf.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 72,
              height: 72,
              child: GameImage(
                asset: species.imageAsset,
                label: species.name,
                fit: BoxFit.cover,
                color: BioColors.moss,
                icon: Icons.eco,
                cacheWidth: 160,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  species.name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: BioColors.forest,
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

  Widget _studyAreaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'STUDY AREA',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: BioColors.forest,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _toolPlaced
              ? 'Count each plant icon that belongs in your sample.'
              : _selectedTool == null
                  ? 'Pick a tool below, then tap here to place it.'
                  : 'Tap the study area to place your ${_toolLabel(_selectedTool!)}.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        AspectRatio(
          aspectRatio: 16 / 10,
          child: _studyArea(),
        ),
        if (_toolPlaced && _selectedTool != null) ...[
          const SizedBox(height: 10),
          _sampleLegend(),
        ],
      ],
    );
  }

  String _toolLabel(Station2SamplingTool tool) {
    return kStation2SamplingTools
        .firstWhere((t) => t.tool == tool)
        .label;
  }

  Widget _sampleLegend() {
    final tool = _selectedTool!;
    final counted = kStation2MountainPlantMarkers
        .where((m) => station2PlantCounted(m, tool))
        .toList();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BioColors.moss),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Plants in your ${_toolLabel(tool)} sample: ${counted.length} total',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: BioColors.forest,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Use the guide above to name each plant, then enter how many of '
            'each species you counted.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, height: 1.35),
          ),
        ],
      ),
    );
  }

  Widget _studyArea() {
    final tool = _selectedTool;
    final placed = _toolPlaced;

    return GestureDetector(
      onTap: _placeTool,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _selectedTool == null
                ? BioColors.bark.withValues(alpha: 0.35)
                : BioColors.moss,
            width: _selectedTool == null ? 2 : 3,
          ),
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
                label: 'Study area',
                fit: BoxFit.cover,
                color: BioColors.forest,
                icon: Icons.terrain,
                cacheWidth: 1200,
              ),
              if (placed && tool != null) ..._toolOverlay(tool),
              ..._elevationDividers(),
              _elevationSideLabels(),
              ..._plantMarkers(tool, placed),
              if (_selectedTool != null && !placed) _studyHint('TAP TO PLACE TOOL'),
              if (_selectedTool == null) _studyHint('SELECT A TOOL FIRST'),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _toolOverlay(Station2SamplingTool tool) {
    switch (tool) {
      case Station2SamplingTool.quadrat:
        return [
          Positioned.fill(
            child: FractionallySizedBox(
              widthFactor: kStation2QuadratWidth,
              heightFactor: kStation2QuadratHeight,
              alignment: Alignment(
                (kStation2QuadratLeft + kStation2QuadratWidth / 2) * 2 - 1,
                (kStation2QuadratTop + kStation2QuadratHeight / 2) * 2 - 1,
              ),
              child: GameImage(
                asset: kStation2SamplingTools[0].imageAsset,
                label: 'Quadrat',
                fit: BoxFit.contain,
                color: BioColors.bark,
                icon: Icons.crop_square,
                cacheWidth: 480,
              ),
            ),
          ),
        ];
      case Station2SamplingTool.lineTransect:
        return [
          Positioned.fill(
            child: Align(
              alignment: Alignment(0, kStation2TransectY * 2 - 1),
              child: FractionallySizedBox(
                widthFactor: 0.92,
                heightFactor: 0.24,
                child: GameImage(
                  asset: kStation2SamplingTools[1].imageAsset,
                  label: 'Line transect',
                  fit: BoxFit.contain,
                  color: BioColors.danger,
                  icon: Icons.horizontal_rule,
                  cacheWidth: 480,
                ),
              ),
            ),
          ),
        ];
      case Station2SamplingTool.stratified:
        return [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: GameImage(
                asset: kStation2SamplingTools[2].imageAsset,
                label: 'Stratified grid',
                fit: BoxFit.contain,
                color: BioColors.sky,
                icon: Icons.grid_on,
                cacheWidth: 480,
              ),
            ),
          ),
        ];
    }
  }

  List<Widget> _elevationDividers() {
    return [
      for (final y in [
        kStation2ElevationHighMidY,
        kStation2ElevationMidLowY,
      ])
        Positioned(
          left: 56,
          right: 8,
          top: 0,
          bottom: 0,
          child: Align(
            alignment: Alignment(0, y * 2 - 1),
            child: Container(
              height: 3,
              decoration: BoxDecoration(
                color: BioColors.danger,
                borderRadius: BorderRadius.circular(2),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ),
    ];
  }

  Widget _elevationSideLabels() {
    return Positioned(
      left: 4,
      top: 8,
      bottom: 8,
      width: 48,
      child: Column(
        children: [
          Expanded(
            child: _elevationLabel('High'),
          ),
          Expanded(
            child: _elevationLabel('Mid'),
          ),
          Expanded(
            child: _elevationLabel('Lower'),
          ),
        ],
      ),
    );
  }

  Widget _elevationLabel(String text) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: BioColors.danger.withValues(alpha: 0.75)),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            height: 1.15,
            color: BioColors.forest,
          ),
        ),
      ),
    );
  }

  List<Widget> _plantMarkers(Station2SamplingTool? tool, bool placed) {
    return [
      for (final marker in kStation2MountainPlantMarkers)
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
            child: _plantMarker(
              species: _species(marker.speciesId),
              highlighted:
                  placed && tool != null && station2PlantCounted(marker, tool),
              dimmed: placed && tool != null && !station2PlantCounted(marker, tool),
            ),
          ),
        ),
    ];
  }

  Widget _plantMarker({
    required Station2PlantSpecies species,
    required bool highlighted,
    required bool dimmed,
  }) {
    final visible = highlighted || !dimmed;
    if (!visible && dimmed) {
      return const SizedBox.shrink();
    }

    final opacity = highlighted ? 1.0 : 0.35;

    return Opacity(
      opacity: opacity,
      child: Container(
        width: _plantMarkerSize,
        height: _plantMarkerSize,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: highlighted ? BioColors.forest : Colors.white,
            width: highlighted ? 3 : 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: highlighted ? 0.35 : 0.15),
              blurRadius: highlighted ? 6 : 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: GameImage(
            asset: species.imageAsset,
            label: species.name,
            fit: BoxFit.cover,
            color: BioColors.moss,
            icon: Icons.eco,
            cacheWidth: 128,
          ),
        ),
      ),
    );
  }

  Widget _studyHint(String text) {
    return Positioned(
      left: 12,
      right: 12,
      bottom: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }

  Widget _toolSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'CHOOSE A SAMPLING TOOL',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: BioColors.forest,
          ),
        ),
        const SizedBox(height: 10),
        for (var i = 0; i < kStation2SamplingTools.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          _toolCard(kStation2SamplingTools[i]),
        ],
      ],
    );
  }

  Widget _toolCard(Station2SamplingToolInfo info) {
    final selected = _selectedTool == info.tool;
    return Material(
      color: selected
          ? BioColors.paleLeaf.withValues(alpha: 0.95)
          : Colors.white.withValues(alpha: 0.95),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _selectTool(info.tool),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? BioColors.forest
                  : BioColors.bark.withValues(alpha: 0.25),
              width: selected ? 3 : 2,
            ),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 100,
                  height: 72,
                  child: GameImage(
                    asset: info.imageAsset,
                    label: info.label,
                    fit: BoxFit.cover,
                    color: BioColors.bark,
                    icon: Icons.handyman,
                    cacheWidth: 240,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      info.label,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: selected ? BioColors.forest : BioColors.ink,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text.rich(
                      readingTextSpan(
                        info.countRule,
                        fontSize: 15,
                        color: BioColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                const Icon(Icons.check_circle, color: BioColors.forest, size: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dataTable() {
    final canSubmit = _toolPlaced && !_submitted;
    final checkedCount =
        _fieldCorrect.values.where((v) => v != null).length;

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
            'Enter the total number of individuals of each species counted '
            'in your sample collected from the mid-elevation zone.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, height: 1.35),
          ),
          if (checkedCount > 0) ...[
            const SizedBox(height: 8),
            Text(
              'Score: $_activityScore / ${kStation2PlantSpecies.length}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: _activityScore == kStation2PlantSpecies.length
                    ? BioColors.correct
                    : BioColors.forest,
              ),
            ),
          ],
          const SizedBox(height: 14),
          for (final species in kStation2PlantSpecies) ...[
            _dataRow(species),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 6),
          PrimaryButton(
            label: _submitted ? 'Continue to Takeaway' : 'Submit Answers',
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

  Widget _dataRow(Station2PlantSpecies species) {
    final correct = _fieldCorrect[species.id];
    final borderColor = correct == null
        ? BioColors.leaf.withValues(alpha: 0.5)
        : (correct ? BioColors.correct : BioColors.danger);
    final inputBorderColor = correct == null
        ? BioColors.forest
        : (correct ? BioColors.correct : BioColors.danger);
    final fillColor = !_toolPlaced
        ? BioColors.paleLeaf.withValues(alpha: 0.4)
        : correct == null
            ? Colors.white
            : (correct ? BioColors.correct : BioColors.danger)
                .withValues(alpha: 0.12);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: correct == null ? 1 : 2),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 52,
              height: 52,
              child: GameImage(
                asset: species.imageAsset,
                label: species.name,
                fit: BoxFit.cover,
                color: BioColors.moss,
                icon: Icons.eco,
                cacheWidth: 128,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              species.name,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (correct != null) ...[
            Icon(
              correct ? Icons.check_circle : Icons.cancel,
              color: correct ? BioColors.correct : BioColors.danger,
              size: 26,
            ),
            const SizedBox(width: 8),
          ],
          SizedBox(
            width: 88,
            child: TextField(
              controller: _controllers[species.id],
              focusNode: _focusNodes[species.id],
              enabled: _toolPlaced && !_submitted,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              onEditingComplete: () {
                _focusNodes[species.id]!.unfocus();
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: fillColor,
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
                  borderSide: BorderSide(color: inputBorderColor, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: correct == false ? BioColors.danger : BioColors.forest,
                    width: 2.5,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: inputBorderColor, width: 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _feedbackBanner() {
    final perfect = _activityScore == kStation2PlantSpecies.length;
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
