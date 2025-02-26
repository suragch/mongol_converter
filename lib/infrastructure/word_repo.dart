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
