class DatasetEntry {
  final String uniqueIdentifier;
  final String nativeWord;
  final String englishWord;
  final String source;

  DatasetEntry({
    required this.uniqueIdentifier,
    required this.nativeWord,
    required this.englishWord,
    required this.source,
  });

  factory DatasetEntry.fromJson(Map<String, dynamic> json) {
    return DatasetEntry(
      uniqueIdentifier: json['unique_identifier'] as String,
      nativeWord: json['native word'] as String,
      englishWord: json['english word'] as String,
      source: json['source'] as String,
    );
  }
}