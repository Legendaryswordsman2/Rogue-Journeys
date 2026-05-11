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

class ProgressionTreeView extends StatefulWidget {
  const ProgressionTreeView({
    super.key,
    required this.student,
    required this.rootNode,
  });

  final Student student;
  final ProgressionNodeDefinition rootNode;

  @override
  State<ProgressionTreeView> createState() => _ProgressionTreeViewState();
}

class _ProgressionTreeViewState extends State<ProgressionTreeView> {
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
          children: [
            ProgressionTreeNodes(
              student: widget.student,
              rootNode: widget.rootNode,
              onPressed: (skillCardDefinition) =>
                  openSkillCard(context, skillCardDefinition),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> openSkillCard(
    BuildContext context,
    SkillCardDefinition skillCardDefinition,
  ) async {
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => SkillCardPage(
          student: widget.student,
          skillCardDefinition: skillCardDefinition,
        ),
      ),
    );

    setState(() {});
  }
}

class ProgressionTreeNodes extends StatelessWidget {
  const ProgressionTreeNodes({
    super.key,
    required this.student,
    required this.rootNode,
    required this.onPressed,
  });

  final Student student;
  final ProgressionNodeDefinition rootNode;

  final void Function(SkillCardDefinition) onPressed;

  @override
  Widget build(BuildContext context) {
    return buildTree(rootNode);
  }

  Widget buildTree(ProgressionNodeDefinition node) {
    if (node.next.isEmpty) {
      return SkillCardInfoEntry(
        student: student,
        skillCardDefinition: node.skillCardDefinition,
        onPressed: (definition) => onPressed(definition),
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
            onPressed: (definition) => onPressed(definition),
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
          onPressed: (definition) => onPressed(definition),
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
    required this.onPressed,
  });

  final Student student;
  final SkillCardDefinition skillCardDefinition;

  final void Function(SkillCardDefinition) onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Material(
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias, // important
        child: InkWell(
          onTap: () => onPressed(skillCardDefinition),
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
                  student: student,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SkillCardInfoEntryContents extends StatelessWidget {
  final SkillCardDefinition skillCardDefinition;
  final Student student;

  final SkillCardState skillCardState;

  SkillCardInfoEntryContents({
    super.key,
    required this.skillCardDefinition,
    required this.student,
  }) : skillCardState = student.progressionState.getSkillCardState(
         skillCardDefinition,
       );

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

            Text(
              "${skillCardState.completedSkillsAmount}/${skillCardDefinition.totalSkills} Skills",
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
              value: student.progressionState
                  .getSkillCardState(skillCardDefinition)
                  .completionPercentage,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation(Colors.greenAccent),
              // valueColor: AlwaysStoppedAnimation(Colors.orangeAccent),
            ),
          ),
        ),
      ],
    );
  }
}
