import 'package:flutter/material.dart';
import 'package:rogue_journeys/data_objects/progression_tree_template_info.dart';
import 'package:rogue_journeys/data_objects/student_info.dart';
import 'package:rogue_journeys/widgets/appbar_gradient_widget.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key, required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF202020),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Account",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),

        flexibleSpace: AppbarGradientContainer(),
      ),
      body: Center(
        child: ProgressionTreeView(
          rootNode: student.progressionState.progressionTreeDefinition.coreRoot,
        ),
      ),
    );
  }
}

class ProgressionTreeView extends StatelessWidget {
  const ProgressionTreeView({super.key, required this.rootNode});

  final ProgressionNodeDefinition rootNode;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.all(16),
      // width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xFF121212),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisAlignment: .center,
        verticalDirection: VerticalDirection.up,
        children: [
          SkillCardInfoEntry(skillCardDefinition: rootNode.skillCardDefinition),
          Icon(Icons.arrow_upward, size: 18, color: Colors.white),
          SkillCardInfoEntry(
            skillCardDefinition: rootNode.next[0].skillCardDefinition,
          ),
          Icon(Icons.arrow_upward, size: 18, color: Colors.white),
          SkillCardInfoEntry(
            skillCardDefinition: rootNode.next[0].next[0].skillCardDefinition,
          ),
        ],
      ),
      // child: Center(
      //   child: SkillCardInfoEntry(
      //     skillCardDefinition: rootNode.skillCardDefinition,
      //   ),
      // ),
    );
  }
}

class SkillCardInfoEntry extends StatelessWidget {
  const SkillCardInfoEntry({super.key, required this.skillCardDefinition});

  final SkillCardDefinition skillCardDefinition;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 100,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF1C1C1C), Color(0xFF141414)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Color(0xFF202020)),
      ),
      child: Column(
        mainAxisAlignment: .spaceBetween,
        children: [
          Text(
            skillCardDefinition.displayName,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Text("5/20 Skill Completed", style: TextStyle(color: Colors.white)),
          LinearProgressIndicator(
            value: 5 / 25,
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation(Colors.orangeAccent),
          ),
        ],
      ),
    );
  }
}

class ConnectorLine extends StatelessWidget {
  const ConnectorLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          child: Center(
            child: Container(width: 2, height: 40, color: Colors.white54),
          ),
        ),

        const SizedBox(width: 12),

        const Expanded(child: SizedBox()),
      ],
    );
  }
}
