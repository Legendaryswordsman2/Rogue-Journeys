import 'package:cloud_firestore/cloud_firestore.dart';

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

  void addNewSkillToDictionary(SkillInfo skillInfo) {
    skillDictionary[skillInfo.skillId] = skillInfo;
    skillInfo.saveToDatabase();
  }

  // void addOrUpdateSkillInfo(SkillInfo skillInfo) {
  //   if (skillInfos.any((info) => info.skillId == skillInfo.skillId)) {

  //   }
  // }
}

class SkillInfo {
  String skillId;
  String skillDescription;
  List<String> categories;

  SkillInfo({
    required this.skillId,
    this.skillDescription = "",
    List<String>? categories,
  }) : categories = categories ?? [];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SkillInfo &&
        other.skillId == skillId &&
        other.skillDescription == skillDescription &&
        ListEquality().equals(other.categories, categories);
  }

  @override
  int get hashCode {
    return Object.hash(
      skillId,
      skillDescription,
      ListEquality().hash(categories),
    );
  }

  factory SkillInfo.fromMap(String id, Map<String, dynamic> map) {
    return SkillInfo(
      skillId: id,
      skillDescription: map["skillDescription"] ?? "",
      categories: List<String>.from(map["categories"] ?? []),
    );
  }

  factory SkillInfo.copy(SkillInfo skillInfo) {
    return SkillInfo(
      skillId: skillInfo.skillId,
      skillDescription: skillInfo.skillDescription,
      categories: List<String>.from(skillInfo.categories),
    );
  }

  void copyFrom(SkillInfo skillInfo) {
    skillId = skillInfo.skillId;
    skillDescription = skillInfo.skillDescription;
    categories = List<String>.from(skillInfo.categories);
  }

  Map<String, dynamic> toMap() {
    return {
      "skillId": skillId,
      "skillDescription": skillDescription,
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
