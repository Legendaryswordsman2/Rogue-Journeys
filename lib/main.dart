import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rogue_journeys/class_page.dart';
import 'package:rogue_journeys/widgets/appbar_gradient_widget.dart';

enum SectionType { floor, walls, vaults, precisions, bars }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rogue Journeys',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final List<ClassSession> upcomingSessions = [
    ClassSession(
      date: "Wednesday, Apr 29, 2026",
      startTime: "5:00pm",
      endTime: "5:45pm",
      title: "Pre-K Parkour",
      coach: "Zander Duncan",
      section: SectionType.precisions,
      capacity: "3/6",
    ),
    ClassSession(
      date: "Wednesday, Apr 29, 2026",
      startTime: "5:00pm",
      endTime: "5:50pm",
      title: "Youth Level 1 Parkour",
      coach: "Avery Shulz",
      section: SectionType.vaults,
      capacity: "4/8",
    ),
    ClassSession(
      date: "Wednesday, Apr 29, 2026",
      startTime: "5:00pm",
      endTime: "5:50pm",
      title: "Youth 2 & 3 Parkour",
      coach: "Chase Engrstrom",
      section: SectionType.bars,
      capacity: "3/10",
    ),
    ClassSession(
      date: "Wednesday, Apr 29, 2026",
      startTime: "5:00pm",
      endTime: "5:50pm",
      title: "Intro to Flips",
      coach: "Jacob Lavelle",
      section: SectionType.floor,
      capacity: "6/10",
    ),
    ClassSession(
      date: "Wednesday, Apr 29, 2026",
      startTime: "6:00pm",
      endTime: "6:50pm",
      title: "Teen/Adult 2 & 3 Parkour",
      coach: "Zander Duncan",
      section: SectionType.walls,
      capacity: "5/10",
    ),
    ClassSession(
      date: "Wednesday, Apr 29, 2026",
      startTime: "6:00pm",
      endTime: "6:50pm",
      title: "Acro 4-6 Parkour",
      coach: "Jacob Lavelle",
      section: SectionType.floor,
      capacity: "2/10",
    ),
  ];

  final List<ClassSession> earlierSessions = [
    ClassSession(
      date: "Wednesday, Apr 29, 2026",
      startTime: "3:00pm",
      endTime: "3:45pm",
      title: "Pre-K Parkour",
      coach: "Jacob Lavelle",
      section: SectionType.vaults,
      capacity: "3/6",
    ),
    ClassSession(
      date: "Wednesday, Apr 29, 2026",
      startTime: "3:00pm",
      endTime: "3:50pm",
      title: "Youth Level 1 Parkour",
      coach: "Zander Duncan",
      section: SectionType.precisions,
      capacity: "8/10",
    ),
    ClassSession(
      date: "Wednesday, Apr 29, 2026",
      startTime: "3:00pm",
      endTime: "3:50pm",
      title: "Youth 2 & 3 Parkour",
      coach: "Chase Engrstrom",
      section: SectionType.bars,
      capacity: "1/10",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset("assets/images/logo.png", height: 40),

        flexibleSpace: AppbarGradientContainer(),

        leading: IconButton(
          icon: Icon(Icons.calendar_today, color: Colors.white),
          onPressed: null,
        ),

        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            color: Colors.white,
            onPressed: null,
          ),
        ],
      ),
      body: Column(
        children: [
          ClassList(
            title: "Earlier Classes",
            sessions: earlierSessions,
          ),
          ClassList(
            title: "Upcoming Classes",
            sessions: upcomingSessions,
            initiallyExpanded: true,
          ),
        ],
      ),
    );
  }
}

class ClassListTitle extends StatelessWidget {
  final String title;

  const ClassListTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 27),
        ),
      ),
    );
  }
}

class ClassList extends StatelessWidget {
  final String title;
  final List<ClassSession> sessions;
  final bool initiallyExpanded;
  const ClassList({
    super.key,
    required this.title,
    required this.sessions,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: ClassListTitle(title: title),
      initiallyExpanded: initiallyExpanded,
      children: [
        Column(
          children: [
            // Divider(thickness: 1, color: Colors.black),
            ...sessions.map(
              (sessions) => ClassEntry(session: sessions),
            ),
          ],
        ),
      ],
    );
  }
}

class ClassEntry extends StatelessWidget {
  final ClassSession session;

  const ClassEntry({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => ClassPage(session: session),
            ),
          );
        },
        child: Column(
          children: [
            Divider(thickness: 1, color: Colors.black),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClassTimeRange(
                    startTime: session.startTime,
                    endTime: session.endTime,
                  ),
                  ClassTitle(session: session),
                  ClassCapacity(capacity: session.capacity),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClassTimeRange extends StatelessWidget {
  final String startTime;
  final String endTime;

  const ClassTimeRange({
    super.key,
    required this.startTime,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(8),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text("$startTime-"), Text(endTime)],
      ),
    );
  }
}

class ClassTitle extends StatelessWidget {
  final ClassSession session;

  const ClassTitle({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            session.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          RichText(
            text: TextSpan(
              text: "with ${session.coach} in ",
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                  text: session.section.name,
                  style: TextStyle(color: session.getSectionColor()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ClassCapacity extends StatelessWidget {
  final String capacity;

  const ClassCapacity({super.key, required this.capacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      width: 45,
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Text(capacity),
      alignment: Alignment.center,
    );
  }
}

class ClassSession {
  final String date;

  final String startTime;
  final String endTime;

  final String title;
  final String coach;
  final SectionType section;

  final String capacity;

  const ClassSession({
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
}
