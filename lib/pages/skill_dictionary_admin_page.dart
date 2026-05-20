import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rogue_journeys/main.dart';
import 'package:rogue_journeys/managers/progression_tree_manager.dart';
import 'package:rogue_journeys/managers/skill_dictionary_manager.dart';
import 'package:rogue_journeys/widgets/appbar_gradient_widget.dart';
import 'package:rogue_journeys/widgets/editable_list_widget.dart';

class SkillDictionaryAdminPage extends StatefulWidget {
  const SkillDictionaryAdminPage({super.key});

  @override
  State<SkillDictionaryAdminPage> createState() =>
      _SkillDictionaryAdminPageState();
}

class _SkillDictionaryAdminPageState extends State<SkillDictionaryAdminPage> {
  late SkillInfo selectedSkill;

  @override
  void initState() {
    super.initState();

    debugPrint(
      "Skills Count: ${ProgressionTreeManager.instance.initializedSkillDefinitions.length}",
    );

    selectedSkill =
        SkillDictionaryManager.instance.skillDictionary.entries.first.value;
  }

  void selectSkill(SkillInfo skill) {
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
            Expanded(
              child: EditSkillView(
                key: ValueKey(selectedSkill.skillId),
                skillInfo: selectedSkill,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SkillDictionaryList extends StatefulWidget {
  const SkillDictionaryList({
    super.key,
    required this.selectedSkill,
    required this.onSkillSelected,
  });

  final SkillInfo selectedSkill;
  final void Function(SkillInfo) onSkillSelected;

  @override
  State<SkillDictionaryList> createState() => _SkillDictionaryListState();
}

class _SkillDictionaryListState extends State<SkillDictionaryList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            "Skills List",
            textAlign: .center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.white,
            ),
          ),
          tileColor: Colors.lightBlueAccent,
          titleAlignment: ListTileTitleAlignment.center,

          trailing: IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              openAddSkillPopup();
            },
          ),
        ),
        Expanded(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(overscroll: false),
            child: ListView(
              children: [
                ...SkillDictionaryManager.instance.skillDictionary.entries.map(
                  (skillInfo) => SkillInfoEntry(
                    skillInfo: skillInfo.value,
                    isSelected: skillInfo.value == widget.selectedSkill,

                    onTap: () {
                      widget.onSkillSelected(skillInfo.value);
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

  Future<void> openAddSkillPopup() async {
    await showDialog(context: context, builder: (_) => AddSkillPopup());

    setState(() {});
  }
}

class AddSkillPopup extends StatelessWidget {
  AddSkillPopup({super.key});

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: const Text("Add New Skill")),
      content: TextField(autocorrect: true, controller: controller),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),

        TextButton(
          onPressed: () {
            SkillDictionaryManager.instance.addNewSkillToDictionary(
              SkillInfo(skillId: controller.text),
            );
            Navigator.pop(
              context,
              // renameController.text.trim(),
            );
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}

class SkillInfoEntry extends StatelessWidget {
  const SkillInfoEntry({
    super.key,
    required this.skillInfo,
    required this.isSelected,
    required this.onTap,
  });

  final SkillInfo skillInfo;
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
              skillInfo.skillId,
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
  EditSkillView({super.key, required this.skillInfo})
    : skillInfoCopy = SkillInfo.copy(skillInfo);
  final SkillInfo skillInfo;

  final SkillInfo skillInfoCopy;

  @override
  State<EditSkillView> createState() => _EditSkillViewState();
}

class _EditSkillViewState extends State<EditSkillView> {
  final TextEditingController descriptionFieldController =
      TextEditingController();
  final TextEditingController demoVideoFieldController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    descriptionFieldController.text = widget.skillInfoCopy.skillDescription;
    demoVideoFieldController.text = widget.skillInfoCopy.demoVideoLink;
  }

  bool get hasChanges => widget.skillInfo != widget.skillInfoCopy;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: ListView(
          children: [
            titleText(),
            SizedBox(height: 10),
            EditableList(
              title: "Categories",
              initialItems: widget.skillInfoCopy.categories,
              inputBoxHint: "Category...",
              onListChanged: (items) => setState(() {}),
            ),
            SizedBox(height: 20),
            skillDescriptionField(),
            SizedBox(height: 20),
            demoVideoField(),

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
          widget.skillInfo.skillId,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget skillDescriptionField() {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),

      child: Column(
        children: [
          Text(
            "Skill Description",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          TextField(
            onChanged: (value) {
              setState(() {
                widget.skillInfoCopy.skillDescription =
                    descriptionFieldController.text;
              });
            },
            controller: descriptionFieldController,

            minLines: 6,
            maxLines: null,

            style: const TextStyle(fontSize: 16, height: 1.5),

            decoration: const InputDecoration(
              hintText: "Skill description...",
              border: InputBorder.none,
              isCollapsed: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget demoVideoField() {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),

      child: Column(
        children: [
          Text(
            "Demo Video YT Link",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          TextField(
            onChanged: (value) {
              setState(() {
                widget.skillInfoCopy.demoVideoLink =
                    demoVideoFieldController.text;
              });
            },
            controller: demoVideoFieldController,

            minLines: 1,

            // maxLines: null,
            style: const TextStyle(fontSize: 16, height: 1.5),

            decoration: const InputDecoration(
              hintText: "YouTube Link...",
              border: InputBorder.none,
              isCollapsed: true,
            ),
          ),
        ],
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
            gradient: hasChanges
                ? const LinearGradient(
                    colors: [Colors.lightBlue, Colors.blueAccent],
                  )
                : null,
            border: Border.all(color: Colors.white10),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: hasChanges
                ? () {
                    setState(() {
                      widget.skillInfo.copyFrom(widget.skillInfoCopy);
                      widget.skillInfo.saveToDatabase();
                    });
                  }
                : null,
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
