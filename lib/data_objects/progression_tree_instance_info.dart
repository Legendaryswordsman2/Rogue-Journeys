import 'package:rogue_journeys/data_objects/progression_tree_definitions.dart';

// This whole file is currently unusued as I move away from this structure. This file will eventually be deleted.

class ProgressionTreeInstance {
  final ProgressionTreeDefinition progressionTreeDefinition;
  final ProgressionNodeInstance coreRoot;
  final List<ProgressionNodeInstance> sideRoots;

  ProgressionTreeInstance({
    required this.progressionTreeDefinition,
    required this.coreRoot,
    required this.sideRoots,
  });

  ProgressionTreeInstance.newTree(ProgressionTreeDefinition progressionTreeDef)
    : progressionTreeDefinition = progressionTreeDef,
      coreRoot = ProgressionNodeInstance.newNode(progressionTreeDef.coreRoot),
      sideRoots = progressionTreeDef.sideRoots.map((childRoot) => ProgressionNodeInstance.newNode(childRoot)).toList();
}

class ProgressionNodeInstance {
  final ProgressionNodeDefinition progressionNodeDefinition;
  final SkillCardInstance skillCard;
  final List<ProgressionNodeInstance> next;

  ProgressionNodeInstance({
    required this.progressionNodeDefinition,
    required this.skillCard,
    required this.next,
  });

  ProgressionNodeInstance.newNode(ProgressionNodeDefinition progressionNodeDef)
  : progressionNodeDefinition = progressionNodeDef,
  skillCard = SkillCardInstance.newSkillCard(progressionNodeDef.skillCardDefinition),
  next = progressionNodeDef.next.map((childDef) => ProgressionNodeInstance.newNode(childDef)).toList();
}

class SkillCardInstance {
  final SkillCardDefinition skillCardDefinition;
  final List<SkillCategoryInstance> skillCategories;

  SkillCardInstance({
    required this.skillCardDefinition,
    required this.skillCategories,
  });

  SkillCardInstance.newSkillCard(SkillCardDefinition skillCardDef)
  : skillCardDefinition = skillCardDef,
  skillCategories = skillCardDef.skillCategoryDefinitions.map((childCategoryDefinition) => SkillCategoryInstance.newSkillCategory(childCategoryDefinition)).toList();
}

class SkillCategoryInstance {
  final SkillCategoryDefinition skillCategoryDefinition;
  final List<SkillInstance> skills;

  SkillCategoryInstance({
    required this.skillCategoryDefinition,
    required this.skills,
  });

  SkillCategoryInstance.newSkillCategory(SkillCategoryDefinition skillCategoryDef)
  : skillCategoryDefinition = skillCategoryDef,
  skills = skillCategoryDef.skillDefinitions.map((childSkillDefinition) => SkillInstance.newSkill(childSkillDefinition)).toList();
}

class SkillInstance {
  final SkillDefinition skillDefinition;

  bool skillCompleted = false;

  SkillInstance({
    required this.skillDefinition,
    this.skillCompleted = false,
  });

  SkillInstance.newSkill(SkillDefinition skillDef)
  : skillDefinition = skillDef;
}
