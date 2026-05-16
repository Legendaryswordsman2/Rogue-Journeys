import 'package:flutter/material.dart';
import 'package:rogue_journeys/data_objects/progression_tree_template_info.dart';
import 'package:rogue_journeys/main.dart';
import 'package:rogue_journeys/widgets/appbar_gradient_widget.dart';

class SkillDictionaryAdminPage extends StatelessWidget {
  const SkillDictionaryAdminPage({super.key});

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
            SkillDictionaryList(),
            // Container(color: Colors.amber),
            // Expanded(child: Container(color: Colors.blueAccent)),
            EditSkillView(
              skillDefinition: ProgressionTreeTemplateManager
                  .insance
                  .initializedSkillDefinitions
                  .first,
            ),
          ],
        ),
      ),
    );
  }
}

class SkillDictionaryList extends StatelessWidget {
  const SkillDictionaryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
        child: ListView(
          children: [
            ...ProgressionTreeTemplateManager
                .insance
                .initializedSkillDefinitions
                .map(
                  (skillDefinition) =>
                      SkillDefinitionEntry(skillDefinition: skillDefinition),
                ),
          ],
        ),
      ),
    );
  }
}

class SkillDefinitionEntry extends StatelessWidget {
  const SkillDefinitionEntry({super.key, required this.skillDefinition});

  final SkillDefinition skillDefinition;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
        border: BoxBorder.all(color: Colors.greenAccent),
        color: Colors.white,
      ),
      child: Text(
        skillDefinition.displayName,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}

class EditSkillView extends StatefulWidget {
  const EditSkillView({super.key, required this.skillDefinition});

  final SkillDefinition skillDefinition;

  @override
  State<EditSkillView> createState() => _EditSkillViewState();
}

class _EditSkillViewState extends State<EditSkillView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
        child: ListView(
          children: [
            Center(child: Text("[Skill Name]")),
            Container(
              margin: EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),

              child: TextField(
                // controller: descriptionController,

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
          ],
        ),
      ),
    );
  }
}
