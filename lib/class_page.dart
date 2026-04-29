import 'package:flutter/material.dart';
import 'package:rogue_journeys/main.dart';
import 'package:rogue_journeys/widgets/appbar_gradient_widget.dart';

class ClassPage extends StatelessWidget {
  final ClassSession session;

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
      body: Header(session: session),
    );
  }
}

class Header extends StatelessWidget {
  final ClassSession session;

  const Header({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 50,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 20,
                ),
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Text(
                  session.section.name,
                  style: TextStyle(
                    color: session.getSectionColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Text(
                  session.capacity,
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        SizedBox(width: 6),
        Text(text, style: TextStyle(color: Colors.white)),
      ],
    );
  }
}
