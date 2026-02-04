import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_text/application/presentation/cubit/speech_cubit.dart';
import 'package:speech_text/application/presentation/cubit/speech_state.dart';

class SpeechScreen extends StatelessWidget {
  const SpeechScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech to Text'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 22),
            onPressed: () {
              context.read<SpeechCubit>().clearText();
            },
            tooltip: 'Clear text',
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BlocBuilder<SpeechCubit, SpeechState>(
                builder: (context, state) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _buildStatusIndicator(state),
                            const SizedBox(width: 12),
                            Expanded(child: _buildStatusText(state)),
                          ],
                        ),
                        if (state.error.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              state.error,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        if (state.confidence > 0 || state.datasetSize > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Row(
                              children: [
                                if (state.confidence > 0)
                                  _buildInfoChip(
                                    'Confidence: ${(state.confidence * 100).toStringAsFixed(1)}%',
                                    Colors.green,
                                  ),
                                if (state.confidence > 0 &&
                                    state.datasetSize > 0)
                                  const SizedBox(width: 8),
                                if (state.datasetSize > 0)
                                  _buildInfoChip(
                                    'Dataset: ${state.datasetSize}',
                                    Colors.blue,
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: BlocBuilder<SpeechCubit, SpeechState>(
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'RECOGNIZED TEXT',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 120,
                          child: SingleChildScrollView(
                            child: Text(
                              state.recognizedText.isEmpty
                                  ? 'Start speaking to see text here...'
                                  : state.recognizedText,
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.5,
                                color: state.recognizedText.isEmpty
                                    ? Colors.grey[500]
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: BlocBuilder<SpeechCubit, SpeechState>(
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'MATCHES',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[600],
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  state.matchCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (state.matches.isEmpty)
                            Expanded(
                              child: Center(
                                child: Text(
                                  'No matches found',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            )
                          else
                            Expanded(
                              child: ListView.separated(
                                itemCount: state.matches.length,
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        Divider(
                                          height: 20,
                                          thickness: 0.5,
                                          color: Colors.grey[300],
                                        ),
                                itemBuilder: (BuildContext context, int index) {
                                  final match = state.matches[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    match.nativeWord,
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    match.englishWord,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.blue[50],
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                border: Border.all(
                                                  color: Colors.blue[100]!,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Text(
                                                match.source.toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.blue[800],
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              BlocBuilder<SpeechCubit, SpeechState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      if (!state.isAvailable)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            'Speech recognition is not available',
                            style: TextStyle(
                              color: Colors.red[600],
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      Container(
                        height: 54,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: state.isAvailable
                              ? (state.isListening
                                    ? Colors.red[50]
                                    : Colors.blue[50])
                              : Colors.grey[100],
                          border: Border.all(
                            color: state.isAvailable
                                ? (state.isListening
                                      ? Colors.red[100]!
                                      : Colors.blue[100]!)
                                : Colors.grey[300]!,
                            width: 1.5,
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: state.isAvailable
                                ? () {
                                    if (state.isListening) {
                                      context
                                          .read<SpeechCubit>()
                                          .stopListening();
                                    } else {
                                      context
                                          .read<SpeechCubit>()
                                          .startListening();
                                    }
                                  }
                                : null,
                            borderRadius: BorderRadius.circular(8),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    state.isListening
                                        ? Icons.stop_circle
                                        : Icons.mic_none,
                                    size: 22,
                                    color: state.isAvailable
                                        ? (state.isListening
                                              ? Colors.red[600]
                                              : Colors.blue[600])
                                        : Colors.grey[500],
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    state.isListening
                                        ? 'STOP LISTENING'
                                        : 'START LISTENING',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: state.isAvailable
                                          ? (state.isListening
                                                ? Colors.red[600]
                                                : Colors.blue[600])
                                          : Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(SpeechState state) {
    if (!state.isAvailable) {
      return Icon(Icons.error_outline, color: Colors.red[600], size: 20);
    } else if (state.isListening) {
      return Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green),
        child: const Center(
          child: SizedBox(
            width: 8,
            height: 8,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      );
    } else {
      return Icon(
        Icons.check_circle_outline,
        color: Colors.green[600],
        size: 20,
      );
    }
  }

  Widget _buildStatusText(SpeechState state) {
    if (!state.isAvailable) {
      return Text(
        'Unavailable',
        style: TextStyle(
          color: Colors.red[600],
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      );
    } else if (state.isListening) {
      return Text(
        'Listening...',
        style: TextStyle(
          color: Colors.green[600],
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      );
    } else {
      return Text(
        'Ready',
        style: TextStyle(
          color: Colors.green[600],
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      );
    }
  }

  Widget _buildInfoChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
