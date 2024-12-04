part of 'letters_bloc.dart';

@immutable
sealed class LettersEvent {}

 class LettersStarted extends LettersEvent {}
 class LettersRefresh extends LettersEvent {}

