class PbRule {
  static const Map<String, String> integrates = {
    '移行': '逆移行',
  };

  static String? validTech(List<String> techList, String incomingTech) {
    if (techList.contains(incomingTech)) {
      return '同じ技が登録されています。';
    }

    for (var tech in integrates.keys) {
      if (techList.contains(tech) && integrates[tech] == incomingTech) {
        return '「$tech」と同枠の技のため登録できません。';
      } else if (techList.contains(integrates[tech]) && tech == incomingTech) {
        return '「${integrates[tech]}」と同枠の技のため登録できません。';
      }
    }
  }
}
