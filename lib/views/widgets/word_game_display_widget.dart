import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soletra_app/bloc/word_game/word_game_bloc.dart';
import 'package:soletra_app/models/models.dart';

class WordGameDisplayWidget extends StatelessWidget {
  WordGameDisplayWidget({
    super.key,
    required this.words,
  });

  final List<WordModel> words;

  final ScrollController _scrollController = ScrollController();

  final int _rows = 2;
  final double _cellWidth = 250.0;
  final double _cellHeight = 100.0;

  void _scrollToIndex(int index) {
    final int column = index ~/ _rows;
    final double offset = column * _cellHeight;
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                words.progressLabel,
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 16),
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
          child: BlocConsumer<WordGameBloc, WordGameState>(
            listener: (context, state) {
              if (state is WordGameSuccess) {
                _scrollToIndex(state.index);
              }
            },
            builder: (context, state) {
              final int? i = (state is WordGameSuccess) ? state.index : null;
              return GridView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: _cellHeight / _cellWidth,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: words.length, // Adjust according to your word count
                itemBuilder: (context, index) {
                  return Container(
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color:
                              index == i ? Colors.teal : Colors.grey.shade400),
                    ),
                    alignment: Alignment.center,
                    child: Builder(builder: (context) {
                      if (words[index].isFound) {
                        return Text(
                          words[index]
                              .word
                              .split(' ')
                              .map((word) => word.isNotEmpty
                                  ? '${word[0].toUpperCase()}${word.substring(1)}'
                                  : '')
                              .join(' '),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        );
                      }
                      return Text(
                        '${words[index].word.length} letras',
                        style: TextStyle(
                            color: Colors.grey.shade400, fontSize: 16),
                      );
                    }),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
