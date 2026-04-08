class DictionaryEntry {
  const DictionaryEntry({
    required this.id,
    required this.word,
    required this.definition,
    required this.examples,
    required this.partOfSpeech,
    required this.synonyms,
    required this.dialects,
    required this.searchKey,
    required this.rawEntry,
  });

  final int id;
  final String word;
  final String definition;
  final String examples;
  final String partOfSpeech;
  final String synonyms;
  final String dialects;
  final String searchKey;
  final String rawEntry;

  factory DictionaryEntry.fromJson(Map<String, dynamic> json) {
    return DictionaryEntry(
      id: json['id'] as int,
      word: json['word'] as String,
      definition: json['definition'] as String? ?? '',
      examples: json['examples'] as String? ?? '',
      partOfSpeech: json['partOfSpeech'] as String? ?? '',
      synonyms: json['synonyms'] as String? ?? '',
      dialects: json['dialects'] as String? ?? '',
      searchKey: json['searchKey'] as String? ?? '',
      rawEntry: json['rawEntry'] as String? ?? '',
    );
  }
}
