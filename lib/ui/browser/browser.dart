// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mongol_converter_db_creator/infrastructure/converter.dart';
import 'package:mongol_converter_db_creator/infrastructure/service_locator.dart';
import 'package:mongol_converter_db_creator/infrastructure/word_repo.dart';

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
  final converter = Converter();

  @override
  void initState() {
    super.initState();
    _keys = wordRepo.words.keys.toList();
    print('_keys: $_keys');
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

  void _editWord(String cyrillic) async {
    // Navigate to edit page and refresh list when returning
    // final result = await Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => WordEditPage(word: word)),
    // );

    // if (result == true) {
    //   _loadWords();
    // }
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
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WordEditPage()),
          );

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
      itemCount: _keys.length,
      itemBuilder: (context, index) {
        final cyrillic = _keys[index];
        final mongol = wordRepo.words[cyrillic] ?? '';
        final latin = converter.menksoftToLatin(mongol);
        return ListTile(
          title: Text(
            cyrillic,
            style: const TextStyle(
              // fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          subtitle: Text(
            '$mongol    $latin',
            style: TextStyle(fontSize: 20, fontFamily: 'MenksoftQagaan'),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editWord(cyrillic),
          ),
        );
      },
    );
  }
}

class WordEditPage extends StatefulWidget {
  final Map<String, dynamic>? word;

  const WordEditPage({super.key, this.word});

  @override
  State<WordEditPage> createState() => _WordEditPageState();
}

class _WordEditPageState extends State<WordEditPage> {
  final TextEditingController _cyrillicController = TextEditingController();
  final TextEditingController _mongolController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.word != null) {
      _cyrillicController.text = widget.word!['cyrillic'] ?? '';
      _mongolController.text = widget.word!['mongol'] ?? '';
    }
  }

  Future<void> _saveWord() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // final database = await openDatabase(
    //   join(await getDatabasesPath(), 'mongol_converter.db'),
    // );

    if (widget.word == null) {
      // Insert new word
      // await database.insert('words', {
      //   'cyrillic': _cyrillicController.text,
      //   'mongol': _mongolController.text,
      // }, conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      // Update existing word
      // await database.update(
      //   'words',
      //   {
      //     'cyrillic': _cyrillicController.text,
      //     'mongol': _mongolController.text,
      //   },
      //   where: 'id = ?',
      //   whereArgs: [widget.word!['id']],
      // );
    }

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.word == null ? 'Add Word' : 'Edit Word'),
        actions: [
          if (widget.word != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                // Show confirmation dialog before deleting
                final confirm = await showDialog<bool>(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Confirm Delete'),
                        content: const Text(
                          'Are you sure you want to delete this word?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                );

                if (confirm == true) {
                  // final database = await openDatabase(
                  //   join(await getDatabasesPath(), 'mongol_converter.db'),
                  // );

                  // await database.delete(
                  //   'words',
                  //   where: 'id = ?',
                  //   whereArgs: [widget.word!['id']],
                  // );

                  if (mounted) {
                    Navigator.pop(context, true);
                  }
                }
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _cyrillicController,
                decoration: const InputDecoration(
                  labelText: 'Cyrillic',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the Cyrillic text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _mongolController,
                decoration: const InputDecoration(
                  labelText: 'Mongol',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the Mongol text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveWord,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  widget.word == null ? 'Add Word' : 'Save Changes',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
