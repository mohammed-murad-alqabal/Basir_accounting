import 'package:repository_cleaner/domain/entities/file_info.dart';

enum CleanupActionType {
  delete,
  archive,
  ignore,
  keep // Explicitly kept
}

class CleanupAction {
  CleanupAction({
    required this.file,
    required this.actionType,
    required this.reason,
  });
  final FileInfo file;
  final CleanupActionType actionType;
  final String reason;

  @override
  String toString() =>
      '${actionType.name.toUpperCase()}: ${file.path} ($reason)';
}

class CleanupPlan {
  CleanupPlan({
    required this.actions,
    required this.generatedAt,
  });
  final List<CleanupAction> actions;
  final DateTime generatedAt;

  int get totalFilesToDelete =>
      actions.where((a) => a.actionType == CleanupActionType.delete).length;
  int get totalFilesToArchive =>
      actions.where((a) => a.actionType == CleanupActionType.archive).length;

  int get projectedBytesSaved {
    var saved = 0;
    for (final action in actions) {
      if (action.actionType == CleanupActionType.delete) {
        saved += action.file.sizeBytes;
      } else if (action.actionType == CleanupActionType.archive) {
        // Rough estimate: 50% compression for archive
        saved += (action.file.sizeBytes * 0.5).round();
      }
    }
    return saved;
  }
}
