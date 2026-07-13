import 'package:flutter/material.dart';

/// Strips lightweight markup before TTS or plain-text use.
String stripReadingMarkup(String text) => text
    .replaceAllMapped(RegExp(r'\*\*(.+?)\*\*'), (m) => m.group(1)!)
    .replaceAllMapped(RegExp(r'\*(.+?)\*'), (m) => m.group(1)!);

/// Renders reading content with **bold** and *italic* segments.
TextSpan readingTextSpan(
  String text, {
  required double fontSize,
  Color color = const Color(0xFF263238),
  double height = 1.55,
}) {
  final baseStyle = TextStyle(
    fontSize: fontSize,
    height: height,
    color: color,
  );

  return TextSpan(
    children: _markupSpans(text, baseStyle),
  );
}

List<TextSpan> _markupSpans(String text, TextStyle baseStyle) {
  final boldStyle = baseStyle.copyWith(fontWeight: FontWeight.bold);
  final italicStyle = baseStyle.copyWith(fontStyle: FontStyle.italic);
  final spans = <TextSpan>[];
  final regex = RegExp(r'\*\*(.+?)\*\*|\*(.+?)\*');
  var start = 0;

  for (final match in regex.allMatches(text)) {
    if (match.start > start) {
      spans.add(TextSpan(
        text: text.substring(start, match.start),
        style: baseStyle,
      ));
    }
    if (match.group(1) != null) {
      spans.add(TextSpan(text: match.group(1), style: boldStyle));
    } else {
      spans.add(TextSpan(text: match.group(2), style: italicStyle));
    }
    start = match.end;
  }

  if (start < text.length) {
    spans.add(TextSpan(text: text.substring(start), style: baseStyle));
  }

  if (spans.isEmpty) {
    return [TextSpan(text: text, style: baseStyle)];
  }

  return spans;
}
