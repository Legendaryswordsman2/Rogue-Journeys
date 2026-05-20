import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';

class SkillDictionaryManager {
  static final SkillDictionaryManager instance = SkillDictionaryManager();

  // Skill ID/ Skill Info
  Map<String, SkillInfo>? _skillDictionary;

  Map<String, SkillInfo> get skillDictionary {
    if (_skillDictionary == null) {
      throw Exception("Skill Dictionary not loaded");
    }
    return _skillDictionary!;
  }

  bool _loading = false;
  Future<void> loadSkillDictionary() async {
    if (_skillDictionary != null || _loading) return;

    _loading = true;

    final collection = await FirebaseFirestore.instance
        .collection("Skill Dictionary")
        .get();

    _skillDictionary = .new();

    for (var doc in collection.docs) {
      _skillDictionary![doc.id] = SkillInfo.fromMap(doc.id, doc.data());
    }

    _loading = false;
  }

  CategoryNode? _skillDictionaryTreeRoot;

  CategoryNode get skillDictionaryTreeRoot {
    if (_skillDictionaryTreeRoot != null) return _skillDictionaryTreeRoot!;

    return buildTree(_skillDictionary!.values.toList());
  }

  CategoryNode buildTree(List<SkillInfo> skills) {
    debugPrint("BUILDING SKILL DICTIONARY TREE!");
    final root = CategoryNode("root");

    for (final skill in skills) {
      for (final path in skill.categories) {
        final parts = path.split('/');

        CategoryNode current = root;

        for (final part in parts) {
          current.childrenCategories.putIfAbsent(
            part,
            () => CategoryNode(part),
          );

          current = current.childrenCategories[part]!;
        }

        current.skills.add(skill);
      }
    }

    _skillDictionaryTreeRoot = root;
    return root;
  }

  void addNewSkillToDictionary(SkillInfo skillInfo) {
    skillDictionary[skillInfo.skillId] = skillInfo;
    skillInfo.saveToDatabase();
  }
}

class SkillInfo {
  String skillId;
  String skillDescription;
  String demoVideoLink;
  List<String> categories;

  SkillInfo({
    required this.skillId,
    this.skillDescription = "",
    this.demoVideoLink = "",
    List<String>? categories,
  }) : categories = categories ?? [];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SkillInfo &&
        other.skillId == skillId &&
        other.skillDescription == skillDescription &&
        other.demoVideoLink == demoVideoLink &&
        ListEquality().equals(other.categories, categories);
  }

  @override
  int get hashCode {
    return Object.hash(
      skillId,
      skillDescription,
      demoVideoLink,
      ListEquality().hash(categories),
    );
  }

  factory SkillInfo.fromMap(String id, Map<String, dynamic> map) {
    return SkillInfo(
      skillId: id,
      skillDescription: map["skillDescription"] ?? "",
      demoVideoLink: map['demoVideoLink'] ?? "",
      categories: List<String>.from(map["categories"] ?? []),
    );
  }

  factory SkillInfo.copy(SkillInfo skillInfo) {
    return SkillInfo(
      skillId: skillInfo.skillId,
      skillDescription: skillInfo.skillDescription,
      demoVideoLink: skillInfo.demoVideoLink,
      categories: List<String>.from(skillInfo.categories),
    );
  }

  void copyFrom(SkillInfo skillInfo) {
    skillId = skillInfo.skillId;
    skillDescription = skillInfo.skillDescription;
    demoVideoLink = skillInfo.demoVideoLink;
    categories = List<String>.from(skillInfo.categories);
  }

  Map<String, dynamic> toMap() {
    return {
      "skillId": skillId,
      "skillDescription": skillDescription,
      'demoVideoLink': demoVideoLink,
      "categories": categories,
    };
  }

  void saveToDatabase() {
    FirebaseFirestore.instance
        .collection("Skill Dictionary")
        .doc(skillId)
        .set(toMap());
  }
}

class CategoryNode {
  final String name;

  final Map<String, CategoryNode> childrenCategories = {};

  final List<SkillInfo> skills = [];

  CategoryNode(this.name);
}
