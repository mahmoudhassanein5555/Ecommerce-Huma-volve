class ErrorModel {
  final int statusCode;
  final String message;
  final String? code;
  final List<String> generalErrors;
  final Map<String, List<String>> fieldErrors;

  ErrorModel({
    required this.statusCode,
    required this.message,
    this.code,
    required this.generalErrors,
    this.fieldErrors = const {},
  });

  factory ErrorModel.fromJson(Map<String, dynamic> jsonData) {
    final String mainMessage = jsonData['message'] ?? 'An error occurred';
    final extractedErrors = <String>[];
    final extractedFieldErrors = <String, List<String>>{};

    if (jsonData['errors'] != null) {
      if (jsonData['errors'] is Map) {
        final errors = jsonData['errors'] as Map<String, dynamic>;

        if (errors['generalErrors'] != null &&
            errors['generalErrors'] is List) {
          extractedErrors.addAll(
            List<String>.from(errors['generalErrors'] as List),
          );
        } else {
          for (var entry in errors.entries) {
            if (entry.value is List && (entry.value as List).isNotEmpty) {
              final values = List<String>.from(entry.value as List);
              extractedErrors.addAll(values);
              extractedFieldErrors[entry.key] = values;
            } else if (entry.value is String) {
              final value = entry.value as String;
              extractedErrors.add(value);
              extractedFieldErrors[entry.key] = [value];
            }
          }
        }
      } else if (jsonData['errors'] is String) {
        extractedErrors.add(jsonData['errors'] as String);
      }
    }

    if (extractedErrors.isEmpty && mainMessage != 'An error occurred') {
      extractedErrors.add(mainMessage);
    }

    return ErrorModel(
      statusCode: jsonData["statusCode"] ?? 0,
      message: mainMessage,
      code: jsonData['code'] as String?,
      generalErrors: extractedErrors,
      fieldErrors: extractedFieldErrors,
    );
  }

  /// هترجع أول خطأ تفصيلي، لو مفيش هترجع الرسالة العامة
  String get errorMessage {
    if (generalErrors.isNotEmpty) {
      return generalErrors.first;
    }

    return message;
  }
}
