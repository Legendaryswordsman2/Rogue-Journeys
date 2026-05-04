import 'package:flutter/material.dart';
import 'package:rogue_journeys/data_objects/progression_tree_info.dart';
import 'package:rogue_journeys/widgets/appbar_gradient_widget.dart';

class SkillCardPage extends StatelessWidget {
  SkillCardPage({super.key});

  final SkillCardDefinition skillCardDefinition =
      ProgressionTreeTemplateManager
          .insance
          .progressionTree
          .skillCardTracks[0]
          .skillCardDefinitions[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 200,
        centerTitle: true,
        title: Text(
          "Skill Card",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        flexibleSpace: AppbarGradientContainer(),
      ),
      body: Column(
        crossAxisAlignment: .center,
        children: [
          SkillCategoryBlock(
            skillCategoryDefinition:
                skillCardDefinition.skillCategories[0],
          ),
          SkillCategoryBlock(
            skillCategoryDefinition:
                skillCardDefinition.skillCategories[1],
          ),
        ],
      ),
    );
  }
}

class SkillCategoryBlock extends StatelessWidget {
  const SkillCategoryBlock({
    super.key,
    required this.skillCategoryDefinition,
  });

  final SkillCategoryDefinition skillCategoryDefinition;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 190, 189, 189),
          borderRadius: BorderRadius.circular(10),
          border: BoxBorder.all(
            color: const Color.fromARGB(255, 88, 88, 88),
            width: 3,
          ),
        ),
        width: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                skillCategoryDefinition.displayName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...skillCategoryDefinition.skills.map(
              (skill) => SkillEntry(skillDefinition: skill),
            ),
          ],
        ),
      ),
    );
  }
}

class SkillEntry_Old extends StatelessWidget {
  final SkillDefinition skillDefinition;

  const SkillEntry_Old({super.key, required this.skillDefinition});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: BoxBorder.all(color: Colors.black, width: 3),
      ),
      child: Row(
        children: [
          Checkbox(value: false, onChanged: null),
          Text(
            skillDefinition.displayName,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class SkillEntry extends StatefulWidget {
  const SkillEntry({super.key, required this.skillDefinition});

  final SkillDefinition skillDefinition;

  @override
  State<SkillEntry> createState() => _SkillEntryState();
}

class _SkillEntryState extends State<SkillEntry> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _isChecked = !_isChecked;
        });
      },
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: _isChecked ? Colors.green : Colors.black,
            width: 3,
          ),
        ),
        child: Row(
          children: [
            Checkbox(
              value: _isChecked,
              onChanged: (value) {
                setState(() {
                  _isChecked = value ?? false;
                });
              },
            ),
            Text(
              widget.skillDefinition.displayName,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
