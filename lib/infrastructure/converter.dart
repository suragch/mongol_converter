import 'package:mongol_code/mongol_code.dart';
import 'package:mongol_converter_db_creator/infrastructure/service_locator.dart';
import 'package:mongol_converter_db_creator/infrastructure/word_repo.dart';

class Converter {
  final mongolCode = MongolCode.instance;
  final wordRepo = getIt<WordRepo>();

  (String converted, List<String> unknownWords) convert(String text) {
    final converted = StringBuffer();
    final unknownWords = <String>{};
    final currentWord = StringBuffer();

    for (var i = 0; i < text.length; i++) {
      final char = text[i];

      if (char == ' ') {
        _processWord(currentWord.toString(), converted, unknownWords);
        currentWord.clear();
        converted.write(' ');
      } else if (char.contains(RegExp(r'[.,!?;:]'))) {
        _processWord(currentWord.toString(), converted, unknownWords);
        currentWord.clear();
        _processWord(char, converted, unknownWords);
        converted.write(' ');
      } else {
        currentWord.write(char);
      }
    }

    if (currentWord.isNotEmpty) {
      _processWord(currentWord.toString(), converted, unknownWords);
    }

    return (converted.toString().trimRight(), unknownWords.toList());
  }

  void _processWord(
    String word,
    StringBuffer converted,
    Set<String> unknownWords,
  ) {
    if (word.isEmpty) return;
    final convertedWord = _convertWord(word.toLowerCase());
    if (convertedWord == null) {
      unknownWords.add(word.toLowerCase());
      converted.write(word);
    } else {
      converted.write(convertedWord);
    }
  }

  String? _convertWord(String word) {
    return wordRepo.menksoftForCyrillic(word);
    // if (word == 'монгол') {
    //   return 'ᠮᠣᠩᠭᠣᠯ';
    // } else {
    //   return null;
    // }
  }

  String convertLatinToMenksoftCode(String latinText) {
    final unicode = _convertLatinToMongolianUnicode(latinText);
    return mongolCode.unicodeToMenksoft(unicode);
  }

  String _convertLatinToMongolianUnicode(String latinText) {
    final converted = StringBuffer();
    for (var i = 0; i < latinText.length; i++) {
      final char = latinText[i];
      if (char == 'q') {
        converted.write(String.fromCharCode(Unicode.O));
      } else if (char == 'w') {
        converted.write(String.fromCharCode(Unicode.WA));
      } else if (char == 'e') {
        converted.write(String.fromCharCode(Unicode.E));
      } else if (char == 'r') {
        converted.write(String.fromCharCode(Unicode.RA));
      } else if (char == 't') {
        converted.write(String.fromCharCode(Unicode.TA));
      } else if (char == 'y') {
        converted.write(String.fromCharCode(Unicode.YA));
      } else if (char == 'u') {
        converted.write(String.fromCharCode(Unicode.UE));
      } else if (char == 'i') {
        converted.write(String.fromCharCode(Unicode.I));
      } else if (char == 'o') {
        converted.write(String.fromCharCode(Unicode.OE));
      } else if (char == 'p') {
        converted.write(String.fromCharCode(Unicode.PA));
      } else if (char == 'a') {
        converted.write(String.fromCharCode(Unicode.A));
      } else if (char == 's') {
        converted.write(String.fromCharCode(Unicode.SA));
      } else if (char == 'd') {
        converted.write(String.fromCharCode(Unicode.DA));
      } else if (char == 'f') {
        converted.write(String.fromCharCode(Unicode.FA));
      } else if (char == 'g') {
        converted.write(String.fromCharCode(Unicode.GA));
      } else if (char == 'h') {
        converted.write(String.fromCharCode(Unicode.QA));
      } else if (char == 'j') {
        converted.write(String.fromCharCode(Unicode.JA));
      } else if (char == 'k') {
        converted.write(String.fromCharCode(Unicode.KA));
      } else if (char == 'l') {
        converted.write(String.fromCharCode(Unicode.LA));
      } else if (char == 'z') {
        converted.write(String.fromCharCode(Unicode.ZA));
      } else if (char == 'x') {
        converted.write(String.fromCharCode(Unicode.SHA));
      } else if (char == 'c') {
        converted.write(String.fromCharCode(Unicode.CHA));
      } else if (char == 'v') {
        converted.write(String.fromCharCode(Unicode.U));
      } else if (char == 'b') {
        converted.write(String.fromCharCode(Unicode.BA));
      } else if (char == 'n') {
        converted.write(String.fromCharCode(Unicode.NA));
      } else if (char == 'm') {
        converted.write(String.fromCharCode(Unicode.MA));
      }
      // Uppercase letters
      else if (char == 'Q') {
        converted.write(String.fromCharCode(Unicode.CHI));
      } else if (char == 'E') {
        converted.write(String.fromCharCode(Unicode.EE));
      } else if (char == 'R') {
        converted.write(String.fromCharCode(Unicode.ZRA));
      } else if (char == 'H') {
        converted.write(String.fromCharCode(Unicode.HAA));
      } else if (char == 'K') {
        converted.write(String.fromCharCode(Unicode.KHA));
      } else if (char == 'L') {
        converted.write(String.fromCharCode(Unicode.LHA));
      } else if (char == 'Z') {
        converted.write(String.fromCharCode(Unicode.ZHI));
      } else if (char == 'C') {
        converted.write(String.fromCharCode(Unicode.TSA));
      } else if (char == 'N') {
        converted.write(String.fromCharCode(Unicode.ANG));
      }
      // Control characters
      else if (char == '\'') {
        converted.write(String.fromCharCode(Unicode.FVS1));
      } else if (char == '"') {
        converted.write(String.fromCharCode(Unicode.FVS2));
      } else if (char == '`') {
        converted.write(String.fromCharCode(Unicode.FVS3));
      } else if (char == '-') {
        converted.write(String.fromCharCode(Unicode.MVS));
      } else if (char == '_') {
        converted.write(String.fromCharCode(Unicode.NNBS));
      }
      // direct copy
      else {
        converted.write(char);
      }
    }
    return converted.toString();
  }
}
