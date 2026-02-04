import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_text/application/presentation/cubit/speech_cubit.dart';
import 'package:speech_text/application/presentation/pages/speech_screen.dart';
import 'package:speech_text/core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Speech to Text',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: BlocProvider(
        create: (context) => SpeechCubit(),
        child: const SpeechScreen(),
      ),
    );
  }
}
