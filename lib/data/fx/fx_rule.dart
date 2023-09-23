class FxRule {
  static const Map<String, String> integrates = {
    '前方伸身半分ひねり': '前方伸身宙返り',
    '前方抱え込みダブル': '前方抱え込みダブルハーフ',
    '前方屈伸ダブル': '前方屈伸ダブルハーフ',
    '前方伸身1回ひねり': '前方1回半ひねり',
    '後方伸身宙返り': 'テンポ宙返り',
    '後方伸身半分ひねり': '後方伸身1回ひねり',
    '後方1回半ひねり': '後方2回ひねり',
  };

  static String? validTech(List<String> techList, String incomingTech) {
    if (techList.contains(incomingTech)) {
      return '同じ技が登録されています。';
    }

    for (var tech in integrates.keys) {
      if (techList.contains(tech) && integrates[tech] == incomingTech) {
        return '「$tech」\nと同枠の技のため登録できません。';
      } else if (techList.contains(integrates[tech]) && tech == incomingTech) {
        return '「${integrates[tech]}」\nと同枠の技のため登録できません。';
      }
    }
    return null;
  }
}
