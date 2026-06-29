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

void printFullText(String text) {
  const int chunkSize = 800;
  for (int i = 0; i < text.length; i += chunkSize) {
    int end = (i + chunkSize < text.length) ? i + chunkSize : text.length;
    print(text.substring(i, end));
  }
}
