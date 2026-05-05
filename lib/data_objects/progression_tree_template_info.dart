import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        "assets/data/progression_tree.json",
      );

      final jsonData = jsonDecode(jsonString);

      _cache = ProgressionTreeDefinition.fromJson(jsonData);
    } catch (e, stackTrace) {
      debugPrint("Failed to load Porgression Tree: $e");
      debugPrint("$stackTrace");

      _cache = ProgressionTreeDefinition(progressionTrackDefinitions: []);
    } finally {
      _loading = false;
    }

    debugPrint(
      "Skill Card Tracks Loaded: ${_cache!.progressionTrackDefinitions.length}",
    );

    if (_cache!.progressionTrackDefinitions[0].skillCardDefinitions.isNotEmpty) {
      debugPrint(
        "Skill Cards Loaded in Track 1: ${_cache!.progressionTrackDefinitions[0].skillCardDefinitions.length}",
      );

      if (_cache!
          .progressionTrackDefinitions[0]
          .skillCardDefinitions[0]
          .skillCategoryDefinitions
          .isNotEmpty) {
        debugPrint(
          "Skill Categories Loaded in Skill Card Core LVL 1: ${_cache!.progressionTrackDefinitions[0].skillCardDefinitions[0].skillCategoryDefinitions.length}",
        );

        if (_cache!
            .progressionTrackDefinitions[0]
            .skillCardDefinitions[0]
            .skillCategoryDefinitions[0]
            .skillDefinitions
            .isNotEmpty) {
          debugPrint(
            "Skills Loaded in Skill Category in Skill Card Core LVL 1: ${_cache!.progressionTrackDefinitions[0].skillCardDefinitions[0].skillCategoryDefinitions[0].skillDefinitions.length}",
          );
          debugPrint(
            _cache!
                .progressionTrackDefinitions[0]
                .skillCardDefinitions[0]
                .skillCategoryDefinitions[0]
                .skillDefinitions[0]
                .displayName,
          );
        }
      }
    }
  }

  ProgressionTreeDefinition get progressionTree {
    if (_cache == null) {
      throw Exception("Progression Tree not loaded yet");
    }
    return _cache!;
  }
}

// Represents a list of all Skill Card Tracks.
class ProgressionTreeDefinition {
  List<ProgressionTrackDefinition> progressionTrackDefinitions;

  ProgressionTreeDefinition({required this.progressionTrackDefinitions});

  factory ProgressionTreeDefinition.fromJson(Map<String, dynamic> json) {
    return ProgressionTreeDefinition(
      progressionTrackDefinitions: (json["skillCardTracks"] as List? ?? [])
          .map((e) => ProgressionTrackDefinition.fromJson(e))
          .toList(),
    );
  }
}

// Represents a list of skill cards to work through in a single track (e.g. Core lvl 1-6, tricking lvl 1-5).
class ProgressionTrackDefinition {
  String id;
  String displayName;
  List<SkillCardDefinition> skillCardDefinitions;

  ProgressionTrackDefinition({
    required this.id,
    required this.displayName,
    required this.skillCardDefinitions,
  });

  factory ProgressionTrackDefinition.fromJson(Map<String, dynamic> json) {
    return ProgressionTrackDefinition(
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
  List<SkillCategoryDefinition> skillCategoryDefinitions;

  SkillCardDefinition({
    required this.id,
    required this.displayName,
    required this.skillCategoryDefinitions,
  });

  factory SkillCardDefinition.fromJson(Map<String, dynamic> json) {
    return SkillCardDefinition(
      id: json["id"],
      displayName: json["displayName"] ?? json["name"],
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

  factory SkillCategoryDefinition.fromJson(
    Map<String, dynamic> json,
  ) {
    return SkillCategoryDefinition(
      id: json["id"],
      displayName: json["displayName"],
      color: parseColor(json['color']),
      skillDefinitions: (json["skills"] as List)
          .map((e) => SkillDefinition.fromJson(e))
          .toList(),
    );
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
    return SkillDefinition(
      id: json["id"],
      displayName: json["displayName"],
    );
  }
}
