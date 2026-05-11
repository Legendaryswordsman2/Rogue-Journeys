import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rogue_journeys/data_objects/class_info.dart';
import 'package:rogue_journeys/data_objects/student_info.dart';
import 'package:rogue_journeys/pages/account_page.dart';
import 'package:rogue_journeys/pages/skill_card_page.dart';
import 'package:rogue_journeys/widgets/appbar_gradient_widget.dart';
import 'package:rogue_journeys/widgets/text_widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ClassPage extends StatelessWidget {
  final Class session;

  const ClassPage({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 200,
        centerTitle: true,
        title: Text(
          session.title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),

        flexibleSpace: AppbarGradientContainer(),
      ),
      // body: StudentsList(),
      body: Column(
        children: [
          Header(session: session),
          Expanded(child: StudentsList(students: session.attendance)),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  final Class session;

  const Header({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xff0032c4), Color(0xff004cda), Color(0xff0032c4)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
              child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextWithIcon(
                      text: session.date,
                      icon: Icons.calendar_today,
                    ),
                    TextWithIcon(
                      text: "${session.startTime}-${session.endTime}",
                      icon: Icons.timer,
                    ),
                    TextWithIcon(text: session.coach, icon: Icons.person),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 75,
                    height: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: AutoSizeText(
                        maxLines: 1,
                        session.section.name,
                        style: TextStyle(
                          color: session.getSectionColor(),
                          fontWeight: FontWeight.bold,
                          fontSize: 30, // Max Font Size
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 75,
                    height: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Text(
                      "${session.attendance.length}/${session.capacity}",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StudentsList extends StatelessWidget {
  final List<Student> students;
  const StudentsList({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [TitleText("Students"), TitleText("Attendance")],
          ),
        ),

        Expanded(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(overscroll: false),
            child: ListView.builder(
              itemCount: students.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Divider(thickness: 1, color: Colors.black);
                }

                if (index == students.length + 1) {
                  return Divider(thickness: 1, color: Colors.black);
                }

                final studentIndex = index - 1;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StudentEntry(student: students[studentIndex]),
                    if (studentIndex < students.length - 1)
                      Divider(thickness: 1, color: Colors.black),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class StudentEntry extends StatelessWidget {
  final Student student;

  const StudentEntry({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => SkillCardPage(
              student: student,
              skillCardDefinition: student
                  .progressionState
                  .progressionTreeDefinition
                  .coreRoot
                  .skillCardDefinition,
            ),
          ),
        );
      },
      onLongPress: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => AccountPage(student: student),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AvatarAndInfo(student: student),
            AttendanceBox(),
          ],
        ),
      ),
    );
  }
}

class AttendanceBox extends StatelessWidget {
  const AttendanceBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadiusGeometry.circular(50),
            // border: Border.all(color: Colors.black, width: 2),
            color: Colors.grey.shade300,
          ),
        ),
        Icon(Icons.check, color: Colors.green, size: 50),
      ],
    );
  }
}

class AvatarAndInfo extends StatelessWidget {
  final Student student;

  const AvatarAndInfo({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfileAvatar(student: student),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              student.studentName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text("Level ${student.level}"),
          ],
        ),
      ],
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  final Student student;

  const ProfileAvatar({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadiusGeometry.circular(50),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(50),
        child: Image.asset(
          student.profilePicAssetLocation,
          height: 60,
          width: 60,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class TextWithIcon extends StatelessWidget {
  final String text;
  final IconData icon;

  const TextWithIcon({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      // padding: const EdgeInsets.all(5.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          SizedBox(width: 6),
          Text(text, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
