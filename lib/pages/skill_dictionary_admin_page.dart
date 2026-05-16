import 'package:flutter/material.dart';
import 'package:rogue_journeys/main.dart';
import 'package:rogue_journeys/widgets/appbar_gradient_widget.dart';

class SkillDictionaryAdminPage extends StatelessWidget {
  const SkillDictionaryAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: Color(0xFF202020),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Skill Dictionary Admin",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),

          actions: [
            IconButton(
              icon: Icon(Icons.smartphone, color: Colors.white),
              color: Colors.white,
              onPressed: () {
                useMobileFrame.value = !useMobileFrame.value;
              },
            ),
          ],

          flexibleSpace: AppbarGradientContainer(),
        ),
        body: Center(
          child: Text("This page will be for inputting information about individual skills."),
        ),
      ),
    );
  }
}