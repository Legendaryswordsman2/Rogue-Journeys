import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProgressionTreeTemplateManager {
  ProgressionTreeTemplateManager._internal();

  static final ProgressionTreeTemplateManager insance =
      ProgressionTreeTemplateManager._internal();

  ProgressionTree? _cache;
  bool _loading = false;
  // Future<void>? _loadTask;

  Future<void> loadProgressionTree() async {
    if (_cache != null || _loading) return;

    _loading = true;

    try {
      final jsonString = await rootBundle.loadString(
        "assets/data/progression_tree.json",
      );

      final jsonData = jsonDecode(jsonString);

      _cache = ProgressionTree.fromJson(jsonData);
    } catch (e, stackTrace) {
      debugPrint("Failed to load Porgression Tree: $e");
      debugPrint("$stackTrace");

      _cache = ProgressionTree(skillCardTracks: []);
    } finally {
      _loading = false;
    }

    debugPrint(
      "Skill Card Tracks Loaded: ${_cache!.skillCardTracks.length}",
    );

    if (_cache!.skillCardTracks[0].skillCardDefinitions.isNotEmpty) {
      debugPrint(
        "Skill Cards Loaded in Track 1: ${_cache!.skillCardTracks[0].skillCardDefinitions.length}",
      );

      if (_cache!
          .skillCardTracks[0]
          .skillCardDefinitions[0]
          .skillCategories
          .isNotEmpty) {
        debugPrint(
          "Skill Categories Loaded in Skill Card Core LVL 1: ${_cache!.skillCardTracks[0].skillCardDefinitions[0].skillCategories.length}",
        );

        if (_cache!
            .skillCardTracks[0]
            .skillCardDefinitions[0]
            .skillCategories[0]
            .skills
            .isNotEmpty) {
          debugPrint(
            "Skills Loaded in Skill Category in Skill Card Core LVL 1: ${_cache!.skillCardTracks[0].skillCardDefinitions[0].skillCategories[0].skills.length}",
          );
          debugPrint(
            _cache!
                .skillCardTracks[0]
                .skillCardDefinitions[0]
                .skillCategories[0]
                .skills[0]
                .displayName,
          );
        }
      }
    }
  }

  ProgressionTree get progressionTree {
    if (_cache == null) {
      throw Exception("Progression Tree not loaded yet");
    }
    return _cache!;
  }
}

// Represents a list of all Skill Card Tracks.
class ProgressionTree {
  List<SkillCardTrack> skillCardTracks;

  ProgressionTree({required this.skillCardTracks});

  factory ProgressionTree.fromJson(Map<String, dynamic> json) {
    return ProgressionTree(
      skillCardTracks: (json["skillCardTracks"] as List? ?? [])
          .map((e) => SkillCardTrack.fromJson(e))
          .toList(),
    );
  }
}

// Represents a list of skill cards to work through in a single track (e.g. Core lvl 1-6, tricking lvl 1-5).
class SkillCardTrack {
  String id;
  String displayName;
  List<SkillCardDefinition> skillCardDefinitions;

  SkillCardTrack({
    required this.id,
    required this.displayName,
    required this.skillCardDefinitions,
  });

  factory SkillCardTrack.fromJson(Map<String, dynamic> json) {
    return SkillCardTrack(
      id: json["id"],
      displayName: json["displayName"],
      skillCardDefinitions: (json["skillCardDefinitions"] as List)
          .map((e) => SkillCardDefinition.fromJson(e))
          .toList(),
    );
  }
}

// Represents a list of skill categories contained in the Skill Card. Once all skills in all categories are complete, the Skill Card is complete.
class SkillCardDefinition {
  String id;
  String displayName;
  List<SkillCategoryDefinition> skillCategories;

  SkillCardDefinition({
    required this.id,
    required this.displayName,
    required this.skillCategories,
  });

  factory SkillCardDefinition.fromJson(Map<String, dynamic> json) {
    return SkillCardDefinition(
      id: json["id"],
      displayName: json["displayName"] ?? json["name"],
      skillCategories: (json["skillCategories"] as List? ?? [])
          .map((e) => SkillCategoryDefinition.fromJson(e))
          .toList(),
    );
  }
}

// Represents a list of skills inside a category (e.g. Floor, Vaults, Walls, Bars, Precisions).
class SkillCategoryDefinition {
  String id;
  String displayName;
  List<SkillDefinition> skills;

  SkillCategoryDefinition({
    required this.id,
    required this.displayName,
    required this.skills,
  });

  factory SkillCategoryDefinition.fromJson(
    Map<String, dynamic> json,
  ) {
    return SkillCategoryDefinition(
      id: json["id"],
      displayName: json["displayName"],
      skills: (json["skills"] as List)
          .map((e) => SkillDefinition.fromJson(e))
          .toList(),
    );
  }
}

// Represents a single skill inside a Skill Card.
class SkillDefinition {
  String id;
  String displayName;

  SkillDefinition({required this.id, required this.displayName});

  factory SkillDefinition.fromJson(Map<String, dynamic> json) {
    return SkillDefinition(
      id: json["id"],
      displayName: json["displayName"],
    );
  }
}
