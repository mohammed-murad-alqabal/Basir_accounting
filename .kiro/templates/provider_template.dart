import 'package:riverpod_annotation/riverpod_annotation.dart';

part '{{FILE_NAME}}.g.dart';

/// {{PROVIDER_NAME}} Provider
/// 
/// {{DESCRIPTION}}
/// 
/// **Feature:** {{FEATURE_NAME}}
/// **Created:** {{DATE}}
@riverpod
class {{PROVIDER_NAME}} extends _${{PROVIDER_NAME}} {
  @override
  Future<{{RETURN_TYPE}}> build() async {
    // TODO: Implement provider logic
    throw UnimplementedError();
  }

  /// {{METHOD_DESCRIPTION}}
  Future<void> {{METHOD_NAME}}({{PARAMETERS}}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // TODO: Implement method logic
      throw UnimplementedError();
    });
  }
}
