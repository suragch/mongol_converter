import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final versionNotifier = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    versionNotifier.value = packageInfo.version;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Center(
                child: SelectableText(
                  'Mongol Converter',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              Center(
                child: ValueListenableBuilder<String>(
                  valueListenable: versionNotifier,
                  builder: (context, version, child) {
                    return Text(version);
                  },
                ),
              ),
              const SizedBox(height: 32),
              SelectableText(
                'Description',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SelectableText(
                'This application converts Cyrillic Mongolian to traditional Mongolian script. Currently, '
                'we are building the open-source database needed to support this tool. While the '
                'database is being build, you may find a large number of words that cannot be '
                'converted. ',
                // 'If you are an expert in both Cyrillic and traditional Mongolian and '
                // 'would like to help, contact us at studymongolian@gmail.com.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              SelectableText(
                'Our plan is to release the dataset to the public domain when it is ready. '
                'This project is a gift to the Mongolian people and those from around the world '
                'who are interested in the Mongolian language. ',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              SelectableText(
                'Privacy',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SelectableText(
                'The Cyrillic to Mongolian conversion is performed directly in your browser. '
                'No documents are uploaded to or stored on the server. Your IP address is '
                'recorded, but as long as you are not logged in, no personally identifiable information '
                'is stored. If you are logged in as an editor, we record the individual words you add or update '
                'along with your username and email.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
