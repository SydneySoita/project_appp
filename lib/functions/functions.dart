class Functions {
  static String capitalizeString(String text) {
    String toReturn = "";
    if (text != null || text.isNotEmpty) {
      toReturn = "${text[0].toUpperCase()}${text.substring(1)}";
    }
    return toReturn;
  }

  static String shortText(String text, int length) {
    if(text.length > length){
      return text.substring(0, length-3) + "...";
    }
    return text;
  }

  static String stripSizeOff(String text) {
    var lowerText = text.toLowerCase();
    if (lowerText != "medium" || lowerText != "small" || lowerText != "large") {
      if (text.endsWith("kg")) {
        return text.substring(0, text.length - 2);
      }
      if (text.endsWith("l")) {
        return text.substring(0, text.length - 1);
      }
    }
    return text;
  }

  static String titleCase(String text) {
    if (text.length <= 1) return text.toUpperCase();
    var words = text.split(' ');
    var capitalized = words.map((word) {
      var first = word.substring(0, 1).toUpperCase();
      var rest = word.substring(1);
      return '$first$rest';
    });
    return capitalized.join(' ');
  }

  static String upperCase(String text) {
    if (text.length <= 1) return text.toUpperCase();
    var words = text.split('');
    var capitalized = words.map((word) {
      var first = word.substring(0, 1).toUpperCase();
      var rest = word.substring(1);
      return '$first$rest';
    });
    return capitalized.join('');
  }
}
