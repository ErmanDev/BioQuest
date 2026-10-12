import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../data/references_data.dart';

/// Scrollable APA reference list, shown from the Expedition Map and the
/// summit certificate.
class ReferencesPanel extends StatelessWidget {
  const ReferencesPanel({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(
      fontSize: 18,
      height: 1.45,
      fontWeight: FontWeight.w500,
      color: BioColors.ink,
    );

    return Material(
      color: Colors.transparent,
      elevation: 12,
      shadowColor: Colors.black45,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 720,
        constraints: const BoxConstraints(maxHeight: 520),
        padding: const EdgeInsets.fromLTRB(28, 22, 16, 24),
        decoration: BoxDecoration(
          color: BioColors.parchment,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: BioColors.forest, width: 4),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 28,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.menu_book_rounded,
                  color: BioColors.forest,
                  size: 34,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'References',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: BioColors.forest,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(
                    Icons.close,
                    color: BioColors.forest,
                    size: 30,
                  ),
                  tooltip: 'Close',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                child: ListView.separated(
                  padding: const EdgeInsets.only(right: 12, top: 4, bottom: 8),
                  itemCount: kReferences.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    final entry = kReferences[index];
                    return Text.rich(
                      TextSpan(
                        style: bodyStyle,
                        children: [
                          for (final run in entry)
                            TextSpan(
                              text: run.text,
                              style: run.italic
                                  ? bodyStyle.copyWith(
                                      fontStyle: FontStyle.italic,
                                    )
                                  : null,
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
