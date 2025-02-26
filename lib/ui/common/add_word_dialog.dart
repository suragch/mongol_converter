import 'package:flutter/material.dart';
import 'package:mongol/mongol.dart';
import 'package:mongol_converter_db_creator/infrastructure/converter.dart';
import 'package:mongol_converter_db_creator/infrastructure/service_locator.dart';
import 'package:mongol_converter_db_creator/infrastructure/word_repo.dart';

class AddEditWordDialog extends StatefulWidget {
  const AddEditWordDialog({
    super.key,
    required this.onAddEditWord,
    required this.cyrillic,
    this.latin,
  });

  final void Function(Word) onAddEditWord;
  final String cyrillic;
  final String? latin;

  @override
  State<AddEditWordDialog> createState() => _AddEditWordDialogState();
}

class _AddEditWordDialogState extends State<AddEditWordDialog> {
  late final TextEditingController wordController;
  String mongolText = '';
  final converter = getIt<Converter>();

  @override
  void initState() {
    super.initState();
    wordController = TextEditingController(text: widget.latin);
    wordController.addListener(_updateMongolText);
    // wordController.text = widget.latin ?? '';
    print('initState: ${widget.latin}');
  }

  void _updateMongolText() {
    mongolText = converter.latinToMenksoft(wordController.text);
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
                    Text(widget.cyrillic, style: TextStyle(fontSize: 30)),
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
                          child: Text('Цуцлах'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            widget.onAddEditWord(
                              Word(
                                cyrillic: widget.cyrillic,
                                mongol: mongolText,
                              ),
                            );
                          },
                          child: Text('Нэмэх'),
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
