import 'package:flutter/material.dart';
import 'package:rogue_journeys/data_objects/progression_tree_template_info.dart';
import 'package:rogue_journeys/pages/class_schedule_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  ProgressionTreeTemplateManager.insance.loadProgressionTree();

  runApp(const Start());
}

class Start extends StatelessWidget {
  const Start({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rogue Journeys',
      theme: ThemeData(
        appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
      ),
      // theme: ThemeData.dark().copyWith(
      //   appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
      //   scaffoldBackgroundColor: Color(0xFF202020)
      // ),
      home: HomePage(),
    );
  }
}
