part of 'letters_bloc.dart';

@immutable
sealed class LettersState {}

final class LettersInitial extends LettersState {}
final class LettersLoading extends LettersState {}
final class LettersSuccess extends LettersState {
  final LettersModel lettersModel;

  LettersSuccess({required this.lettersModel});
}
