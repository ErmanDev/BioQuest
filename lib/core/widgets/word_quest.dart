import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../models/vocab_word.dart';

/// Bottom-right button that opens the Word Quest vocabulary overlay.
class WordQuestButton extends StatelessWidget {
  const WordQuestButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: BioColors.deepSky,
      borderRadius: BorderRadius.circular(16),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_stories, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Word Quest',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    'Tap to learn new words!',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shows the Word Quest vocabulary overlay for [words].
void showWordQuestOverlay(BuildContext context, List<VocabWord> words) {
  showDialog<void>(
    context: context,
    barrierColor: Colors.black54,
    builder: (dialogContext) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 640),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 14),
          decoration: BoxDecoration(
            color: BioColors.parchment,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: BioColors.deepSky, width: 3),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.auto_stories,
                    color: BioColors.deepSky,
                    size: 26,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'WORD QUEST',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: BioColors.deepSky,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    icon: const Icon(Icons.close, color: BioColors.deepSky),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Learn new words from this station:',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: BioColors.ink,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: words.length,
                  separatorBuilder: (_, _) => const Divider(
                    height: 22,
                    color: BioColors.leaf,
                  ),
                  itemBuilder: (context, i) => _VocabItem(word: words[i]),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// One vocabulary entry (term, definition, in-context sentence) in the
/// Word Quest overlay.
class _VocabItem extends StatelessWidget {
  const _VocabItem({required this.word});

  final VocabWord word;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          word.term,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: BioColors.deepSky,
          ),
        ),
        const SizedBox(height: 4),
        _VocabLine(label: 'Definition: ', text: word.definition),
        const SizedBox(height: 4),
        _VocabLine(label: 'In Context: ', text: word.context),
      ],
    );
  }
}

class _VocabLine extends StatelessWidget {
  const _VocabLine({required this.label, required this.text});

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14,
          height: 1.35,
          color: BioColors.ink,
        ),
        children: [
          TextSpan(
            text: label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: text),
        ],
      ),
    );
  }
}
