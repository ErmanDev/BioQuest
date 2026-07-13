import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../core/widgets/game_image.dart';
import '../../data/station3_data.dart';

/// Discovery Stop table of research instruments with images.
class ResearchInstrumentsTable extends StatelessWidget {
  final double fontSize;

  const ResearchInstrumentsTable({super.key, this.fontSize = 13});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          kStation3DiscoveryInstrumentsIntro,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize,
            height: 1.4,
            color: BioColors.ink,
          ),
        ),
        const SizedBox(height: 10),
        Table(
          border: TableBorder.all(
            color: BioColors.sun.withValues(alpha: 0.85),
            width: 1.5,
          ),
          columnWidths: const {
            0: FlexColumnWidth(1.15),
            1: FlexColumnWidth(0.9),
            2: FlexColumnWidth(1.35),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              decoration: const BoxDecoration(color: BioColors.sun),
              children: [
                _headerCell('Instrument'),
                _headerCell('IMAGE'),
                _headerCell('Purpose'),
              ],
            ),
            for (var i = 0; i < kStation3ResearchInstruments.length; i++)
              TableRow(
                decoration: BoxDecoration(
                  color: i.isEven
                      ? const Color(0xFFFFF9E1)
                      : Colors.white,
                ),
                children: [
                  _nameCell(kStation3ResearchInstruments[i].name),
                  _imageCell(kStation3ResearchInstruments[i]),
                  _purposeCell(kStation3ResearchInstruments[i].purpose),
                ],
              ),
          ],
        ),
      ],
    );
  }

  Widget _headerCell(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _nameCell(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Text(
        name,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          color: BioColors.ink,
          height: 1.3,
        ),
      ),
    );
  }

  Widget _imageCell(Station3ResearchInstrument instrument) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: SizedBox(
        height: 52,
        child: GameImage(
          asset: instrument.imageAsset,
          label: instrument.name,
          fit: BoxFit.contain,
          color: BioColors.moss,
          icon: Icons.science,
          cacheWidth: 160,
        ),
      ),
    );
  }

  Widget _purposeCell(String purpose) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Text(
        purpose,
        style: TextStyle(
          fontSize: fontSize,
          color: BioColors.ink,
          height: 1.3,
        ),
      ),
    );
  }
}
