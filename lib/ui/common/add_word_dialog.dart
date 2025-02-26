import 'package:flutter/material.dart';
import 'package:mongol/mongol.dart';
import 'package:mongol_converter_db_creator/infrastructure/converter.dart';
import 'package:mongol_converter_db_creator/infrastructure/service_locator.dart';
import 'package:mongol_converter_db_creator/infrastructure/word_repo.dart';

class AddWordDialog extends StatefulWidget {
  const AddWordDialog({
    super.key,
    required this.onAddWord,
    required this.cyrillic,
    this.mongol,
  });

  final void Function(Word) onAddWord;
  final String cyrillic;
  final String? mongol;

  @override
  State<AddWordDialog> createState() => _AddWordDialogState();
}

class _AddWordDialogState extends State<AddWordDialog> {
  final wordController = TextEditingController();
  late String mongolText = widget.mongol ?? '';
  final converter = getIt<Converter>();

  @override
  void initState() {
    super.initState();
    wordController.addListener(_updateMongolText);
    // if (widget.mongol != null) {
    //   mongolText = widget.mongol!;
    //   setState(() {});
    // }
    print('mongol $mongolText');
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
                            widget.onAddWord(
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
