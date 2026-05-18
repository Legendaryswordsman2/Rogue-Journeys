class SkillDictionaryManager {
  static final SkillDictionaryManager insance = SkillDictionaryManager();

  // Skill ID/ Skill Info
  Map<String, SkillInfo>? skillInfoMap;

  // void addOrUpdateSkillInfo(SkillInfo skillInfo) {
  //   if (skillInfos.any((info) => info.skillId == skillInfo.skillId)) {

  //   }
  // }
}

class SkillInfo {
  final String skillId;
  final String skillDescription;

  const SkillInfo({required this.skillId, this.skillDescription = ""});
}
