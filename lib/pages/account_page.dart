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
      child: Test(rootNode: rootNode),
      // child: Column(
      //   mainAxisAlignment: .center,
      //   verticalDirection: VerticalDirection.up,
      //   children: [
      //     // SkillCardInfoEntry(skillCardDefinition: rootNode.skillCardDefinition),
      //     // Icon(Icons.arrow_upward, size: 18, color: Colors.white),
      //     // SkillCardInfoEntry(
      //     //   skillCardDefinition: rootNode.next[0].skillCardDefinition,
      //     // ),
      //     // Icon(Icons.arrow_upward, size: 18, color: Colors.white),
      //     // SkillCardInfoEntry(
      //     //   skillCardDefinition: rootNode.next[0].next[0].skillCardDefinition,
      //     // ),
      //   ],
      // ),
    );
  }
}

class Test extends StatelessWidget {
  const Test({super.key, required this.rootNode});

  final ProgressionNodeDefinition rootNode;

  @override
  Widget build(BuildContext context) {
    return buildTree(rootNode);
  }

  Widget buildTree(ProgressionNodeDefinition node) {
    if (node.next.isEmpty) {
      return SkillCardInfoEntry(skillCardDefinition: node.skillCardDefinition);
    }

    if (node.next.length == 1) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.up,
        children: [
          SkillCardInfoEntry(skillCardDefinition: node.skillCardDefinition),
          buildTree(node.next.first),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      verticalDirection: VerticalDirection.up,
      children: [
        SkillCardInfoEntry(skillCardDefinition: node.skillCardDefinition),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: node.next
              .map((child) => Expanded(child: buildTree(child)))
              .toList(),
        ),
      ],
    );
  }
}

class SkillCardInfoRow extends StatelessWidget {
  const SkillCardInfoRow({super.key, required this.progressionNodes});

  final List<ProgressionNodeDefinition> progressionNodes;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: progressionNodes
          .map(
            (node) => SkillCardInfoEntry(
              skillCardDefinition: node.skillCardDefinition,
            ),
          )
          .toList(),
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
          FittedBox(
            child: Text(
              skillCardDefinition.displayName,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          FittedBox(child: Text("5/20 Skills", style: TextStyle(color: Colors.white))),
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
