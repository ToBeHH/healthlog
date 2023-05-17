class StringHelpers {
  static String removeHTML(String input) {
    return input
        .replaceAll("&nbsp;", " ")
        .replaceAll("</p>", "\n\n")
        .replaceAll("<br/>", "\n")
        .replaceAll(RegExp("<[^>]*>"), "");
  }
}
