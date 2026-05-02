import 'package:flutter/material.dart';

enum SectionType { floor, walls, vaults, precisions, bars }

class Class {
  final String date;

  final String startTime;
  final String endTime;

  final String title;
  final String coach;
  final SectionType section;

  final String capacity;

  const Class({
    required this.date,

    required this.startTime,
    required this.endTime,

    required this.title,
    required this.coach,
    required this.section,

    required this.capacity,
  });

  Color getSectionColor() {
    return switch (section) {
      SectionType.floor => Colors.red,
      SectionType.vaults => Color(0xffffce00),
      SectionType.walls => Colors.orange,
      SectionType.bars => Colors.blue,
      SectionType.precisions => Colors.green,
    };
  }

  static final List<Class> sampleUpcomingClasses = [
    Class(
      date: "Wednesday, Apr 29, 2026",
      startTime: "5:00pm",
      endTime: "5:45pm",
      title: "Pre-K Parkour",
      coach: "Zander Duncan",
      section: SectionType.precisions,
      capacity: "3/6",
    ),
    Class(
      date: "Wednesday, Apr 29, 2026",
      startTime: "5:00pm",
      endTime: "5:50pm",
      title: "Youth Level 1 Parkour",
      coach: "Avery Shultz",
      section: SectionType.vaults,
      capacity: "4/8",
    ),
    Class(
      date: "Wednesday, Apr 29, 2026",
      startTime: "5:00pm",
      endTime: "5:50pm",
      title: "Youth 2 & 3 Parkour",
      coach: "Chase Engrstrom",
      section: SectionType.bars,
      capacity: "3/10",
    ),
    Class(
      date: "Wednesday, Apr 29, 2026",
      startTime: "5:00pm",
      endTime: "5:50pm",
      title: "Intro to Flips",
      coach: "Jacob Lavelle",
      section: SectionType.floor,
      capacity: "6/10",
    ),
    Class(
      date: "Wednesday, Apr 29, 2026",
      startTime: "6:00pm",
      endTime: "6:50pm",
      title: "Teen/Adult 2 & 3 Parkour",
      coach: "Zander Duncan",
      section: SectionType.walls,
      capacity: "5/10",
    ),
    Class(
      date: "Wednesday, Apr 29, 2026",
      startTime: "6:00pm",
      endTime: "6:50pm",
      title: "Acro 4-6 Parkour",
      coach: "Jacob Lavelle",
      section: SectionType.floor,
      capacity: "2/10",
    ),
  ];

  static final List<Class> sampleEarlierClasses = [
    Class(
      date: "Wednesday, Apr 29, 2026",
      startTime: "3:00pm",
      endTime: "3:45pm",
      title: "Pre-K Parkour",
      coach: "Jacob Lavelle",
      section: SectionType.vaults,
      capacity: "3/6",
    ),
    Class(
      date: "Wednesday, Apr 29, 2026",
      startTime: "3:00pm",
      endTime: "3:50pm",
      title: "Youth Level 1 Parkour",
      coach: "Zander Duncan",
      section: SectionType.precisions,
      capacity: "8/10",
    ),
    Class(
      date: "Wednesday, Apr 29, 2026",
      startTime: "3:00pm",
      endTime: "3:50pm",
      title: "Youth 2 & 3 Parkour",
      coach: "Chase Engrstrom",
      section: SectionType.bars,
      capacity: "1/10",
    ),
  ];
}

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
