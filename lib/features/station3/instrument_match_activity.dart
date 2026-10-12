import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/theme.dart';
import '../../core/widgets/game_image.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/station3_data.dart';
import '../../services/audio_service.dart';

/// Part II tap-to-match: select an instrument, then tap the matching task.
class InstrumentMatchActivity extends StatefulWidget {
  final VoidCallback onCompleted;
  final VoidCallback? onNext;

  const InstrumentMatchActivity({
    super.key,
    required this.onCompleted,
    this.onNext,
  });

  @override
  State<InstrumentMatchActivity> createState() =>
      _InstrumentMatchActivityState();
}

class _InstrumentMatchActivityState extends State<InstrumentMatchActivity>
    with SingleTickerProviderStateMixin {
  late List<Station3ResearchInstrument> _bank;
  final List<String?> _matches =
      List<String?>.filled(kStation3InstrumentMatchTasks.length, null);
  String? _selectedInstrumentFile;
  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  );
  int? _shakingTask;
  String? _wrongInstrumentFile;

  bool get _allMatched =>
      _matches.every((match) => match != null) &&
      _matches.length == kStation3InstrumentMatchTasks.length;

  Set<String> get _usedFiles => _matches.whereType<String>().toSet();

  @override
  void initState() {
    super.initState();
    _bank = List<Station3ResearchInstrument>.from(kStation3ResearchInstruments)
      ..shuffle(math.Random(17));
  }

  @override
  void dispose() {
    _shake.dispose();
    super.dispose();
  }

  void _selectInstrument(String imageFile) {
    if (_usedFiles.contains(imageFile)) return;
    setState(() {
      _selectedInstrumentFile =
          _selectedInstrumentFile == imageFile ? null : imageFile;
      _wrongInstrumentFile = null;
    });
  }

  void _tapTask(int taskIndex) {
    if (_matches[taskIndex] != null) return;

    final selected = _selectedInstrumentFile;
    if (selected == null) return;

    final expected = kStation3InstrumentMatchTasks[taskIndex].instrumentFile;
    if (selected == expected) {
      setState(() {
        _matches[taskIndex] = selected;
        _selectedInstrumentFile = null;
        _wrongInstrumentFile = null;
      });
      if (_allMatched) widget.onCompleted();
    } else {
      context.read<AudioService>().playWrong();
      setState(() {
        _shakingTask = taskIndex;
        _wrongInstrumentFile = selected;
      });
      _shake.forward(from: 0).whenComplete(() {
        if (mounted) setState(() => _shakingTask = null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(),
        const SizedBox(height: 8),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 11, child: _tasksColumn()),
              const SizedBox(width: 8),
              Expanded(flex: 9, child: _instrumentsGrid()),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _footer(),
      ],
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.eco, color: BioColors.moss, size: 18),
            SizedBox(width: 6),
            Flexible(
              child: Text(
                'PART II: MATCH THE INSTRUMENT TO THE TASK',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: BioColors.forest,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            SizedBox(width: 6),
            Icon(Icons.eco, color: BioColors.moss, size: 18),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Icon(Icons.lightbulb_outline, color: BioColors.sun, size: 18),
            SizedBox(width: 6),
            Expanded(
              child: Text(
                'Tap an instrument, then tap the laboratory task it matches.',
                style: TextStyle(fontSize: 12.5, height: 1.35, color: BioColors.ink),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _tasksColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'LABORATORY TASKS',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: BioColors.forest,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (var i = 0; i < kStation3InstrumentMatchTasks.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: _taskRow(i),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _taskRow(int taskIndex) {
    final task = kStation3InstrumentMatchTasks[taskIndex];
    final matchedFile = _matches[taskIndex];
    final matched = matchedFile != null
        ? station3InstrumentByFile(matchedFile)
        : null;
    final shaking = _shakingTask == taskIndex;
    final canPlace = _selectedInstrumentFile != null && matched == null;

    return AnimatedBuilder(
      animation: _shake,
      builder: (context, child) {
        final dx = shaking && _shake.isAnimating
            ? math.sin(_shake.value * math.pi * 4) * 8 * (1 - _shake.value)
            : 0.0;
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: Material(
        color: matched != null
            ? BioColors.correct.withValues(alpha: 0.12)
            : canPlace
                ? BioColors.paleLeaf.withValues(alpha: 0.55)
                : Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: matched == null ? () => _tapTask(taskIndex) : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: matched != null
                    ? BioColors.correct
                    : canPlace
                        ? BioColors.forest
                        : BioColors.bark.withValues(alpha: 0.35),
                width: matched != null ? 2 : 1.5,
              ),
              boxShadow: matched != null
                  ? [
                      BoxShadow(
                        color: BioColors.correct.withValues(alpha: 0.25),
                        blurRadius: 6,
                        spreadRadius: 0.5,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: BioColors.forest,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${taskIndex + 1}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    task.task,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                      color: BioColors.ink,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                _taskSlot(matched),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _taskSlot(Station3ResearchInstrument? matched) {
    if (matched != null) {
      return Container(
        width: 52,
        height: 52,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: BioColors.correct.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: BioColors.correct, width: 1.5),
        ),
        child: GameImage(
          asset: matched.imageAsset,
          label: matched.name,
          fit: BoxFit.contain,
          color: BioColors.moss,
          icon: Icons.science,
          cacheWidth: 120,
        ),
      );
    }

    return Container(
      width: 52,
      height: 52,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: BioColors.bark.withValues(alpha: 0.35),
          width: 1.5,
        ),
      ),
      child: Text(
        'Tap\nhere',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 8.5,
          fontWeight: FontWeight.w700,
          height: 1.1,
          color: BioColors.ink.withValues(alpha: 0.55),
        ),
      ),
    );
  }

  Widget _instrumentsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'INSTRUMENTS',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: BioColors.forest,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 0.82,
            ),
            itemCount: _bank.length,
            itemBuilder: (context, index) => _instrumentTile(_bank[index]),
          ),
        ),
      ],
    );
  }

  Widget _instrumentTile(Station3ResearchInstrument instrument) {
    final file = instrument.imageFile;
    final used = _usedFiles.contains(file);
    final selected = _selectedInstrumentFile == file;
    final wrong = _wrongInstrumentFile == file;

    return AnimatedBuilder(
      animation: _shake,
      builder: (context, child) {
        final dx = wrong && _shake.isAnimating
            ? math.sin(_shake.value * math.pi * 4) * 6 * (1 - _shake.value)
            : 0.0;
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: Material(
        color: used
            ? BioColors.correct.withValues(alpha: 0.18)
            : wrong
                ? BioColors.danger.withValues(alpha: 0.12)
                : selected
                    ? BioColors.paleLeaf.withValues(alpha: 0.9)
                    : Colors.white,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: used ? null : () => _selectInstrument(file),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: used
                    ? BioColors.correct
                    : wrong
                        ? BioColors.danger
                        : selected
                            ? BioColors.forest
                            : BioColors.bark.withValues(alpha: 0.35),
                width: selected || used ? 2 : 1.5,
              ),
              boxShadow: used
                  ? [
                      BoxShadow(
                        color: BioColors.correct.withValues(alpha: 0.3),
                        blurRadius: 6,
                      ),
                    ]
                  : null,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Opacity(
                    opacity: used ? 0.55 : 1,
                    child: GameImage(
                      asset: instrument.imageAsset,
                      label: instrument.name,
                      fit: BoxFit.contain,
                      color: BioColors.moss,
                      icon: Icons.science,
                      cacheWidth: 120,
                    ),
                  ),
                ),
                Text(
                  instrument.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700,
                    height: 1.05,
                    color: used ? BioColors.correct : BioColors.ink,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _footer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: BioColors.sun.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: BioColors.sun.withValues(alpha: 0.45)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb, color: BioColors.sun, size: 18),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'TIP: Choose the instrument that best fits each '
                    'laboratory task!',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                      color: BioColors.ink,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        if (_allMatched)
          PrimaryButton(
            label: 'Proceed to Mission 3',
            icon: Icons.arrow_forward,
            color: BioColors.forest,
            fontSize: 13,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            onTap: widget.onNext,
          ),
      ],
    );
  }
}
