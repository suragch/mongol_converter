import 'package:flutter/material.dart';
import 'package:mongol/mongol.dart';
import 'package:mongol_converter_db_creator/infrastructure/converter.dart';
import 'package:mongol_converter_db_creator/infrastructure/service_locator.dart';
import 'package:mongol_converter_db_creator/infrastructure/word_repo.dart';

class AddEditWordDialog extends StatefulWidget {
  const AddEditWordDialog({
    super.key,
    this.cyrillic,
    this.latin,
    required this.onAddEditWord,
  });

  final String? cyrillic;
  final String? latin;
  final void Function(Word) onAddEditWord;

  @override
  State<AddEditWordDialog> createState() => _AddEditWordDialogState();
}

class _AddEditWordDialogState extends State<AddEditWordDialog> {
  late final TextEditingController cyrillicController;
  late final TextEditingController latinController;
  String mongolText = '';
  final converter = getIt<Converter>();

  @override
  void initState() {
    super.initState();
    if (widget.cyrillic == null) {
      cyrillicController = TextEditingController();
    }
    latinController = TextEditingController(text: widget.latin);
    latinController.addListener(_updateMongolText);
    // wordController.text = widget.latin ?? '';
    print('initState: ${widget.latin}');
  }

  void _updateMongolText() {
    mongolText = converter.latinToMenksoft(latinController.text);
    setState(() {});
  }

  @override
  void dispose() {
    latinController.removeListener(_updateMongolText);
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
                    widget.cyrillic == null
                        ? TextField(
                          autofocus: true,
                          controller: cyrillicController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Кирилл',
                          ),
                        )
                        : Text(
                          widget.cyrillic!,
                          style: TextStyle(fontSize: 30),
                        ),
                    SizedBox(height: 8),
                    TextField(
                      autofocus: true,
                      controller: latinController,
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
                                cyrillic:
                                    widget.cyrillic ?? cyrillicController.text,
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
