Map<String, String> splitAircraftName(String text) {
  final startIndex = text.lastIndexOf('(');
  final endIndex = text.lastIndexOf(')');

  if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
    return {
      "title": text.substring(0, startIndex).trim(),
      "code": text.substring(startIndex, endIndex + 1).trim(),
    };
  }

  return {
    "title": text,
    "code": "",
  };
}