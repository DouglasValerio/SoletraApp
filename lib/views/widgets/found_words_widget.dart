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
        if (state is WordFindByPlayer) {
          showToast(context, state.message, ToastificationType.success);
        }
        if (state is WordAlreadyFound) {
          showToast(context, state.message, ToastificationType.warning);
        }
        if (state is WordFoundByPartner) {
          showToast(context, state.message, ToastificationType.info, duration: const Duration(milliseconds: 3000));
        }
        if (state is WordNotIncludedOnGame) {
          showToast(context, state.message, ToastificationType.error);
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
        return const SizedBox();
      },
    );
  }

  void showToast(
      BuildContext context, String description, ToastificationType type,
      {Duration duration = const Duration(milliseconds: 1500)}) {
    toastification.show(
      context: context,
      type: type,
      description: Text(description),
      primaryColor: Colors.white,
      autoCloseDuration: duration,
      progressBarTheme: ProgressIndicatorThemeData(
        color: type == ToastificationType.success
            ? Colors.teal
            : type == ToastificationType.info
                ? Colors.blue.shade800
                : type == ToastificationType.warning
                    ? Colors.orange
                    : Colors.red,
      ),
      showProgressBar: true,
      backgroundColor: type == ToastificationType.success
          ? Colors.teal
          : type == ToastificationType.info
              ? Colors.blue.shade800
              : type == ToastificationType.warning
                  ? Colors.orange
                  : Colors.red,
      foregroundColor: Colors.white,
    );
  }
}
