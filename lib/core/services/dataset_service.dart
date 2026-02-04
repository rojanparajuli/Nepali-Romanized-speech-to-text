import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:speech_text/application/domain/entity/data_set_entry.dart';

@lazySingleton
class DatasetService {
  static final DatasetService _instance = DatasetService._internal();
  List<DatasetEntry> _dataset = [];
  bool _isLoaded = false;

  DatasetService._internal();

  factory DatasetService() {
    return _instance;
  }

  Future<void> loadDataset() async {
    if (_isLoaded) return;

    try {
      final jsonString = await rootBundle.loadString('assets/data_set.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      _dataset = jsonList
          .map((item) => DatasetEntry.fromJson(item as Map<String, dynamic>))
          .toList();
      _isLoaded = true;
    } catch (e) {
      throw Exception('Failed to load dataset: $e');
    }
  }

  List<DatasetEntry> findMatches(String input) {
    if (input.isEmpty || !_isLoaded) return [];

    final lowerInput = input.toLowerCase().trim();

    return _dataset
        .where(
          (entry) =>
              entry.englishWord.toLowerCase().contains(lowerInput) ||
              lowerInput.contains(entry.englishWord.toLowerCase()),
        )
        .toList();
  }

  DatasetEntry? findExactMatch(String input) {
    if (input.isEmpty || !_isLoaded) return null;

    final lowerInput = input.toLowerCase().trim();

    try {
      return _dataset.firstWhere(
        (entry) => entry.englishWord.toLowerCase() == lowerInput,
      );
    } catch (e) {
      return null;
    }
  }

  List<DatasetEntry> getAllEntries() => _dataset;

  DatasetEntry? getRandomEntry() {
    if (_dataset.isEmpty) return null;
    _dataset.shuffle();
    return _dataset.first;
  }

  List<DatasetEntry> searchByNativeWord(String nativeWord) {
    if (nativeWord.isEmpty || !_isLoaded) return [];

    final lowerInput = nativeWord.toLowerCase();
    return _dataset
        .where((entry) => entry.nativeWord.toLowerCase().contains(lowerInput))
        .toList();
  }

  int getDatasetSize() => _dataset.length;

  void clear() {
    _dataset = [];
    _isLoaded = false;
  }
}
