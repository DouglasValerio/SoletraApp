import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soletra_app/bloc/letters/letters_bloc.dart';

import 'package:soletra_app/bloc/word_game/word_game_bloc.dart';
import 'package:soletra_app/views/widgets/found_words_widget.dart';
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
          actions: [
            PopupMenuButton(
              itemBuilder: (_) => [
                const PopupMenuItem(value: 1, child: Text('Recomeçar')),
              ],
              onSelected: (value) =>
                  context.read<WordGameBloc>().add(WordGameStarted()),
            )
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
      ),
    );
  }
}
