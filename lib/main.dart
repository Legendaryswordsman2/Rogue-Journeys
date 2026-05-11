import 'package:flutter/material.dart';
import 'package:rogue_journeys/data_objects/progression_tree_template_info.dart';
import 'package:rogue_journeys/pages/class_schedule_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  ProgressionTreeTemplateManager.insance.loadProgressionTree();

  runApp(const Start());
}

final ValueNotifier<bool> useMobileFrame = ValueNotifier<bool>(false);

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
      builder: (context, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: useMobileFrame,
          builder: (context, enabled, _) {
            Widget content = child!;

            if (enabled) {
              content = Expanded(
                child: Container(
                  color: const Color.fromARGB(255, 22, 22, 22),
                  child: Center(
                    child: ClipRect(child: SizedBox(width: 420, child: content)),
                  ),
                ),
              );
            }

            return content;
          },
        );
      },
    );
  }
}
