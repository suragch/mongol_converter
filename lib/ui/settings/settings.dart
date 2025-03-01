import 'package:flutter/material.dart';
import 'package:mongol_converter/infrastructure/service_locator.dart';
import 'package:mongol_converter/infrastructure/user_settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final versionNotifier = ValueNotifier<String>('');
  Encoding selectedOption = Encoding.unicode;
  final userSettings = getIt<UserSettings>();

  @override
  void initState() {
    super.initState();
    selectedOption = userSettings.encoding;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Тохиргоо')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                'Монгол бичигийн кодчилол:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              RadioListTile(
                title: const Text('Unicode'),
                value: Encoding.unicode,
                groupValue: selectedOption,
                onChanged: (value) {
                  setState(() {
                    selectedOption = value as Encoding;
                    userSettings.saveEncoding(value);
                  });
                },
              ),
              RadioListTile(
                title: const Text('Menksoft code'),
                value: Encoding.menksoft,
                groupValue: selectedOption,
                onChanged: (value) {
                  setState(() {
                    selectedOption = value as Encoding;
                    userSettings.saveEncoding(value);
                  });
                },
              ),
              // RadioListTile(
              //   title: const Text('CMS'),
              //   value: Encoding.cms,
              //   groupValue: selectedOption,
              //   onChanged: (value) {
              //     setState(() {
              //       selectedOption = value as Encoding;
              //       userSettings.saveEncoding(value);
              //     });
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
