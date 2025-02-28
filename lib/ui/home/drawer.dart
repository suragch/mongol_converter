import 'package:flutter/material.dart';
import 'package:mongol_converter_db_creator/ui/about/about.dart';
import 'package:mongol_converter_db_creator/ui/browser/browser.dart';
import 'package:mongol_converter_db_creator/ui/settings/settings.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mongol Converter',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Бүх үгс'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WordBrowserPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings_outlined),
            title: Text('Тохиргоо'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Хэрэглээний тухай'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
