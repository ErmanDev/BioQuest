import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../text_format.dart';
import '../../models/vocab_word.dart';

/// Bottom-right button that opens the Word Quest vocabulary overlay, styled as
/// a wooden trail sign with a book-and-magnifier badge.
class WordQuestButton extends StatelessWidget {
  const WordQuestButton({super.key, required this.onTap});

  final VoidCallback onTap;

  static const _woodLight = Color(0xFFEBD3A0);
  static const _woodDark = Color(0xFFC79A5B);
  static const _edge = Color(0xFF4E3018);
  static const _trim = Color(0xFF8A5C2E);
  static const _textDark = Color(0xFF3B2210);

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(14);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: _edge, width: 3),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_woodLight, _woodDark],
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Container(
            margin: const EdgeInsets.all(3),
            padding: const EdgeInsets.fromLTRB(6, 6, 20, 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _trim.withValues(alpha: 0.7),
                width: 1.5,
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _BookBadge(),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'WORD QUEST',
                      style: TextStyle(
                        color: _textDark,
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                        letterSpacing: 1,
                        height: 1.1,
                        shadows: [
                          Shadow(
                            color: Color(0x66FFFFFF),
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Tap to learn new words!',
                      style: TextStyle(
                        color: _textDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Round wooden badge with a green ring, an open book, and a magnifier.
class _BookBadge extends StatelessWidget {
  const _BookBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          colors: [Color(0xFF8C5A2B), Color(0xFF5A3517)],
        ),
        border: Border.all(color: BioColors.forest, width: 3.5),
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 3, offset: Offset(0, 2)),
        ],
      ),
      child: const Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.menu_book_rounded, color: Color(0xFFFFF3D6), size: 30),
          Positioned(
            right: 2,
            bottom: 2,
            child: Icon(
              Icons.search_rounded,
              color: Color(0xFFFFD54F),
              size: 26,
              shadows: [Shadow(color: Colors.black54, blurRadius: 2)],
            ),
          ),
        ],
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
                  separatorBuilder: (_, _) =>
                      const Divider(height: 22, color: BioColors.leaf),
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
          readingTextSpan(
            text,
            fontSize: 14,
            height: 1.35,
            color: BioColors.ink,
          ),
        ],
      ),
    );
  }
}
