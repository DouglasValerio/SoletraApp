
import 'package:soletra_app/repositories/word_game_repository.dart';

import '../models/models.dart';

class WordGameRepositoryImpl implements WordGameRepository {
  @override
  Future<WordGameModel> getWordGame() {
    final words = _words.map((e) => WordModel.fromMap(e)).toList();
    final wordGame = WordGameModel(
      centralLetter: 'c',//cadnotu
      outerLetters: ['a', 'd', 'n', 'o', 't', 'u'],
      words: words,
    );
    return Future.value(wordGame);
  }
}

final _words = [
            {
                "word": "anca",
                "score": 1,
                "pangram": false,
                "label": []
            },
            {
                "word": "caco",
                "score": 1,
                "pangram": false,
                "label": []
            },
            {
                "word": "cana",
                "score": 1,
                "pangram": false,
                "label": []
            },
            {
                "word": "cano",
                "score": 1,
                "pangram": false,
                "label": []
            },
            {
                "word": "coca",
                "score": 1,
                "pangram": false,
                "label": []
            },
            {
                "word": "coco",
                "score": 1,
                "pangram": false,
                "label": [
                    "cocô"
                ]
            },
            {
                "word": "cota",
                "score": 1,
                "pangram": false,
                "label": []
            },
            {
                "word": "coto",
                "score": 1,
                "pangram": false,
                "label": []
            },
            {
                "word": "cuca",
                "score": 1,
                "pangram": false,
                "label": []
            },
            {
                "word": "cuco",
                "score": 1,
                "pangram": false,
                "label": []
            },
            {
                "word": "doca",
                "score": 1,
                "pangram": false,
                "label": []
            },
            {
                "word": "nuca",
                "score": 1,
                "pangram": false,
                "label": []
            },
            {
                "word": "taco",
                "score": 1,
                "pangram": false,
                "label": []
            },
            {
                "word": "toca",
                "score": 1,
                "pangram": false,
                "label": []
            },
            {
                "word": "toco",
                "score": 1,
                "pangram": false,
                "label": []
            },
            {
                "word": "cacau",
                "score": 5,
                "pangram": false,
                "label": []
            },
            {
                "word": "cacto",
                "score": 5,
                "pangram": false,
                "label": []
            },
            {
                "word": "canoa",
                "score": 5,
                "pangram": false,
                "label": []
            },
            {
                "word": "canon",
                "score": 5,
                "pangram": false,
                "label": [
                    "cânon"
                ]
            },
            {
                "word": "canto",
                "score": 5,
                "pangram": false,
                "label": []
            },
            {
                "word": "cauda",
                "score": 5,
                "pangram": false,
                "label": []
            },
            {
                "word": "coada",
                "score": 5,
                "pangram": false,
                "label": []
            },
            {
                "word": "coado",
                "score": 5,
                "pangram": false,
                "label": []
            },
            {
                "word": "conta",
                "score": 5,
                "pangram": false,
                "label": []
            },
            {
                "word": "conto",
                "score": 5,
                "pangram": false,
                "label": []
            },
            {
                "word": "couto",
                "score": 5,
                "pangram": false,
                "label": []
            },
            {
                "word": "nunca",
                "score": 5,
                "pangram": false,
                "label": []
            },
            {
                "word": "touca",
                "score": 5,
                "pangram": false,
                "label": []
            },
            {
                "word": "caduca",
                "score": 6,
                "pangram": false,
                "label": []
            },
            {
                "word": "caduco",
                "score": 6,
                "pangram": false,
                "label": []
            },
            {
                "word": "canudo",
                "score": 6,
                "pangram": false,
                "label": []
            },
            {
                "word": "catada",
                "score": 6,
                "pangram": false,
                "label": []
            },
            {
                "word": "catado",
                "score": 6,
                "pangram": false,
                "label": []
            },
            {
                "word": "cocada",
                "score": 6,
                "pangram": false,
                "label": []
            },
            {
                "word": "condao",
                "score": 6,
                "pangram": false,
                "label": [
                    "condão"
                ]
            },
            {
                "word": "cotada",
                "score": 6,
                "pangram": false,
                "label": []
            },
            {
                "word": "cotado",
                "score": 6,
                "pangram": false,
                "label": []
            },
            {
                "word": "cotoco",
                "score": 6,
                "pangram": false,
                "label": []
            },
            {
                "word": "tacaca",
                "score": 6,
                "pangram": false,
                "label": [
                    "tacacá"
                ]
            },
            {
                "word": "tacada",
                "score": 6,
                "pangram": false,
                "label": []
            },
            {
                "word": "tocada",
                "score": 6,
                "pangram": false,
                "label": []
            },
            {
                "word": "tocado",
                "score": 6,
                "pangram": false,
                "label": []
            },
            {
                "word": "tucano",
                "score": 6,
                "pangram": false,
                "label": []
            },
            {
                "word": "acatada",
                "score": 7,
                "pangram": false,
                "label": []
            },
            {
                "word": "acatado",
                "score": 7,
                "pangram": false,
                "label": []
            },
            {
                "word": "acocado",
                "score": 7,
                "pangram": false,
                "label": []
            },
            {
                "word": "atacada",
                "score": 7,
                "pangram": false,
                "label": []
            },
            {
                "word": "atacado",
                "score": 7,
                "pangram": false,
                "label": []
            },
            {
                "word": "cacatua",
                "score": 7,
                "pangram": false,
                "label": []
            },
            {
                "word": "cantada",
                "score": 7,
                "pangram": false,
                "label": []
            },
            {
                "word": "cantado",
                "score": 7,
                "pangram": false,
                "label": []
            },
            {
                "word": "cantata",
                "score": 7,
                "pangram": false,
                "label": []
            },
            {
                "word": "condado",
                "score": 7,
                "pangram": false,
                "label": []
            },
            {
                "word": "conduta",
                "score": 14,
                "pangram": true,
                "label": []
            },
            {
                "word": "conduto",
                "score": 7,
                "pangram": false,
                "label": []
            },
            {
                "word": "contada",
                "score": 7,
                "pangram": false,
                "label": []
            },
            {
                "word": "contado",
                "score": 7,
                "pangram": false,
                "label": []
            },
            {
                "word": "contato",
                "score": 7,
                "pangram": false,
                "label": []
            },
            {
                "word": "contudo",
                "score": 7,
                "pangram": false,
                "label": []
            },
            {
                "word": "cutucao",
                "score": 7,
                "pangram": false,
                "label": [
                    "cutucão"
                ]
            },
            {
                "word": "dondoca",
                "score": 7,
                "pangram": false,
                "label": []
            },
            {
                "word": "toucada",
                "score": 7,
                "pangram": false,
                "label": []
            },
            {
                "word": "toucado",
                "score": 7,
                "pangram": false,
                "label": []
            },
            {
                "word": "anaconda",
                "score": 8,
                "pangram": false,
                "label": []
            },
            {
                "word": "caducada",
                "score": 8,
                "pangram": false,
                "label": []
            },
            {
                "word": "caducado",
                "score": 8,
                "pangram": false,
                "label": []
            },
            {
                "word": "conotado",
                "score": 8,
                "pangram": false,
                "label": []
            },
            {
                "word": "cutucada",
                "score": 8,
                "pangram": false,
                "label": []
            },
            {
                "word": "acantonada",
                "score": 10,
                "pangram": false,
                "label": []
            },
            {
                "word": "acantonado",
                "score": 10,
                "pangram": false,
                "label": []
            },
            {
                "word": "contactada",
                "score": 10,
                "pangram": false,
                "label": []
            },
            {
                "word": "contactado",
                "score": 10,
                "pangram": false,
                "label": []
            }
        ];