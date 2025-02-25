import 'package:mongol_converter_db_creator/infrastructure/service_locator.dart';
import 'package:pocketbase/pocketbase.dart';

class WordRepo {
  // final pb = PocketBase('http://127.0.0.1:8090/');
  final pb = getIt<PocketBase>();
  // final _words = <Word>{};
  final _words = <String, String>{};

  Future<void> fetchWords() async {
    final records = await pb
        .collection('words')
        .getFullList(fields: 'cyrillic,mongol');
    for (final record in records) {
      _words[record.data['cyrillic']] = record.data['mongol'];
      // _words.add(
      //   Word(
      //     cyrillic: record.data['cyrillic'] as String,
      //     mongol: record.data['mongol'] as String,
      //   ),
      // );
    }
    print('Fetched ${records.length} words');
  }

  Future<bool> addWord(String cyrillic, String mongol) async {
    final body = <String, dynamic>{
      "user": pb.authStore.record!.id,
      "cyrillic": cyrillic,
      "mongol": mongol,
    };
    try {
      await pb.collection('words').create(body: body);
      _words[cyrillic] = mongol;
      return true;
    } catch (e) {
      print('$e');
      return false;
    }
  }

  String? menksoftForCyrillic(String cyrillic) {
    return _words[cyrillic];
  }
}

class Word {
  Word({required this.cyrillic, required this.mongol});
  final String cyrillic;
  final String mongol;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Word &&
        other.cyrillic == cyrillic &&
        other.mongol == mongol;
  }

  @override
  int get hashCode => cyrillic.hashCode ^ mongol.hashCode;
}
