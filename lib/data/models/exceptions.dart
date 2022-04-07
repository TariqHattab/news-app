class CustomException implements Exception {
  String massage;
  CustomException(this.massage);

  @override
  String toString() {
    return massage;
  }
}

class CustomNetworkException extends CustomException {
  CustomNetworkException({required String massage}) : super(massage);
}
