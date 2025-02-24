class Converter {
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
    if (word == 'монгол') {
      return 'ᠮᠣᠩᠭᠣᠯ';
    } else {
      return null;
    }
  }
}
