import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rogue_journeys/data_objects/progression_tree_template_info.dart';
import 'package:rogue_journeys/data_objects/student_info.dart';
import 'package:rogue_journeys/pages/skill_card_page.dart';
import 'package:rogue_journeys/widgets/appbar_gradient_widget.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key, required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
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
            student: student,
            rootNode:
                student.progressionState.progressionTreeDefinition.coreRoot,
          ),
        ),
      ),
    );
  }
}

class ProgressionTreeView extends StatelessWidget {
  const ProgressionTreeView({
    super.key,
    required this.student,
    required this.rootNode,
  });

  final Student student;
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
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
        child: ListView(
          reverse: true,
          children: [Test(student: student, rootNode: rootNode)],
        ),
      ),
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
  const Test({super.key, required this.student, required this.rootNode});

  final Student student;
  final ProgressionNodeDefinition rootNode;

  @override
  Widget build(BuildContext context) {
    return buildTree(rootNode);
  }

  Widget buildTree(ProgressionNodeDefinition node) {
    if (node.next.isEmpty) {
      return SkillCardInfoEntry(
        student: student,
        skillCardDefinition: node.skillCardDefinition,
      );
    }

    if (node.next.length == 1) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.up,
        children: [
          SkillCardInfoEntry(
            student: student,
            skillCardDefinition: node.skillCardDefinition,
          ),
          buildTree(node.next.first),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      verticalDirection: VerticalDirection.up,
      children: [
        SkillCardInfoEntry(
          student: student,
          skillCardDefinition: node.skillCardDefinition,
        ),
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

class SkillCardInfoEntry extends StatelessWidget {
  const SkillCardInfoEntry({
    super.key,
    required this.student,
    required this.skillCardDefinition,
  });

  final Student student;
  final SkillCardDefinition skillCardDefinition;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias, // important
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => SkillCardPage(
                  student: student,
                  skillCardDefinition: skillCardDefinition,
                ),
              ),
            );
          },
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF343434), Color(0xFF242424)],
              ),
            ),
            child: SizedBox(
              width: 200,
              height: 120,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SkillCardInfoEntryContents(
                  skillCardDefinition: skillCardDefinition,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    //   return Material(
    //     child: InkWell(
    //       onTap: () {},
    //       child: Container(
    //         margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    //         // padding: EdgeInsets.all(12),
    //         child: Ink(
    //           width: 200,
    //           height: 120,
    //           // margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    //           padding: EdgeInsets.all(12),
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(20),
    //             gradient: LinearGradient(
    //               begin: Alignment.topLeft,
    //               end: Alignment.bottomRight,
    //               colors: [Color(0xFF343434), Color(0xFF242424)],
    //             ),
    //             // color: Color(0xFF2A2A2A),
    //             border: Border.all(color: Colors.white12, width: 1.5),
    //             boxShadow: [
    //               BoxShadow(
    //                 color: Colors.black.withValues(alpha: 0.3),
    //                 blurRadius: 10,
    //                 offset: Offset(0, 4),
    //               ),
    //             ],
    //           ),
    //           child: SkillCardInfoEntryContents(
    //             skillCardDefinition: skillCardDefinition,
    //           ),
    //         ),
    //       ),
    //     ),
    //   );
  }
}

class SkillCardInfoEntryContents extends StatelessWidget {
  final SkillCardDefinition skillCardDefinition;

  const SkillCardInfoEntryContents({
    super.key,
    required this.skillCardDefinition,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: .spaceBetween,
      children: [
        Column(
          children: [
            FittedBox(
              child: Text(
                skillCardDefinition.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 8),

            const Text(
              "5/20 Skills",
              style: TextStyle(
                color: Colors.white60,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 8,
            child: LinearProgressIndicator(
              value: 5 / 20,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation(Colors.orangeAccent),
            ),
          ),
        ),
      ],
    );
  }
}
