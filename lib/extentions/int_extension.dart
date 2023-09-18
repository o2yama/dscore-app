extension IntEx on int {
  String get techGroupLabel {
    switch (this) {
      case 1:
        return 'Ⅰ';
      case 2:
        return 'Ⅱ';
      case 3:
        return 'Ⅲ';
      case 4:
        return 'Ⅳ';
      default:
        return '';
    }
  }
}
