// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class WordModel {
  final String word;
  final int score;
  final bool pangram;
  final bool isFound;
  final List<String> label;

  WordModel(
      {required this.word,
      required this.score,
      required this.pangram,
      required this.label,
      this.isFound = false});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'word': word,
      'score': score,
      'pangram': pangram,
      'label': label,
    };
  }

  WordModel setAsFound() {
    return WordModel(
      word: word,
      score: score,
      pangram: pangram,
      label: label,
      isFound: true,
    );
  }

  factory WordModel.fromMap(Map<String, dynamic> map) {
    return WordModel(
      word: map['word'] as String,
      score: map['score'] as int,
      pangram: map['pangram'] as bool,
      label: (map['label'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory WordModel.fromJson(String source) =>
      WordModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension WordModelListExtension on List<WordModel> {
  int get totalScore {
    final list = where((e) => e.isFound);
    return list.isEmpty
        ? 0
        : list.map((e) => e.score).fold(0, (a, b) => a + b);
  }

  double get progress {
    if (isEmpty) return 0;
    return  totalScore / map((e) => e.score).fold(0, (a, b) => a + b);
  }
     
}
