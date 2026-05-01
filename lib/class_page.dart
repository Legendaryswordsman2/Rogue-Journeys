import 'package:flutter/material.dart';
import 'package:rogue_journeys/data_objects/class_info.dart';
import 'package:rogue_journeys/widgets/appbar_gradient_widget.dart';
import 'package:rogue_journeys/widgets/text_widgets.dart';

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
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        flexibleSpace: AppbarGradientContainer(),
      ),
      body: Column(
        children: [
          Header(session: session),
          StudentsList(),
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
          colors: [
            Color(0xff0032c4),
            Color(0xff004cda),
            Color(0xff0032c4),
          ],
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
                    TextWithIcon(
                      text: session.coach,
                      icon: Icons.person,
                    ),
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
                    child: Text(
                      session.section.name,
                      style: TextStyle(
                        color: session.getSectionColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
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
                      session.capacity,
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
  const StudentsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TitleText("Students"),
              TitleText("Attendance"),
            ],
          ),
        ),
        Divider(thickness: 1, color: Colors.black),
        StudentEntry(student: Student.sampleStudent),
      ],
    );
  }
}

class StudentEntry extends StatelessWidget {
  final Student student;

  const StudentEntry({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          Student.sampleStudent.profilePicAssetLocation,
          height: 20,
          width: 20,
        ),
        Column(
          children: [
            Text(student.studentName),
            Text("Level ${student.level}"),
          ],
        ),
      ],
    );
  }
}

class TextWithIcon extends StatelessWidget {
  final String text;
  final IconData icon;

  const TextWithIcon({
    super.key,
    required this.text,
    required this.icon,
  });

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
