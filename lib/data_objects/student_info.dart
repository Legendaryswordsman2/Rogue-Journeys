class Student {
  final String studentName;
  final String profilePicAssetLocation;

  final int level;

  const Student({
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
      profilePicAssetLocation: "assets/images/tally_hall/joe_hawley.png",
      level: 3,
    ),
     Student(
      studentName: "Rob Cantor",
      profilePicAssetLocation: "assets/images/tally_hall/rob_cantor.png",
      level: 1,
    ),
     Student(
      studentName: "Zubin Sedghi",
      profilePicAssetLocation: "assets/images/tally_hall/zubin_sedghi.png",
      level: 5,
    ),
     Student(
      studentName: "Andrew Horowitz",
      profilePicAssetLocation: "assets/images/tally_hall/andrew_horowitz.png",
      level: 2,
    ),
     Student(
      studentName: "Ross Federman",
      profilePicAssetLocation: "assets/images/tally_hall/ross_federman.png",
      level: 1,
    ),
  ];
}