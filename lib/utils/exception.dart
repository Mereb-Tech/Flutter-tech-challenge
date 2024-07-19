class CustomException implements Exception {
  String message;
  CustomException({required this.message});

  @override
  String toString() {
    return message;
  }
}



String capitalizeFirstLetter(String input) {
  if (input.isEmpty) {
    return input;
  }
  return input[0].toUpperCase() + input.substring(1).toLowerCase();
}
