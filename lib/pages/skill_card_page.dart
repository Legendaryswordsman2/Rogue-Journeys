import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rogue_journeys/data_objects/progression_tree_definitions.dart';
import 'package:rogue_journeys/data_objects/student_info.dart';
import 'package:rogue_journeys/main.dart';
import 'package:rogue_journeys/pages/account_page.dart';
import 'package:rogue_journeys/widgets/appbar_gradient_widget.dart';

class SkillCardPage extends StatelessWidget {
  SkillCardPage({
    super.key,
    required this.student,
    required this.skillCardDefinition,
  }) : tempProgressionState = student.progressionState.copy();

  final Student student;

  // A copy of the students progression state. This is modifed when changes are made in the Skill Card page. then when "Save Changes" is pressed, the tempProgressionState is applied to the students ProgressionState.
  final ProgressionState tempProgressionState;

  final SkillCardDefinition skillCardDefinition;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,

      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        showDialog(
          context: context,
          builder: (_) => const LeavePageConfirmationPopup(),
        );
      },
      child: Scaffold(
        backgroundColor: Color(0xFF202020),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Skill Card",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),

          leading: IconButton(
            icon: const Icon(Icons.arrow_back),

            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const LeavePageConfirmationPopup(),
              );
            },
          ),

          actions: [
            IconButton(
              icon: Icon(Icons.smartphone, color: Colors.white),
              color: Colors.white,
              onPressed: () {
                useMobileFrame.value = !useMobileFrame.value;
              },
            ),
          ],

          flexibleSpace: AppbarGradientContainer(),
        ),
        body: SkillCardView(
          skillCardDefinition: skillCardDefinition,
          student: student,
          progressionState: tempProgressionState,
        ),
      ),
    );
  }
}

class SkillCardView extends StatelessWidget {
  SkillCardView({
    super.key,
    required this.skillCardDefinition,
    required this.student,
    required this.progressionState,
  });

  final SkillCardDefinition skillCardDefinition;
  final Student student;
  final ProgressionState progressionState;

  final GlobalKey<_HeaderInfoViewState> _headerInfoViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xFF121212),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          HeaderInfoView(
            key: _headerInfoViewKey,
            student: student,
            progressionState: progressionState,
            skillCardDefinition: skillCardDefinition,
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(
                context,
              ).copyWith(overscroll: false),
              child: ListView(
                children: skillCardDefinition.skillCategoryDefinitions
                    .map(
                      (skillCategory) => SkillCategoryBlock(
                        progressionState: progressionState,
                        skillCategoryDefinition: skillCategory,
                        onCategoryUpdated: () => _headerInfoViewKey.currentState
                            ?.refreshHeaderProgresss(),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 10),
            child: Material(
              color: Colors.transparent,
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Colors.lightBlue, Colors.blueAccent],
                  ),
                  border: Border.all(color: Colors.white10),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    student.progressionState.overrideSkillStates(
                      progressionState,
                    );
                    Navigator.pop(context);
                  },
                  child: SizedBox(
                    width: 250,
                    height: 50,
                    child: Center(
                      child: Text(
                        "Save Changes",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderInfoView extends StatefulWidget {
  const HeaderInfoView({
    super.key,
    required this.student,
    required this.progressionState,
    required this.skillCardDefinition,
  });

  final Student student;
  final ProgressionState progressionState;
  final SkillCardDefinition skillCardDefinition;

  @override
  State<HeaderInfoView> createState() => _HeaderInfoViewState();
}

class _HeaderInfoViewState extends State<HeaderInfoView> {
  final GlobalKey<_HeaderProgressState> _headerProgressKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              widget.skillCardDefinition.displayName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.account_circle, color: Colors.white),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) =>
                            AccountPage(student: widget.student),
                      ),
                    );
                  },
                ),
                Text(
                  widget.student.studentName,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 10),
        HeaderProgress(
          key: _headerProgressKey,
          progressionState: widget.progressionState,
          skillCardDefinition: widget.skillCardDefinition,
        ),
      ],
    );
  }

  void refreshHeaderProgresss() {
    _headerProgressKey.currentState?.refresh();
  }
}

class HeaderProgress extends StatefulWidget {
  final ProgressionState progressionState;
  final SkillCardDefinition skillCardDefinition;

  const HeaderProgress({
    super.key,
    required this.progressionState,
    required this.skillCardDefinition,
  });

  @override
  State<HeaderProgress> createState() => _HeaderProgressState();
}

class _HeaderProgressState extends State<HeaderProgress> {
  void refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final completed = widget.progressionState
        .getSkillCardState(widget.skillCardDefinition)
        .completedSkillsAmount;
    final total = widget.skillCardDefinition.totalSkills;

