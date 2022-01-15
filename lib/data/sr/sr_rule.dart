class SrRule {
  static String? validTech(List<String> techList, String incomingTech) {
    if (techList.contains(incomingTech)) {
      return '同じ技が登録されています。';
    }
  }
}
