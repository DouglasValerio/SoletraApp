import 'dart:convert';

import 'package:soletra_app/models/word_model.dart';

class WordGameModel {
  final String centralLetter;
  final List<String> outerLetters;
  final List<WordModel> words;

  WordGameModel(
      {required this.centralLetter,
      required this.outerLetters,
      required this.words});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'centralLetter': centralLetter,
      'outerLetters': outerLetters,
      'words': words.map((x) => x.toMap()).toList(),
    };
  }

  factory WordGameModel.fromMap(Map<String, dynamic> map) {
    return WordGameModel(
      centralLetter: map['centralLetter'] as String,
      outerLetters: List<String>.from((map['outerLetters'] as List<String>)),
      words: List<WordModel>.from(
        (map['words'] as List<int>).map<WordModel>(
          (x) => WordModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory WordGameModel.fromJson(String source) =>
      WordGameModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
