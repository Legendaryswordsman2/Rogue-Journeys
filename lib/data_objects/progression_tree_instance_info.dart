import 'package:rogue_journeys/data_objects/progression_tree_template_info.dart';

class ProgressionTreeInstance {
  final ProgressionTreeDefinition progressionTreeDefinition;
  final List<ProgressionTrackInstance> progressionTracks;

  ProgressionTreeInstance({required this.progressionTreeDefinition, required this.progressionTracks});
}

class ProgressionTrackInstance {
  final ProgressionTrackDefinition skillCardTrackDefinition;
  final List<SkillCardInstance> skillCards;

  ProgressionTrackInstance({
    required this.skillCardTrackDefinition,
    required this.skillCards,
  });
}

class SkillCardInstance {
  final SkillCardDefinition skillCardDefinition;
  final List<SkillCategoryInstance> skillCategories;

  SkillCardInstance({
    required this.skillCardDefinition,
    required this.skillCategories,
  });
}

class SkillCategoryInstance {
  final SkillCategoryDefinition skillCategoryDefinition;
  final List<SkillInstance> skills;

  SkillCategoryInstance({
    required this.skillCategoryDefinition,
    required this.skills,
  });
}

class SkillInstance {
  final SkillDefinition skillDefinition;

  bool skillCompleted;

  SkillInstance({
    required this.skillDefinition,
    this.skillCompleted = false,
  });
}
