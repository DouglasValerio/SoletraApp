import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soletra_app/bloc/word_game/word_game_bloc.dart';
import 'package:soletra_app/views/widgets/word_game_display_widget.dart';
import 'package:toastification/toastification.dart';

class FoundWordsWidget extends StatelessWidget {
  const FoundWordsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WordGameBloc, WordGameState>(
      listener: (context, state) {
        if (state is WordGameSuccess) {
          showToast(context, "Palavra encontrada", ToastificationType.success);
        }
        if (state is WordGameFailedAttempt) {
          showToast(context, "Palavra não encontrada", ToastificationType.error);
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
  void showToast(BuildContext context,  String description,
      ToastificationType type) {
    toastification.show(
      context: context,
      type: type,
      // title: Text(title),
      description: Text(description),
      primaryColor: Colors.white,
      autoCloseDuration: const Duration(milliseconds: 1500),
      progressBarTheme: ProgressIndicatorThemeData(
        color: type == ToastificationType.success
            ? Colors.teal
            : type == ToastificationType.info
                ? Colors.blue
                : type == ToastificationType.warning
                    ? Colors.orange
                    : Colors.red,
      ),
      showProgressBar: true,
      backgroundColor: type == ToastificationType.success
          ? Colors.teal
          : type == ToastificationType.info
              ? Colors.blue
              : type == ToastificationType.warning
                  ? Colors.orange
                  : Colors.red,
      foregroundColor: Colors.white,
    );
  }
}
