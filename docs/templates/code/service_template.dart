/// Service template for business logic
///
/// Usage: Replace [Service] with your service name
/// 
/// Example:
/// ```dart
/// class ValidationService {
///   static String? validateEmail(String? value) { ... }
/// }
/// ```

/// [Service] - Business logic service
class [Service] {
  /// Validate input
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field is required';
    }
    return null;
  }

  /// Process data
  static Future<Result> process(Input input) async {
    try {
      // Processing logic
      return Result.success();
    } catch (error) {
      return Result.failure(error.toString());
    }
  }

  /// Transform data
  static Output transform(Input input) {
    // Transformation logic
    return Output();
  }
}

/// Result wrapper
class Result {
  final bool isSuccess;
  final String? error;
  final dynamic data;

  const Result._({
    required this.isSuccess,
    this.error,
    this.data,
  });

  factory Result.success({dynamic data}) {
    return Result._(isSuccess: true, data: data);
  }

  factory Result.failure(String error) {
    return Result._(isSuccess: false, error: error);
  }
}
