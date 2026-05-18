import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rogue_journeys/data_objects/progression_tree_definitions.dart';
import 'package:rogue_journeys/main.dart';
import 'package:rogue_journeys/managers/progression_tree_manager.dart';
import 'package:rogue_journeys/managers/skill_dictionary_manager.dart';
import 'package:rogue_journeys/widgets/appbar_gradient_widget.dart';

class SkillDictionaryAdminPage extends StatefulWidget {
  const SkillDictionaryAdminPage({super.key});

  @override
  State<SkillDictionaryAdminPage> createState() =>
      _SkillDictionaryAdminPageState();
}

class _SkillDictionaryAdminPageState extends State<SkillDictionaryAdminPage> {
  late SkillDefinition selectedSkill;

  @override
  void initState() {
    super.initState();

    debugPrint(
      "Skills Count: ${ProgressionTreeManager.insance.initializedSkillDefinitions.length}",
    );

    selectedSkill =
        ProgressionTreeManager.insance.initializedSkillDefinitions.first;
  }

  void selectSkill(SkillDefinition skill) {
    setState(() {
      selectedSkill = skill;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: Color(0xFF202020),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Skill Dictionary Admin",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
        body: Row(
          children: [
            Expanded(
              child: SkillDictionaryList(
                selectedSkill: selectedSkill,
                onSkillSelected: selectSkill,
              ),
            ),
            // Container(color: Colors.amber),
            // Expanded(child: Container(color: Colors.blueAccent)),
            Expanded(child: EditSkillView(skillDefinition: selectedSkill)),
          ],
        ),
      ),
    );
  }
}

class SkillDictionaryList extends StatelessWidget {
  const SkillDictionaryList({
    super.key,
    required this.selectedSkill,
    required this.onSkillSelected,
  });

  final SkillDefinition selectedSkill;
  final void Function(SkillDefinition) onSkillSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // padding: EdgeInsets.symmetric(horizontal: 10),
          // margin: EdgeInsets.symmetric(vertical: 5),
          width: double.infinity,
          color: Colors.lightBlueAccent,
          child: Text(
            "Skills List",
            textAlign: .center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.white,
            ),
          ),
        ),
        Expanded(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(overscroll: false),
            child: ListView(
              children: [
                ...ProgressionTreeManager.insance.initializedSkillDefinitions
                    .map(
                      (skillDefinition) => SkillDefinitionEntry(
                        skillDefinition: skillDefinition,
                        isSelected: skillDefinition == selectedSkill,

                        onTap: () {
                          onSkillSelected(skillDefinition);
                        },
                      ),
                    ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SkillDefinitionEntry extends StatelessWidget {
  const SkillDefinitionEntry({
    super.key,
    required this.skillDefinition,
    required this.isSelected,
    required this.onTap,
  });

  final SkillDefinition skillDefinition;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          color: isSelected ? Colors.blueAccent : Colors.white,
        ),
        child: InkWell(
          splashColor: Colors.blue.withValues(alpha: 0.3),
          highlightColor: Colors.blue.withValues(alpha: 0.1),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 5),
            child: Text(
              skillDefinition.displayName,
              style: TextStyle(
                color: Colors.black,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EditSkillView extends StatefulWidget {
  EditSkillView({super.key, required this.skillDefinition})
    : skillInfo = SkillInfo(skillId: skillDefinition.id);

  final SkillDefinition skillDefinition;
  final SkillInfo skillInfo;

  @override
  State<EditSkillView> createState() => _EditSkillViewState();
}

class _EditSkillViewState extends State<EditSkillView> {
  final TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: ListView(
          children: [
            titleText(),
            Container(
              // margin: EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),

              child: TextField(
                controller: descriptionController,
                minLines: 6,
                maxLines: null,

                style: const TextStyle(fontSize: 16, height: 1.5),

                decoration: const InputDecoration(
                  hintText: "Skill description...",
                  border: InputBorder.none,
                  isCollapsed: true,
                ),
              ),
            ),
            saveChangesButton(),
          ],
        ),
      ),
    );
  }

  Widget titleText() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          widget.skillDefinition.displayName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget saveChangesButton() {
    return Container(
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
            onTap: null,
            child: SizedBox(
              height: 50,
              child: Center(
                child: AutoSizeText(
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
    );
  }
}
