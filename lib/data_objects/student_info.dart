import 'package:rogue_journeys/data_objects/progression_tree_template_info.dart';

class Student {
  final String studentName;
  final String profilePicAssetLocation;

  // ProgressionTreeInstance progressionTree = ProgressionTreeInstance.newTree(
  //   ProgressionTreeTemplateManager.insance.progressionTree,
  // );

  ProgressionState? _progressionState;

  ProgressionState get progressionState {
    return _progressionState ??= ProgressionState(
      progressionTreeDefinition:
          ProgressionTreeTemplateManager.insance.progressionTree,
    );
  }

  // ignore: unused_field
  final List<ProgressionState> _oldProgressionStates = [];

  final int level;

  Student({
    required this.studentName,
    required this.profilePicAssetLocation,
    required this.level,
  });

  static final Student sampleStudent = Student(
    studentName: "Alando Duncan",
    profilePicAssetLocation: "assets/images/test.png",
    level: 2,
  );

  static final List<Student> sampleStudentList1 = [
    Student(
      studentName: "Joe Hawley",
      profilePicAssetLocation:
          "assets/images/sample_profile_pics/set_1/joe_hawley.png",
      level: 3,
    ),
    Student(
      studentName: "Rob Cantor",
      profilePicAssetLocation:
          "assets/images/sample_profile_pics/set_1/rob_cantor.png",
      level: 1,
    ),
    Student(
      studentName: "Zubin Sedghi",
      profilePicAssetLocation:
          "assets/images/sample_profile_pics/set_1/zubin_sedghi.png",
      level: 5,
    ),
    Student(
      studentName: "Andrew Horowitz",
      profilePicAssetLocation:
          "assets/images/sample_profile_pics/set_1/andrew_horowitz.png",
      level: 2,
    ),
    Student(
      studentName: "Ross Federman",
      profilePicAssetLocation:
          "assets/images/sample_profile_pics/set_1/ross_federman.png",
      level: 1,
    ),
  ];
  static final List<Student> sampleStudentList2 = [
    Student(
      studentName: "Will Wood",
      profilePicAssetLocation:
          "assets/images/sample_profile_pics/set_2/will_wood.png",
      level: 3,
    ),
    Student(
      studentName: "Millie Wood",
      profilePicAssetLocation:
          "assets/images/sample_profile_pics/set_2/millie_wood.png",
      level: 1,
    ),
  ];
  static final List<Student> sampleStudentList3 = [
    Student(
      studentName: "Mark Fischbach",
      profilePicAssetLocation:
          "assets/images/sample_profile_pics/set_3/mark_fischbach.png",
      level: 6,
    ),
    Student(
      studentName: "Bob Muyskens",
      profilePicAssetLocation:
          "assets/images/sample_profile_pics/set_3/bob_muyskens.png",
      level: 1,
    ),
    Student(
      studentName: "Wade Barnes",
      profilePicAssetLocation:
          "assets/images/sample_profile_pics/set_3/wade_barnes.png",
      level: 3,
    ),
  ];
  static final List<Student> sampleStudentList4 = [
    Student(
      studentName: "Jacksepticeye",
      profilePicAssetLocation:
          "assets/images/sample_profile_pics/set_4/jacksepticeye.png",
      level: 6,
    ),
    Student(
      studentName: "Sean Mcloughlin",
      profilePicAssetLocation:
          "assets/images/sample_profile_pics/set_4/sean_mcloughlin.png",
      level: 1,
    ),
  ];
  static final List<Student> sampleStudentList5 = [
    Student(
      studentName: "Blue Man #1",
      profilePicAssetLocation:
          "assets/images/sample_profile_pics/set_5/blue_man_1.png",
      level: 6,
    ),
    Student(
      studentName: "Rhett McLaughlin",
      profilePicAssetLocation:
          "assets/images/sample_profile_pics/set_5/rhett_mclaughlin.png",
      level: 1,
    ),
    Student(
      studentName: "Blue Man #2",
      profilePicAssetLocation:
          "assets/images/sample_profile_pics/set_5/blue_man_2.png",
      level: 1,
    ),
    Student(
      studentName: "Charles Link",
      profilePicAssetLocation:
          "assets/images/sample_profile_pics/set_5/charles_link.png",
      level: 1,
    ),
    Student(
      studentName: "Blue Man #3",
      profilePicAssetLocation:
          "assets/images/sample_profile_pics/set_5/blue_man_3.png",
      level: 1,
    ),
  ];
}

