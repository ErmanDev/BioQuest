/// A single Word Quest vocabulary entry shown in the Discovery Stop overlay.
class VocabWord {
  final String term;
  final String definition;
  final String context;

  const VocabWord({
    required this.term,
    required this.definition,
    required this.context,
  });
}
