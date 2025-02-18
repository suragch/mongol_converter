class Converter {
  (String converted, List<String> unknownWords) convert(String text) {
    final words = text.split(' ');
    final converted = StringBuffer();
    final unknownWords = <String>[];
    for (var word in words) {
      final convertedWord = _convertWord(word);
      if (convertedWord == null) {
        unknownWords.add(word);
        converted.write(word);
      } else {
        converted.write(convertedWord);
      }
      converted.write(' ');
    }
    return (converted.toString(), unknownWords);
  }

  String? _convertWord(String word) {
    if (word == 'Монгол') {
      return 'ᠮᠣᠩᠭᠣᠯ';
    } else {
      return null;
    }
  }
}