    final int percent = total == 0 ? 0 : ((completed / total) * 100).round();

    return Column(
      crossAxisAlignment: .start,
      children: [
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: completed / total),
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          builder: (context, value, _) {
            return LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation(Colors.greenAccent),
            );
          },
        ),
        SizedBox(height: 8),
        Text("$percent% completed", style: TextStyle(color: Colors.white54)),
        SizedBox(height: 8),
      ],
    );
  }
}

class SkillCategoryBlock extends StatelessWidget {
  SkillCategoryBlock({
    super.key,
    required this.progressionState,
    required this.skillCategoryDefinition,
    required this.onCategoryUpdated,
  });

  final ProgressionState progressionState;
  final SkillCategoryDefinition skillCategoryDefinition;

  final GlobalKey<_CategoryProgressBarState> _progressBarKey = GlobalKey();

  final VoidCallback onCategoryUpdated;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF1C1C1C), Color(0xFF141414)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              skillCategoryDefinition.displayName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),

          ...skillCategoryDefinition.skillDefinitions.map(
            (skill) => SkillEntry(
              progressionState: progressionState,
              skillDefinition: skill,
              skillCategoryDefinition: skillCategoryDefinition,
              onUpdated: () {
                _progressBarKey.currentState?.refresh();
                onCategoryUpdated();
              },
            ),
          ),
          CategoryProgressBar(
            key: _progressBarKey,
            progressionState: progressionState,
            skillCategoryDefinition: skillCategoryDefinition,
          ),
        ],
      ),
    );
  }
}

class CategoryProgressBar extends StatefulWidget {
  const CategoryProgressBar({
    super.key,
    required this.progressionState,
    required this.skillCategoryDefinition,
  });

  final ProgressionState progressionState;
  final SkillCategoryDefinition skillCategoryDefinition;

  @override
  State<CategoryProgressBar> createState() => _CategoryProgressBarState();
}

class _CategoryProgressBarState extends State<CategoryProgressBar>
    with SingleTickerProviderStateMixin {
  void refresh() => setState(() {});

  late AnimationController _controller;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _pulse = Tween<double>(
      begin: 0.2,
      end: 0.6,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    final completed = widget.skillCategoryDefinition.skillsCompleted(
      widget.progressionState,
    );

    final total = widget.skillCategoryDefinition.skillDefinitions.length;

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: completed / total),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      builder: (context, value, _) {
        return LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.white10,
          valueColor: AlwaysStoppedAnimation(
            widget.skillCategoryDefinition.color,
          ),
        );
      },
    );
  }
}

class SkillEntry extends StatefulWidget {
  SkillEntry({
    super.key,
    required ProgressionState progressionState,
    required this.skillDefinition,
    required this.skillCategoryDefinition,
    required this.onUpdated,
  }) : skillState = progressionState.getSkillState(skillDefinition.id);

  final SkillCategoryDefinition skillCategoryDefinition;
  final SkillDefinition skillDefinition;

  final SkillState skillState;

  final VoidCallback onUpdated;

  @override
  State<SkillEntry> createState() => _SkillEntryState();
}

class _SkillEntryState extends State<SkillEntry> {
  void _toggle() {
    setState(() => widget.skillState.completed = !widget.skillState.completed);
    widget.onUpdated();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _toggle();
      },
      child: AnimatedContainer(
        duration: Duration(microseconds: 250),
        curve: Curves.easeOut,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: widget.skillState.completed
              ? widget.skillCategoryDefinition.color.withAlpha(30)
              : const Color(0xFF2A2A2A),
          border: Border.all(
            color: widget.skillState.completed
                ? widget.skillCategoryDefinition.color
                : Colors.white12,
            width: 1.5,
          ),
          boxShadow: widget.skillState.completed
              ? [
                  BoxShadow(
                    color: widget.skillCategoryDefinition.color.withValues(
                      alpha: 0.25,
                    ),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              child: widget.skillState.completed
                  ? Icon(
                      Icons.verified,
                      color: widget.skillCategoryDefinition.color,
                    )
                  : const Icon(
                      Icons.radio_button_unchecked,
                      color: Colors.white54,
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.skillDefinition.displayName,
                style: TextStyle(
                  color: widget.skillState.completed
                      ? Colors.white
                      : Colors.white70,
                  fontWeight: widget.skillState.completed
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
              ),
            ),
            Icon(Icons.info, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}

class LeavePageConfirmationPopup extends StatelessWidget {
  const LeavePageConfirmationPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Leave without Saving?"),
      content: const Text("Unsaved changes will be discarded."),

      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),

        ElevatedButton(
          onPressed: () => Navigator.of(context)
            ..pop()
            ..pop(),
          child: const Text("Confirm"),
        ),
      ],
    );
  }
}
