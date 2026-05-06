
class Student {
  final String studentName;
  final String profilePicAssetLocation;

  // ProgressionTreeInstance progressionTree = ProgressionTreeInstance.newTree(
  //   ProgressionTreeTemplateManager.insance.progressionTree,
  // );

  // final Map<String, SkillState> skillStates;

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

class SkillState {
  bool completed = false;
  DateTime? completedAt;
}
