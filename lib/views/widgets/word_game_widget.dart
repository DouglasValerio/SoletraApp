
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soletra_app/bloc/letters/letters_bloc.dart';

import 'package:soletra_app/bloc/word_game/word_game_bloc.dart';
import 'package:soletra_app/models/models.dart';
import 'package:soletra_app/views/widgets/outer_letters_widget.dart';

class WordGameUI extends StatefulWidget {
  const WordGameUI({super.key});

  @override
  State<WordGameUI> createState() => _WordGameUIState();
}

class _WordGameUIState extends State<WordGameUI> {
  final _controller = TextEditingController();

  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    context.read<WordGameBloc>().add(WordGameStarted());
    context.read<LettersBloc>().add(LettersStarted());
    Future.delayed(Duration.zero, () {
      _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                // Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.help_outline)),
          actions: const [
            Icon(Icons.more_vert),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Center(
              child: TextField(
                readOnly: true,
                showCursor: true,
                controller: _controller,
                focusNode: _focusNode,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            const SizedBox(
              height: 36,
            ),
            BlocBuilder<LettersBloc, LettersState>(
              builder: (context, state) {
                if (state is LettersLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is LettersSuccess) {
                  final letters = state.lettersModel.outerLetters;
                  final centerLetter = state.lettersModel.centralLetter;
                  return SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    height: MediaQuery.sizeOf(context).height * 0.2,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _controller.text =
                                '${_controller.text}${centerLetter.toUpperCase()}';
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.teal,
                            child: Text(
                              centerLetter.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        OuterLettersWidget(
                          letters: letters,
                          onTap: (value) {
                            _controller.text =
                                '${_controller.text}${value.toUpperCase()}';
                          },
                        )
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            const Spacer(),
            Center(
              child: IconButton(
                onPressed: () {
                  context.read<LettersBloc>().add(LettersRefresh());
                },
                color: Colors.teal,
                icon: const Icon(Icons.refresh_outlined),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      _controller.text = _controller.text
                          .substring(0, _controller.text.length - 1);
                    }
                  },
                  onLongPress: () {
                    _controller.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    textStyle: const TextStyle(fontWeight: FontWeight.w700),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Apagar',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<WordGameBloc>().add(
                          WordGameSubmitted(word: _controller.text),
                        );
                    _controller.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontWeight: FontWeight.w700),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Confirmar',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const FoundWordsWidget(),
            const SizedBox(height: 16),
          ],
        ),
        drawer: Placeholder(),
      ),
    );
  }
}

class FoundWordsWidget extends StatelessWidget {
  const FoundWordsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WordGameBloc, WordGameState>(
      listener: (context, state) {
        if (state is WordGameSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Palavra encontrada!'),
            ),
          );
        }
        if (state is WordGameFailedAttempt) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Palavra não encontrada!'),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is WordGameLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is WordGameFailure) {
          return Center(
            child: Text(state.message),
          );
        }
        if (state is WordGameSuccess) {
          final words = state.wordGameModel;
          return WordGameDisplayWidget(words: words);
        }
        if (state is WordGameFailedAttempt) {
          final words = state.wordGameModel;
          return WordGameDisplayWidget(words: words);
        }
        return const SizedBox();
      },
    );
  }
}

class WordGameDisplayWidget extends StatelessWidget {
  const WordGameDisplayWidget({
    super.key,
    required this.words,
  });

  final List<WordModel> words;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Iniciante',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  Text(
                    '${words.totalScore}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: words.progress,
                      backgroundColor: Colors.grey.shade300,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Palavras já encontradas',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height * 0.1,
          child: GridView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: .5,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: words.length, // Adjust according to your word count
            itemBuilder: (context, index) {
              return Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                alignment: Alignment.center,
                child: Builder(builder: (context) {
                  if (words[index].isFound) {
                    return Text(
                      words[index].word,
                      style: const TextStyle(
                        color: Colors.teal,
                        fontSize: 16,
                      ),
                    );
                  }
                  return Text(
                    '${words[index].word.length} letras',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
                  );
                }),
              );
            },
          ),
        ),
      ],
    );
  }
}
