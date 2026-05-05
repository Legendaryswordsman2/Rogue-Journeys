import 'package:flutter/material.dart';
import 'package:rogue_journeys/data_objects/progression_tree_template_info.dart';
import 'package:rogue_journeys/widgets/appbar_gradient_widget.dart';

class SkillCardPage extends StatelessWidget {
  SkillCardPage({super.key});

  final SkillCardDefinition skillCardDefinition =
      ProgressionTreeTemplateManager
          .insance
          .progressionTree
          .coreRoot
          .skillCardDefinition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Skill Card",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        flexibleSpace: AppbarGradientContainer(),
      ),
      body: SkillCardView(skillCardDefinition: skillCardDefinition),
      // body: Column(
      //   crossAxisAlignment: .center,
      //   children: [
      //     SkillCategoryBlock(
      //       skillCategoryDefinition:
      //           skillCardDefinition.skillCategories[0],
      //     ),
      //     SkillCategoryBlock(
      //       skillCategoryDefinition:
      //           skillCardDefinition.skillCategories[1],
      //     ),
      //   ],
      // ),
    );
  }
}

class SkillCardView extends StatelessWidget {
  const SkillCardView({super.key, required this.skillCardDefinition});

  final SkillCardDefinition skillCardDefinition;

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
          ProgressHeader(),
          Expanded(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(
                context,
              ).copyWith(overscroll: false),
              child: ListView(
                children: skillCardDefinition.skillCategoryDefinitions
                    .map(
                      (skillCategory) => SkillCategoryBlock(
                        skillCategoryDefinition: skillCategory,
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
                  onTap: () => Navigator.pop(context),
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

          // Material(
          //   color: Colors.transparent,
          //   child: InkWell(
          //     onTap: () {
          //       Navigator.pop(context);
          //     },
          //     child: Container(
          //       margin: EdgeInsets.only(top: 10),
          //       width: 250,
          //       height: 50,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(20),
          //         gradient: const LinearGradient(
          //           colors: [Colors.lightBlue, Colors.blueAccent],
          //           begin: Alignment.topLeft,
          //           end: Alignment.bottomRight,
          //         ),
          //         border: Border.all(color: Colors.white10),
          //       ),
          //       child: Center(
          //         child: Text(
          //           "Save Changes",
          //           style: TextStyle(
          //             fontSize: 30,
          //             fontWeight: FontWeight.bold,
          //             color: Colors.white,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class ProgressHeader extends StatelessWidget {
  const ProgressHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              "Progression: LVL 1",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              "Rob Cantor",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        LinearProgressIndicator(
          value: 0.45,
          backgroundColor: Colors.white10,
          valueColor: AlwaysStoppedAnimation(Colors.greenAccent),
        ),
        SizedBox(height: 8),
        Text(
          "42% completed",
          style: TextStyle(color: Colors.white54),
        ),
      ],
    );
  }
}

class SkillCategoryBlock extends StatelessWidget {
  const SkillCategoryBlock({
    super.key,
    required this.skillCategoryDefinition,
  });

  final SkillCategoryDefinition skillCategoryDefinition;

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
      // width: 250,
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
              skillDefinition: skill,
              skillCategoryDefinition: skillCategoryDefinition,
            ),
          ),
          LinearProgressIndicator(
            value: 1 / 4,
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation(
              skillCategoryDefinition.color,
            ),
          ),
        ],
      ),
    );
  }
}

class SkillEntry extends StatefulWidget {
  const SkillEntry({
    super.key,
    required this.skillDefinition,
    required this.skillCategoryDefinition,
  });

  final SkillCategoryDefinition skillCategoryDefinition;
  final SkillDefinition skillDefinition;

  @override
  State<SkillEntry> createState() => _SkillEntryState();
}

class _SkillEntryState extends State<SkillEntry> {
  bool _isChecked = false;

  void _toggle() {
    setState(() => _isChecked = !_isChecked);
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
        margin: const EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 10,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _isChecked
              ? widget.skillCategoryDefinition.color.withAlpha(30)
              : const Color(0xFF2A2A2A),
          border: Border.all(
            color: _isChecked
                ? widget.skillCategoryDefinition.color
                : Colors.white12,
            width: 1.5,
          ),
          boxShadow: _isChecked
              ? [
                  BoxShadow(
                    color: widget.skillCategoryDefinition.color
                        .withValues(alpha: 0.25),
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
              child: _isChecked
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
                  color: _isChecked ? Colors.white : Colors.white70,
                  fontWeight: _isChecked
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
