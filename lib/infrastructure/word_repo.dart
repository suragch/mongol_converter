import 'dart:developer';

import 'package:mongol_converter_db_creator/infrastructure/service_locator.dart';
import 'package:pocketbase/pocketbase.dart';

class WordRepo {
  final pb = getIt<PocketBase>();
  final words = <String, String>{};

  Future<void> fetchWords() async {
    final records = await pb
        .collection('words')
        .getFullList(fields: 'cyrillic,mongol', sort: 'cyrillic');
    for (final record in records) {
      words[record.data['cyrillic']] = record.data['mongol'];
    }
  }

  Future<bool> addWord(String cyrillic, String mongol) async {
    final body = <String, dynamic>{
      "user": pb.authStore.record!.id,
      "cyrillic": cyrillic,
      "mongol": mongol,
    };
    try {
      await pb.collection('words').create(body: body);
      words[cyrillic] = mongol;
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  String? menksoftForCyrillic(String cyrillic) {
    return words[cyrillic];
  }

  Future<bool> updateWord(Word word) async {
    print('updateWord: ${word.cyrillic}, ${word.mongol}');
    try {
      final record = await pb
          .collection('words')
          .getFirstListItem('cyrillic="${word.cyrillic}"');
      // .update(record.id, body: {'cyrillic': word.cyrillic, 'mongol': word.mongol});
      print('record: $record');

      final body = <String, dynamic>{
        "user": pb.authStore.record!.id,
        "cyrillic": word.cyrillic,
        "mongol": word.mongol,
      };

      await pb.collection('words').update(record.id, body: body);

      // await pb
      //     .collection('words')
      //     .update(
      //       record.id,
      //       body: {'cyrillic': word.cyrillic, 'mongol': word.mongol},
      //     );
      words[word.cyrillic] = word.mongol;
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> deleteWord(String cyrillic) async {
    try {
      final record = await pb
          .collection('words')
          .getFirstListItem('cyrillic="$cyrillic"');
      await pb.collection('words').delete(record.id);
      words.remove(cyrillic);
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
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
