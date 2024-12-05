import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soletra_app/bloc/letters/letters_bloc.dart';
import 'package:soletra_app/di/injection.dart';

import 'package:soletra_app/views/widgets/word_game_widget.dart';

import 'bloc/word_game/word_game_bloc.dart';

Future<void> main() async {
  await setupInjection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WordGameBloc>(
          create: (context) => injector<WordGameBloc>(),
        ),
        BlocProvider<LettersBloc>(create: (context) => injector<LettersBloc>()),
      ],
      child: MaterialApp(
        title: 'Spelling Fly',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const WordGameUI(),
      ),
    );
  }
}
