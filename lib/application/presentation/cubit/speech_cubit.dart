import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'speech_state.dart';
import 'package:speech_text/core/utls/nepali_romanizer.dart';
import 'package:speech_text/core/services/dataset_service.dart';

@lazySingleton
class SpeechCubit extends Cubit<SpeechState> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final DatasetService _datasetService = DatasetService();

  SpeechCubit() : super(const SpeechState()) {
    _initializeSpeech();
    _loadDataset();
  }

  Future<void> _loadDataset() async {
    try {
      await _datasetService.loadDataset();
      emit(state.copyWith(datasetSize: _datasetService.getDatasetSize()));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to load dataset: $e'));
    }
  }

  Future<void> _initializeSpeech() async {
    try {
      final isAvailable = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done') {
            emit(state.copyWith(isListening: false));
          }
        },
        onError: (errorNotification) {
          emit(
            state.copyWith(
              error: errorNotification.errorMsg,
              isListening: false,
            ),
          );
        },
      );

      emit(state.copyWith(isAvailable: isAvailable));
    } catch (e) {
      emit(
        state.copyWith(
          error: 'Failed to initialize speech recognition: $e',
          isAvailable: false,
        ),
      );
    }
  }

  Future<void> startListening() async {
    if (!state.isAvailable) {
      emit(state.copyWith(error: 'Speech recognition not available'));
      return;
    }

    try {
      await _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            final nepaliText = result.recognizedWords;
            final romanizedText = NepaliRomanizer.romanize(nepaliText);

            // Find matching entries from dataset
            final matches = _datasetService.findMatches(romanizedText);

            emit(
              state.copyWith(
                recognizedText: romanizedText,
                confidence: result.confidence,
                isListening: false,
                matches: matches,
                matchCount: matches.length,
              ),
            );
          }
        },
        localeId: 'ne-NP',
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 5),
      );

      emit(state.copyWith(isListening: true, error: ''));
    } catch (e) {
      emit(
        state.copyWith(
          error: 'Failed to start listening: $e',
          isListening: false,
        ),
      );
    }
  }

  Future<void> stopListening() async {
    try {
      await _speech.stop();
      emit(state.copyWith(isListening: false));
    } catch (e) {
      emit(
        state.copyWith(
          error: 'Failed to stop listening: $e',
          isListening: false,
        ),
      );
    }
  }

  void clearText() {
    emit(
      state.copyWith(recognizedText: '', error: '', matches: [], matchCount: 0),
    );
  }

  @override
  Future<void> close() {
    _speech.stop();
    _datasetService.clear();
    return super.close();
  }
}
