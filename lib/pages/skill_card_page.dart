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
    return Container(
      color: Color(0xFFEDD6B1),
      child: Column(
        children: skillCategoryDefinition.skills
            .map((skill) => SkillEntry(skillDefinition: skill))
            .toList(),
      ),
    );
  }
}

class SkillEntry extends StatelessWidget {
  final SkillDefinition skillDefinition;

  const SkillEntry({super.key, required this.skillDefinition});

  // bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(
        skillDefinition.displayName,
        style: TextStyle(color: Colors.black),
      ),
      value: false,
      onChanged: null,
    );
  }
}
