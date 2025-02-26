// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mongol_converter_db_creator/infrastructure/converter.dart';
import 'package:mongol_converter_db_creator/infrastructure/service_locator.dart';
import 'package:mongol_converter_db_creator/infrastructure/word_repo.dart';
import 'package:mongol_converter_db_creator/ui/common/add_word_dialog.dart';

class WordBrowserPage extends StatefulWidget {
  const WordBrowserPage({super.key});

  @override
  State<WordBrowserPage> createState() => _WordBrowserPageState();
}

class _WordBrowserPageState extends State<WordBrowserPage> {
  late final List<String> _keys;
  // Map<String, String> _filteredWords = {};
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final wordRepo = getIt<WordRepo>();
  final converter = getIt<Converter>();

  @override
  void initState() {
    super.initState();
    _keys = wordRepo.words.keys.toList();
  }

  void _filterWords(String query) {
    // setState(() {
    //   if (query.isEmpty) {
    //     _filteredWords = _words;
    //   } else {
    //     _filteredWords =
    //         _words
    //             .where(
    //               (word) => word['cyrillic'].toString().startsWith(
    //                 query.toLowerCase(),
    //               ),
    //             )
    //             .toList();
    //   }
    // });
  }

  void _editWord(String cyrillic, String mongol, String latin) async {
    print('edit $cyrillic');
    showDialog(
      context: context,
      builder:
          (context) => AddWordDialog(
            cyrillic: cyrillic,
            mongol: mongol,
            onAddWord: (word) {
              // TODO
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            _isSearching
                ? TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search words...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.white54),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: _filterWords,
                  autofocus: true,
                )
                : const Text('Word Browser'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchController.clear();
                  _filterWords('');
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
        ],
      ),
      body: _buildWordList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to add word page and refresh list when returning
          // final result = await Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const WordEditPage()),
          // );

          // if (result == true) {
          //   _loadWords();
          // }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildWordList() {
    if (wordRepo.words.isEmpty) {
      return const Center(child: Text('No words found'));
    }
    return ListView.builder(
      itemCount: _keys.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Center(
            child: Text(
              '${_keys.length} entries',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }
        final cyrillic = _keys[index - 1];
        final mongol = wordRepo.words[cyrillic] ?? '';
        final latin = converter.menksoftToLatin(mongol);
        return Row(
          children: [
            SizedBox(width: 16),
            Expanded(child: Text(cyrillic)),
            Expanded(
              child: Text(
                mongol,
                style: const TextStyle(
                  fontFamily: 'MenksoftQagaan',
                  fontSize: 20,
                ),
              ),
            ),
            Expanded(child: Text(latin)),
            IconButton(
              tooltip: 'Edit',
              icon: const Icon(Icons.edit),
              onPressed: () => _editWord(cyrillic, mongol, latin),
            ),
            IconButton(
              tooltip: 'Delete',
              icon: const Icon(Icons.delete),
              onPressed: () => _editWord(cyrillic, mongol, latin),
            ),
            SizedBox(width: 16),
          ],
        );
      },
    );
  }
}
