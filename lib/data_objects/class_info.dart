import 'package:flutter/material.dart';
import 'package:rogue_journeys/data_objects/student_info.dart';

enum SectionType { floor, walls, vaults, precisions, bars }

class Class {
  final String date;

  final String startTime;
  final String endTime;

  final String title;
  final String coach;
  final SectionType section;

  final String capacity;

  final List<Student> attendance;

  // Tempoary list used to get students adding class, will be replaced with data from Wellness Living
  final List<String> tempStudentIds;

  const Class({
    required this.date,

    required this.startTime,
    required this.endTime,

    required this.title,
    required this.coach,
    required this.section,

    required this.capacity,

    required this.attendance,

    required this.tempStudentIds,
  });

  static Future<Class> fromStudentIds({
    required String date,
    required String startTime,
    required String endTime,
    required String title,
    required String coach,
    required SectionType section,
    required String capacity,
    required List<String> studentIds,
  }) async {
    final List<Student> students = [];

    debugPrint("Student IDs: $studentIds");

    for (final id in studentIds) {
      final student = await Student.fromId(id);

      if (student != null) {
        students.add(student);
      }
    }
    debugPrint("Students : ${students.length}");

    return Class(
      date: date,
      startTime: startTime,
      endTime: endTime,
      title: title,
      coach: coach,
      section: section,
      capacity: capacity,
      attendance: students,
      tempStudentIds: [],
    );
  }

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
      capacity: "6",
      attendance: Student.sampleStudentList3,
      tempStudentIds: ['mark_fischbach', 'bob_muyskens', 'wade_barnes'],
    ),
    Class(
      date: "Wednesday, Apr 29, 2026",
      startTime: "5:00pm",
      endTime: "5:50pm",
      title: "Youth Level 1 Parkour",
      coach: "Avery Shultz",
      section: SectionType.vaults,
      capacity: "8",
      attendance: Student.sampleStudentList2,
      tempStudentIds: ['will_wood', 'millie_wood'],
    ),
    Class(
      date: "Wednesday, Apr 29, 2026",
      startTime: "5:00pm",
      endTime: "5:50pm",
      title: "Youth 2 & 3 Parkour",
      coach: "Chase Engrstrom",
      section: SectionType.bars,
      capacity: "10",
      attendance: Student.sampleStudentList5,
      tempStudentIds: [
        "blue_man_1",
        "rhett_mclaughlin",
        "blue_man_2",
        "charles_link",
        "blue_man_3",
      ],
    ),
    Class(
      date: "Wednesday, Apr 29, 2026",
      startTime: "5:00pm",
      endTime: "5:50pm",
      title: "Intro to Flips",
      coach: "Jacob Lavelle",
      section: SectionType.floor,
      capacity: "10",
      attendance: Student.sampleStudentList4,
      tempStudentIds: ["jacksepticeye", "sean_mcloughlin"],
    ),
    Class(
      date: "Wednesday, Apr 29, 2026",
      startTime: "6:00pm",
      endTime: "6:50pm",
      title: "Teen/Adult 2 & 3 Parkour",
      coach: "Zander Duncan",
      section: SectionType.walls,
      capacity: "10",
      attendance: Student.sampleStudentList1,
      tempStudentIds: [
        "joe_hawley",
        "rob_cantor",
        "zubin_sedghi",
        "andrew_horowitz",
        "ross_federman",
      ],
    ),
    Class(
      date: "Wednesday, Apr 29, 2026",
      startTime: "6:00pm",
      endTime: "6:50pm",
      title: "Acro 4-6 Parkour",
      coach: "Jacob Lavelle",
      section: SectionType.floor,
      capacity: "10",
      attendance: Student.sampleStudentList1,
      tempStudentIds: [
        "joe_hawley",
        "rob_cantor",
        "zubin_sedghi",
        "andrew_horowitz",
        "ross_federman",
      ],
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
      capacity: "6",
      attendance: Student.sampleStudentList1,
      tempStudentIds: [
        "joe_hawley",
        "rob_cantor",
        "zubin_sedghi",
        "andrew_horowitz",
        "ross_federman",
      ],
    ),
    Class(
      date: "Wednesday, Apr 29, 2026",
      startTime: "3:00pm",
      endTime: "3:50pm",
      title: "Youth Level 1 Parkour",
      coach: "Zander Duncan",
      section: SectionType.precisions,
      capacity: "10",
      attendance: Student.sampleStudentList4,
      tempStudentIds: ["jacksepticeye", "sean_mcloughlin"],
    ),
    Class(
      date: "Wednesday, Apr 29, 2026",
      startTime: "3:00pm",
      endTime: "3:50pm",
      title: "Youth 2 & 3 Parkour",
      coach: "Chase Engrstrom",
      section: SectionType.bars,
      capacity: "10",
      attendance: Student.sampleStudentList2,
      tempStudentIds: ['will_wood', 'millie_wood'],
    ),
  ];
}
