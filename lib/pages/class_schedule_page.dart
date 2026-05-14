import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rogue_journeys/data_objects/student_info.dart';
import 'package:rogue_journeys/main.dart';
import 'package:rogue_journeys/tabs/admin_tab.dart';
import 'package:rogue_journeys/pages/class_page.dart';
import 'package:rogue_journeys/data_objects/class_info.dart';
import 'package:rogue_journeys/tabs/skill_dictionary_tab.dart';
import 'package:rogue_journeys/tabs/student_search_tab.dart';
import 'package:rogue_journeys/widgets/appbar_gradient_widget.dart';

class ClassSchedulePage extends StatefulWidget {
  const ClassSchedulePage({super.key});

  @override
  State<ClassSchedulePage> createState() => _ClassSchedulePageState();
}

class _ClassSchedulePageState extends State<ClassSchedulePage> {
  int _selectedIndex = 0;

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
            icon: Icon(Icons.smartphone, color: Colors.white),
            color: Colors.white,
            onPressed: () {
              useMobileFrame.value = !useMobileFrame.value;
            },
          ),
          if (kDebugMode)
            IconButton(
              icon: Icon(Icons.cloud, color: Colors.white),
              color: Colors.white,
              onPressed: () {
                Student.uploadSampleStudentsToDatabase();
              },
            ),
        ],
      ),
      body: _pages[_selectedIndex],
      // body:
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF2196F3),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Schedule",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Students"),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: "Skill Dictionary",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings),
            label: "Admin",
          ),
        ],
      ),
    );
  }

  final List<Widget> _pages = const [
    ClassScheduleView(),
    StudentSearchTab(),
    SkillDictionaryTab(),
    AdminTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class ClassScheduleView extends StatefulWidget {
  const ClassScheduleView({super.key});

  @override
  State<ClassScheduleView> createState() => _ClassScheduleViewState();
}

class _ClassScheduleViewState extends State<ClassScheduleView> {
  late final Future<List<Class>> _upcomingClassesFuture;

  late final Future<List<Class>> _earlierClassesFuture;

  @override
  void initState() {
    super.initState();

    _upcomingClassesFuture = loadUpcomingClasses();
    _earlierClassesFuture = loadEarlierClasses();
  }

  Future<List<Class>> loadUpcomingClasses() async {
    final classes = await Future.wait(
      Class.sampleUpcomingClasses.map((upcomingClass) {
        return Class.fromStudentIds(
          date: upcomingClass.date,
          startTime: upcomingClass.startTime,
          endTime: upcomingClass.endTime,
          title: upcomingClass.title,
          coach: upcomingClass.coach,
          section: upcomingClass.section,
          capacity: upcomingClass.capacity,
          studentIds: upcomingClass.tempStudentIds,
        );
      }),
    );

    return classes;
  }

  Future<List<Class>> loadEarlierClasses() async {
    final classes = await Future.wait(
      Class.sampleEarlierClasses.map((earlierClass) {
        return Class.fromStudentIds(
          date: earlierClass.date,
          startTime: earlierClass.startTime,
          endTime: earlierClass.endTime,
          title: earlierClass.title,
          coach: earlierClass.coach,
          section: earlierClass.section,
          capacity: earlierClass.capacity,
          studentIds: earlierClass.tempStudentIds,
        );
      }),
    );

    return classes;
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
      child: ListView(
        children: [
          FutureBuilder(
            future: _earlierClassesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              final classes = snapshot.data ?? [];

              return ClassList(
                title: "Earlier Classes",
                sessions: classes,
                initiallyExpanded: false,
              );
            },
          ),
          FutureBuilder(
            future: _upcomingClassesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              final classes = snapshot.data ?? [];

              return ClassList(
                title: "Upcoming Classes",
                sessions: classes,
                initiallyExpanded: true,
              );
            },
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
  final List<Class> sessions;
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
            ...sessions.map((sessions) => ClassEntry(session: sessions)),
          ],
        ),
      ],
    );
  }
}

class ClassEntry extends StatelessWidget {
  final Class session;

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
                  ClassTimeRange(session: session),
                  ClassTitle(session: session),
                  ClassCapacity(session: session),
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
  final Class session;

  const ClassTimeRange({super.key, required this.session});

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
        children: [Text("${session.startTime}-"), Text(session.endTime)],
      ),
    );
  }
}

class ClassTitle extends StatelessWidget {
  final Class session;

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
  final Class session;

  const ClassCapacity({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      width: 45,
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(18),
      ),

      alignment: Alignment.center,
      child: Text("${session.attendance.length}/${session.capacity}"),
    );
  }
}
