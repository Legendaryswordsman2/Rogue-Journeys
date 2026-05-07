import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rogue_journeys/data_objects/student_info.dart';

class ProgressionTreeTemplateManager {
  ProgressionTreeTemplateManager._internal();

  static final ProgressionTreeTemplateManager insance =
      ProgressionTreeTemplateManager._internal();

  ProgressionTreeDefinition? _cache;
  bool _loading = false;
  // Future<void>? _loadTask;

  Future<void> loadProgressionTree() async {
    if (_cache != null || _loading) return;

    _loading = true;

    try {
      final jsonString = await rootBundle.loadString(
        "assets/data/progression_tree_template.json",
      );

      final jsonData = jsonDecode(jsonString);

      _cache = ProgressionTreeDefinition.fromJson(jsonData);
    } catch (e, stackTrace) {
      debugPrint("Failed to load Porgression Tree: $e");
      debugPrint("STACK TRACE: $stackTrace");

      _cache = null;
    } finally {
      _loading = false;
    }

    debugPrint("State: $_cache");

    // debugPrint(
    //   "Skill Card Tracks Loaded: ${_cache!.progressionTrackDefinitions.length}",
    // );
  }

  ProgressionTreeDefinition get progressionTree {
    if (_cache == null) {
      throw Exception("Progression Tree not loaded");
    }
    return _cache!;
  }
}

// Represents a list of all Skill Card Tracks.
class ProgressionTreeDefinition {
  ProgressionNodeDefinition coreRoot;
  List<ProgressionNodeDefinition> sideRoots;

  ProgressionTreeDefinition({required this.coreRoot, required this.sideRoots});

  factory ProgressionTreeDefinition.fromJson(Map<String, dynamic> json) {
    final coreRootJson = json['coreRoot'] as Map<String, dynamic>? ?? {};

    return ProgressionTreeDefinition(
      coreRoot: ProgressionNodeDefinition(
        skillCardDefinition: SkillCardDefinition.fromJson(
          coreRootJson['skillCard'],
        ),
        next: (json["next"] as List? ?? [])
            .map((e) => ProgressionNodeDefinition.fromJson(e))
            .toList(),
      ),
      sideRoots: (json["sideRoots"] as List? ?? [])
          .map((e) => ProgressionNodeDefinition.fromJson(e))
          .toList(),
    );
  }
}

// References a Skill Card Definition and contains the next Progression Nodes to be unlocked once the Skill Card has been completed.
class ProgressionNodeDefinition {
  SkillCardDefinition skillCardDefinition;
  List<ProgressionNodeDefinition> next;

  ProgressionNodeDefinition({
    required this.skillCardDefinition,
    required this.next,
  });

  factory ProgressionNodeDefinition.fromJson(Map<String, dynamic> json) {
    return ProgressionNodeDefinition(
      skillCardDefinition: SkillCardDefinition.fromJson(json['skillCard']),
      next: (json["next"] as List? ?? [])
          .map((e) => ProgressionNodeDefinition.fromJson(e))
          .toList(),
    );
  }
}

// Represents a list of skill categories contained in the Skill Card.
class SkillCardDefinition {
  String id;
  String displayName;
  List<SkillCategoryDefinition> skillCategoryDefinitions;

  SkillCardDefinition({
    required this.id,
    required this.displayName,
    required this.skillCategoryDefinitions,
  });

  factory SkillCardDefinition.fromJson(Map<String, dynamic> json) {
    return SkillCardDefinition(
      id: json["id"],
      displayName: json["displayName"],
      skillCategoryDefinitions: (json["skillCategories"] as List? ?? [])
          .map((e) => SkillCategoryDefinition.fromJson(e))
          .toList(),
    );
  }
}

// Represents a list of skills inside a category (e.g. Floor, Vaults, Walls, Bars, Precisions).
class SkillCategoryDefinition {
  String id;
  String displayName;
  Color color;
  List<SkillDefinition> skillDefinitions;

  SkillCategoryDefinition({
    required this.id,
    required this.displayName,
    required this.color,
    required this.skillDefinitions,
  });

  factory SkillCategoryDefinition.fromJson(Map<String, dynamic> json) {
    return SkillCategoryDefinition(
      id: json["id"],
      displayName: json["displayName"],
      color: parseColor(json['color']),
      skillDefinitions: (json["skills"] as List? ?? [])
          .map((e) => SkillDefinition.fromJson(e))
          .toList(),
    );
  }

  int skillsCompleted(ProgressionState progression) {
    int completedAmount = 0;

    skillDefinitions.forEach((skillDefinition) {
      if (progression.getSkillState(skillDefinition.id).completed) {
        completedAmount++;
      }
    });

    return completedAmount;
  }

  static Color parseColor(dynamic value) {
    try {
      if (value == null || value.isEmpty) return Colors.white;

      // Case 1: already an int (e.g. 0xFFFFCE00 stored as number)
      if (value is int) {
        return Color(value);
      }

      // Case 2: string input
      if (value is String) {
        String v = value.trim();

        // Handle "0xFFFFCE00"
        if (v.startsWith('0x')) {
          return Color(int.parse(v));
        }

        // Handle "#RRGGBB" or "#AARRGGBB"
        v = v.replaceAll('#', '');

        if (v.length == 6) {
          v = 'FF$v'; // assume full opacity
        }

        if (v.length == 8) {
          return Color(int.parse(v, radix: 16));
        }
      }

      return Colors.white;
    } catch (e) {
      debugPrint("$e");
      return Colors.white;
    }
  }
}

// Represents a single skill inside a Skill Card.
class SkillDefinition {
  String id;
  String displayName;

  SkillDefinition({required this.id, required this.displayName});

  factory SkillDefinition.fromJson(Map<String, dynamic> json) {
    return SkillDefinition(id: json["id"], displayName: json["displayName"]);
  }
}
