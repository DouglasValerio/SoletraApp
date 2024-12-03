import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soletra_app/repositories/word_game_repository_impl.dart';

import 'package:soletra_app/views/widgets/word_game_widget.dart';

import 'bloc/word_game_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WordGameBloc>(
          create: (context) => WordGameBloc(
            wordGameRepository: WordGameRepositoryImpl()
          ),
        ),
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
