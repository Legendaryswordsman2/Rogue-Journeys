import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rogue_journeys/data_objects/progression_tree_template_info.dart';

class Student {
  final String id;
  final String studentName;
  final String profilePicAssetLocation;

  // ProgressionTreeInstance progressionTree = ProgressionTreeInstance.newTree(
  //   ProgressionTreeTemplateManager.insance.progressionTree,
  // );

  ProgressionState? _progressionState;

  ProgressionState get progressionState {
    return _progressionState ??= ProgressionState(
      student: this,
      progressionTreeDefinition:
          ProgressionTreeTemplateManager.insance.progressionTree,
    );
  }

  // ignore: unused_field
  final List<ProgressionState> _oldProgressionStates = [];

  final int level;

  Student({
    required this.id,
    required this.studentName,
    required this.profilePicAssetLocation,
    required this.level,
  });

  void saveToDatabase() async {
    await FirebaseFirestore.instance
        .collection("Students")
        .doc(id)
        .collection("progression")
        .doc("current")
        .set(progressionState.toJson());
  }

  static final Student sampleStudent = Student(
    id: "alando_duncan",
    studentName: "Alando Duncan",
    profilePicAssetLocation: "assets/images/test.png",
    level: 2,
  );

  static final List<Student> sampleStudentList1 = [
    Student(
      id: "joe_hawley",
      studentName: "Joe Hawley",
      profilePicAssetLocation:
          "assets/images/sample_profile_pics/set_1/joe_hawley.png",
      level: 3,
    ),
    Student(
      id: "rob_cantor",
      studentName: "Rob Cantor",
      profilePicAssetLocation:
          "assets/images/sample_profile_pics/set_1/rob_cantor.png",
      level: 1,
    ),
    Student(
      id: "zubin_sedghi",
      studentName: "Zubin Sedghi",
      profilePicAssetLocation:
          "assets/images/sample_profile_pics/set_1/zubin_sedghi.png",
      level: 5,
    ),
    Student(
      id: "andrew_horowitz",
      studentName: "Andrew Horowitz",
      profilePicAssetLocation:
          "assets/images/sample_profile_pics/set_1/andrew_horowitz.png",
      level: 2,
    ),
    Student(
      id: "ross_federman",
      studentName: "Ross Federman",
      profilePicAssetLocation:
          "assets/images/sample_profile_pics/set_1/ross_federman.png",
      level: 1,
    ),
  ];
  static final List<Student> sampleStudentList2 = [
    Student(
      id: "will_wood",
      studentName: "Will Wood",
      profilePicAssetLocation:
          "assets/images/sample_profile_pics/set_2/will_wood.png",
      level: 3,
    ),
    Student(
      id: "millie_wood",
      studentName: "Millie Wood",
      profilePicAssetLocation:
          "assets/images/sample_profile_pics/set_2/millie_wood.png",
      level: 1,
    ),
  ];
  static final List<Student> sampleStudentList3 = [
    Student(
      id: "mark_fischbach",
      studentName: "Mark Fischbach",
      profilePicAssetLocation:
          "assets/images/sample_profile_pics/set_3/mark_fischbach.png",
      level: 6,
    ),
    Student(
      id: "bob_muyskens",
      studentName: "Bob Muyskens",
      profilePicAssetLocation:
          "assets/images/sample_profile_pics/set_3/bob_muyskens.png",
      level: 1,
    ),
    Student(
      id: "wade_barnes",
      studentName: "Wade Barnes",
      profilePicAssetLocation:
          "assets/images/sample_profile_pics/set_3/wade_barnes.png",
      level: 3,
    ),
  ];
  static final List<Student> sampleStudentList4 = [
    Student(
      id: "jacksepticeye",
      studentName: "Jacksepticeye",
      profilePicAssetLocation:
          "assets/images/sample_profile_pics/set_4/jacksepticeye.png",
      level: 6,
    ),
    Student(
      id: "sean_mcloughlin",
      studentName: "Sean Mcloughlin",
      profilePicAssetLocation:
          "assets/images/sample_profile_pics/set_4/sean_mcloughlin.png",
      level: 1,
    ),
  ];
  static final List<Student> sampleStudentList5 = [
    Student(
      id: "blue_man_1",
      studentName: "Blue Man #1",
      profilePicAssetLocation:
          "assets/images/sample_profile_pics/set_5/blue_man_1.png",
      level: 6,
    ),
    Student(
      id: "rhett_mclaughlin",
      studentName: "Rhett McLaughlin",
      profilePicAssetLocation:
          "assets/images/sample_profile_pics/set_5/rhett_mclaughlin.png",
      level: 1,
    ),
    Student(
      id: "blue_man_2",
      studentName: "Blue Man #2",
      profilePicAssetLocation:
          "assets/images/sample_profile_pics/set_5/blue_man_2.png",
      level: 1,
    ),
    Student(
      id: "charles_link",
      studentName: "Charles Link",
      profilePicAssetLocation:
          "assets/images/sample_profile_pics/set_5/charles_link.png",
      level: 1,
    ),
    Student(
      id: "blue_man_3",
      studentName: "Blue Man #3",
      profilePicAssetLocation:
          "assets/images/sample_profile_pics/set_5/blue_man_3.png",
      level: 1,
    ),
  ];
}

class ProgressionState {
  // final String progressionTreeTemplateVersion;
  final Student student;

  final ProgressionTreeDefinition progressionTreeDefinition;

  final Map<SkillCardDefinition, SkillCardState> _skillCardStates = {};

  /// Individual skill progress
  Map<String, SkillState> _skillStates = {};

  ProgressionState({
    required this.student,
    required this.progressionTreeDefinition,
  });

  ProgressionState._internal({
    required this.student,
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

    SkillCardState skillCardState = getSkillCardState(node.skillCardDefinition);

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
      student: student,
      progressionTreeDefinition: progressionTreeDefinition,
      skillStates: {
        for (final entry in _skillStates.entries) entry.key: entry.value.copy(),
      },
    );
  }

  List<String> getCompletedSkillsList() {
    return _skillStates.entries
        .where((entry) => entry.value.completed)
        .map((entry) => entry.key)
        .toList();
  }

  /// Replace the entire skill states list with a new list
  void overrideSkillStates(ProgressionState newProgressionState) {
    _skillStates = newProgressionState._skillStates;
    student.saveToDatabase();
  }

  Map<String, dynamic> toJson() {
    return {
      "templateVersion": progressionTreeDefinition.version,
      "completedSkillIds": getCompletedSkillsList(),
    };
  }

  factory ProgressionState.fromJson(
    Map<String, dynamic> json,
    Student student,
  ) {
    final completedSkillIds = Set<String>.from(json["completedSkillIds"] ?? []);

    final state = ProgressionState(
      student: student,
      progressionTreeDefinition:
          ProgressionTreeTemplateManager.insance.progressionTree,
    );

    for (final id in completedSkillIds) {
      state._skillStates[id] = SkillState(completed: true);
    }

    return state;
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
