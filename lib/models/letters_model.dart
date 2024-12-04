class LettersModel {
  final String centralLetter;
  final List<String> outerLetters;

  const LettersModel({required this.centralLetter, required this.outerLetters});

  factory LettersModel.fromMap(Map<String, dynamic> map) {
    return LettersModel(
      centralLetter: map['centralLetter'] as String,
      outerLetters: List<String>.from(map['outerLetters'] as List<dynamic>),
    );
  }
 LettersModel shuffleLetters() {
final _copy = [...outerLetters];
_copy.shuffle();
    return LettersModel(
      centralLetter: centralLetter,
      outerLetters: _copy,
    );
  }
  
}