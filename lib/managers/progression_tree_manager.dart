import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:rogue_journeys/data_objects/progression_tree_definitions.dart';

class ProgressionTreeManager {
  ProgressionTreeManager._internal();

  static final ProgressionTreeManager instance =
      ProgressionTreeManager._internal();

  ProgressionTreeDefinition? _cache;
  bool _loading = false;

  List<SkillDefinition> initializedSkillDefinitions = [];

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
  }

  ProgressionTreeDefinition get progressionTree {
    if (_cache == null) {
      throw Exception("Progression Tree not loaded");
    }
    return _cache!;
  }
}