class ProgressionState {
  // final String progressionTreeTemplateVersion;
  final ProgressionTreeDefinition progressionTreeDefinition;

  final Map<SkillCardDefinition, SkillCardState> _skillCardStates = {};

  /// Individual skill progress
  Map<String, SkillState> _skillStates = {};

  ProgressionState({required this.progressionTreeDefinition});

  ProgressionState._internal({
    required this.progressionTreeDefinition,
    required Map<String, SkillState> skillStates,
  }) : _skillStates = skillStates;

  SkillCardState getSkillCardState(SkillCardDefinition skillCardDefinition) {
    return _skillCardStates.putIfAbsent(
      skillCardDefinition,
      () => SkillCardState(
        skillCardDefinition: skillCardDefinition,
        progressionState: this,
      ),
    );
  }

  SkillCardState? getLatestUnlockedSkillCard(ProgressionNodeDefinition? node) {
    node ??= progressionTreeDefinition.coreRoot;
    SkillCardState skillCardState = getSkillCardState(
      progressionTreeDefinition.coreRoot.skillCardDefinition,
    );

    if (skillCardState.isComplete == false) return skillCardState;

    if (node.next.isNotEmpty) {
      return getLatestUnlockedSkillCard(node.next[0]);
    } else {
      return null;
    }
  }

  SkillState getSkillState(String skillId) {
    return _skillStates.putIfAbsent(skillId, () => SkillState());
  }

  bool isSkillCompleted(String skillId) {
    return getSkillState(skillId).completed;
  }

  int countCompletedSkills(Iterable<String> skillIds) {
    int count = 0;

    for (final id in skillIds) {
      if (isSkillCompleted(id)) {
        count++;
      }
    }

    return count;
  }

  int countAllCompletedSkills() {
    return _skillStates.values.where((s) => s.completed).length;
  }

  ProgressionState copy() {
    return ProgressionState._internal(
      progressionTreeDefinition: progressionTreeDefinition,
      skillStates: {
        for (final entry in _skillStates.entries) entry.key: entry.value.copy(),
      },
    );
  }

  /// Replace the entire skill states list with a new list
  void overrideSkillStates(ProgressionState newProgressionState) {
    _skillStates = newProgressionState._skillStates;
  }
}

class SkillCardState {
  final SkillCardDefinition skillCardDefinition;
  final ProgressionState progressionState;

  SkillCardState({
    required this.skillCardDefinition,
    required this.progressionState,
  });

  List<SkillState>? _skillStatesCache;

  List<SkillState> get _skillStates {
    if (_skillStatesCache != null) return _skillStatesCache!;

    return skillCardDefinition.skillCategoryDefinitions
        .expand((categoryDefinition) => categoryDefinition.skillDefinitions)
        .map(
          (skillDefinition) =>
              progressionState.getSkillState(skillDefinition.id),
        )
        .toList();
  }

  int get completedSkillsAmount {
    if (_skillStates.isEmpty) return 0;

    return _skillStates.where((skillState) => skillState.completed).length;
  }

  double get completionPercentage {
    return completedSkillsAmount / _skillStates.length;
  }

  bool get isComplete {
    return completionPercentage >= 1.0;
  }
}

class SkillState {
  bool completed = false;
  // DateTime? completedAt;

  SkillState({
    this.completed = false,
    // this.completedAt,
  });

  SkillState copy() {
    return SkillState(completed: completed);
  }
}
