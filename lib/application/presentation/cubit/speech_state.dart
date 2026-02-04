import 'package:equatable/equatable.dart';
import 'package:speech_text/application/domain/entity/data_set_entry.dart';

class SpeechState extends Equatable {
  final bool isListening;
  final String recognizedText;
  final String error;
  final double confidence;
  final bool isAvailable;
  final List<DatasetEntry> matches;
  final int matchCount;
  final int datasetSize;

  const SpeechState({
    this.isListening = false,
    this.recognizedText = '',
    this.error = '',
    this.confidence = 0.0,
    this.isAvailable = false,
    this.matches = const [],
    this.matchCount = 0,
    this.datasetSize = 0,
  });

  SpeechState copyWith({
    bool? isListening,
    String? recognizedText,
    String? error,
    double? confidence,
    bool? isAvailable,
    List<DatasetEntry>? matches,
    int? matchCount,
    int? datasetSize,
  }) {
    return SpeechState(
      isListening: isListening ?? this.isListening,
      recognizedText: recognizedText ?? this.recognizedText,
      error: error ?? this.error,
      confidence: confidence ?? this.confidence,
      isAvailable: isAvailable ?? this.isAvailable,
      matches: matches ?? this.matches,
      matchCount: matchCount ?? this.matchCount,
      datasetSize: datasetSize ?? this.datasetSize,
    );
  }

  @override
  List<Object> get props => [
    isListening,
    recognizedText,
    error,
    confidence,
    isAvailable,
    matches,
    matchCount,
    datasetSize,
  ];
}