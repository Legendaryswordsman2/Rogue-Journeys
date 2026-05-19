import 'package:cloud_firestore/cloud_firestore.dart';

class SkillDictionaryManager {
  static final SkillDictionaryManager insance = SkillDictionaryManager();

  // Skill ID/ Skill Info
  Map<String, SkillInfo>? skillDictionary;
  bool _loading = false;

  Future<void> loadSkillDictionary() async {
    if (skillDictionary != null || _loading) return;

    _loading = true;

    final collection = await FirebaseFirestore.instance
        .collection("Skill Dictionary")
        .get();

    skillDictionary = .new();

    for (var doc in collection.docs) {
      skillDictionary![doc.id] = SkillInfo.fromMap(doc.id, doc.data());
    }

    _loading = false;
  }

  // void addOrUpdateSkillInfo(SkillInfo skillInfo) {
  //   if (skillInfos.any((info) => info.skillId == skillInfo.skillId)) {

  //   }
  // }
}

class SkillInfo {
  final String skillId;
  String skillDescription;

  SkillInfo({required this.skillId, this.skillDescription = ""});

  factory SkillInfo.fromMap(String id, Map<String, dynamic> map) {
    return SkillInfo(
      skillId: id,
      skillDescription: map["skillDescription"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {"skillId": skillId, "skillDescription": skillDescription};
  }
}
