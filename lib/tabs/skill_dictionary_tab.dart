import 'package:flutter/material.dart';
import 'package:rogue_journeys/main.dart';
import 'package:rogue_journeys/managers/skill_dictionary_manager.dart';
import 'package:rogue_journeys/widgets/additional_widgets.dart';
import 'package:rogue_journeys/widgets/appbar_gradient_widget.dart';

class SkillDictionaryTab extends StatelessWidget {
  const SkillDictionaryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF202020),
      child: CategoryView(
        categoryNode: SkillDictionaryManager.instance.skillDictionaryTreeRoot,
      ),
    );
  }
}

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key, required this.categoryNode});

  final CategoryNode categoryNode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF202020),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Category: ${categoryNode.name}",
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
      body: CategoryView(categoryNode: categoryNode),
    );
  }
}

class CategoryView extends StatelessWidget {
  const CategoryView({super.key, required this.categoryNode});

  final CategoryNode categoryNode;

  @override
  Widget build(BuildContext context) {
    final childrenCategories = categoryNode.childrenCategories.values.toList();

    final skills = categoryNode.skills;

    final totalItems = childrenCategories.length + skills.length;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 250,
        // crossAxisSpacing: 10,
        // mainAxisSpacing: 10,
        childAspectRatio: 1.1,
      ),
      itemCount: totalItems,
      itemBuilder: (context, index) {
        if (index < childrenCategories.length) {
          return CategoryTile(
            categoryNode: categoryNode.childrenCategories.values.elementAt(
              index,
            ),
          );
        }

        final skillIndex = index - childrenCategories.length;

        final skill = skills[skillIndex];

        return SkillTile(skill: skill);
      },
    );
  }
}

class CategoryTile extends StatelessWidget {
  const CategoryTile({super.key, required this.categoryNode});

  // final String title;
  final CategoryNode categoryNode;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,

      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            FadeRoute(page: CategoryPage(categoryNode: categoryNode)),
          );
        },

        child: Padding(
          padding: const EdgeInsetsGeometry.all(16),

          child: Column(
            mainAxisAlignment: .center,
            children: [
              Icon(Icons.folder, size: 48),
              const SizedBox(height: 12),

              Text(
                categoryNode.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SkillTile extends StatelessWidget {
  const SkillTile({super.key, required this.skill});

  final SkillInfo skill;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,

      child: InkWell(
        onTap: null,

        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: .center,
            children: [
              const Icon(Icons.sports_gymnastics, size: 48),
              const SizedBox(height: 12),

              Text(
                skill.skillId,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 8),

              Text(
                skill.skillDescription,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
