import 'package:flutter/material.dart';
import 'package:mongol/mongol.dart';
import 'package:mongol_converter_db_creator/ui/home_manager.dart';

class AddWordDialog extends StatefulWidget {
  final String word;
  final VoidCallback onWordAdded;
  final HomeManager manager;

  const AddWordDialog({
    super.key,
    required this.word,
    required this.onWordAdded,
    required this.manager,
  });

  @override
  State<AddWordDialog> createState() => _AddWordDialogState();
}

class _AddWordDialogState extends State<AddWordDialog> {
  final wordController = TextEditingController();
  String mongolText = '';

  @override
  void initState() {
    super.initState();
    wordController.addListener(_updateMongolText);
  }

  void _updateMongolText() {
    mongolText = widget.manager.convertLatin(wordController.text);
    setState(() {});
  }

  @override
  void dispose() {
    wordController.removeListener(_updateMongolText);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 8, width: 48),
                  MongolText(
                    mongolText,
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'MenksoftQagaan',
                    ),
                  ),
                ],
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.word, style: TextStyle(fontSize: 30)),
                    SizedBox(height: 8),
                    TextField(
                      autofocus: true,
                      controller: wordController,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            //await manager.addWord(wordController.text);
                            widget.onWordAdded();
                          },
                          child: Text('Add'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
