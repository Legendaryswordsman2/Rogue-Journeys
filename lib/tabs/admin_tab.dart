import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rogue_journeys/pages/progression-tree-admin_page.dart';
import 'package:rogue_journeys/pages/skill_dictionary_admin_page.dart';

class AdminTab extends StatelessWidget {
  const AdminTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF202020),
      child: Center(
        child: Row(
          mainAxisAlignment: .center,
          children: [
            TextButton(
              child: Container(
                padding: EdgeInsets.all(8),
                color: Colors.blueAccent,
                child: Text(
                  "Skill Dictionary Admin",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => SkillDictionaryAdminPage(),
                ),
              ),
            ),
            TextButton(
              child: Container(
                padding: EdgeInsets.all(8),
                color: Colors.blueAccent,
                child: Text(
                  "Progression Tree Admin",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: () => Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => ProgressionTreeAdminPage(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
