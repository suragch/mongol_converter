import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mongol/mongol.dart';
import 'package:mongol_converter_db_creator/ui/add_word_dialog.dart';

import 'home_manager.dart';

enum HomeState { initial, ready, loading, converted }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = TextEditingController();
  HomeState _appState = HomeState.initial;
  final manager = HomeManager();

  String _oldText = '';

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      final text = controller.text;
      if (text == _oldText) return;

      if (text.isEmpty) {
        _appState = HomeState.initial;
      } else {
        _appState = HomeState.ready;
      }
      setState(() {});
      _oldText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Кирилл  ➜  ᠮᠣᠩᠭᠣᠯ'),
        actions: [
          if (!manager.isLoggedIn)
            TextButton(
              onPressed: _showLoginDialog, //
              child: Text('Нэвтрэх'),
            ),
          if (manager.isLoggedIn)
            TextButton(
              onPressed: () {
                manager.logout();
                setState(() {});
              },
              child: Text('Гарах'),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: controller,
                      textAlignVertical: TextAlignVertical.top,
                      maxLines: null,
                      expands: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Кирилл',
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Flexible(child: _buildRightPanel()),
                ],
              ),
            ),
            SizedBox(height: 8),
            Text('Үл мэдэгдэх үгс:'),
            Expanded(
              child: ListView.builder(
                itemCount: manager.unknownWords.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.add),
                    title: Text(manager.unknownWords[index]),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AddWordDialog(
                              word: manager.unknownWords[index],
                              onWordAdded: () {
                                setState(() {});
                              },
                              manager: manager,
                            ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightPanel() {
    switch (_appState) {
      case HomeState.initial:
        return const SizedBox();
      case HomeState.ready:
        return Center(
          child: ElevatedButton(
            onPressed: () {
              manager.convert(controller.text);
              setState(() {
                _appState = HomeState.converted;
              });
            },
            child: const Text('Хөрвүүлэх'),
          ),
        );
      case HomeState.loading:
        return CircularProgressIndicator();
      case HomeState.converted:
        return Stack(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: MongolText(manager.convertedText),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: Icon(Icons.copy),
                onPressed: () {
                  final text = manager.convertedText;
                  Clipboard.setData(ClipboardData(text: text));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Copied to clipboard'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ),
          ],
        );
    }
  }

  void _showLoginDialog() {
    final username = manager.storedUserEmail;
    showDialog(
      context: context,
      builder: (context) {
        final usernameController = TextEditingController(text: username);
        final passwordController = TextEditingController();
        return AlertDialog(
          title: Text('Login'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await manager.login(
                  usernameController.text,
                  passwordController.text,
                );
                setState(() {});
              },
              child: Text('Login'),
            ),
          ],
        );
      },
    );
  }
}
