import 'package:flutter/material.dart';
import 'package:mongol_converter/ui/browser/browser_manager.dart';
import 'package:mongol_converter/ui/common/add_word_dialog.dart';

class WordBrowserPage extends StatefulWidget {
  const WordBrowserPage({super.key});

  @override
  State<WordBrowserPage> createState() => _WordBrowserPageState();
}

class _WordBrowserPageState extends State<WordBrowserPage> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final manager = BrowserManager();

  @override
  void initState() {
    super.initState();
    manager.init();
  }

  void _filterWords(String query) {
    manager.filterWords(query);
  }

  void _editWord(String cyrillic, String latin) async {
    showDialog(
      context: context,
      builder:
          (context) => AddEditWordDialog(
            cyrillic: cyrillic,
            latin: latin,
            onAddEditWord: manager.updateWord,
          ),
    );
  }

  void _deleteWord(String cyrillic) async {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(cyrillic),
            content: Text('Та энэ үгийг устгахдаа итгэлтэй байна уу?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Цуцлах'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  manager.deleteWord(cyrillic);
                },
                child: const Text('Устгах'),
              ),
            ],
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
                    hintText: 'Хайх',
                    border: InputBorder.none,
                  ),
                  onChanged: _filterWords,
                  autofocus: true,
                )
                : const Text('Бүх үгс'),
        actions: [
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.download),
              tooltip: 'CSV файлд хадгалах',
              onPressed: () async {
                await manager.saveToCSV();
              },
            ),
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
          showDialog(
            context: context,
            builder:
                (context) => AddEditWordDialog(onAddEditWord: manager.addWord),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildWordList() {
    return ValueListenableBuilder<List<String>>(
      valueListenable: manager.listNotifier,
      builder: (context, wordList, child) {
        if (wordList.isEmpty) {
          return const Center(child: Text('Үг олдсонгүй'));
        }
        return ListView.builder(
          itemCount: wordList.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Center(
                child: Text(
                  '${wordList.length} үг',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }
            final cyrillic = manager.wordAtIndex(index - 1);
            final mongol = manager.getMongol(cyrillic);
            final latin = manager.getLatin(mongol);
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
                if (manager.isLoggedIn)
                  IconButton(
                    tooltip: 'Засварлах',
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editWord(cyrillic, latin),
                  ),
                if (manager.isLoggedIn)
                  IconButton(
                    tooltip: 'Устгах',
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteWord(cyrillic),
                  ),
                SizedBox(width: 16),
              ],
            );
          },
        );
      },
    );
  }
}
