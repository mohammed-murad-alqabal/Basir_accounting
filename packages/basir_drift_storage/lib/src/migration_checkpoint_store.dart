import 'dart:convert';

import 'package:basir_drift_storage/src/basir_database.dart';
import 'package:drift/drift.dart';

/// حالة استيراد شريحة واحدة من محرك التخزين السابق إلى Drift.
///
/// لا يحمل هذا العقد أي بيانات أعمال أو أسرار؛ هو سجل تقدّم تشخيصي فقط.
class MigrationCheckpoint {
  const MigrationCheckpoint({
    required this.slice,
    required this.sourceCount,
    required this.migratedCount,
    required this.completedAt,
  });

  factory MigrationCheckpoint.fromJson(Map<String, Object?> json) {
    final completedAt = json['completedAt'];
    return MigrationCheckpoint(
      slice: json['slice']! as String,
      sourceCount: json['sourceCount']! as int,
      migratedCount: json['migratedCount']! as int,
      completedAt: completedAt == null
          ? null
          : DateTime.parse(completedAt as String).toUtc(),
    );
  }

  final String slice;
  final int sourceCount;
  final int migratedCount;
  final DateTime? completedAt;

  bool get isComplete => completedAt != null && migratedCount == sourceCount;

  Map<String, Object?> toJson() => {
        'slice': slice,
        'sourceCount': sourceCount,
        'migratedCount': migratedCount,
        'completedAt': completedAt?.toUtc().toIso8601String(),
      };
}

/// واجهة محايدة لاختبار الاستيراد من دون فتح قاعدة Drift فعلية.
abstract interface class MigrationCheckpointStorage {
  Future<MigrationCheckpoint?> read(String slice);

  Future<void> save(MigrationCheckpoint checkpoint);
}

/// استخدام جدول metadata الموجود أصلًا للحفاظ على checkpoints المحلية.
class LocalMetadataMigrationCheckpointStore
    implements MigrationCheckpointStorage {
  LocalMetadataMigrationCheckpointStore(this._database);

  static const _keyPrefix = '<credential-fixture>:';

  final BasirDatabase _database;

  @override
  Future<MigrationCheckpoint?> read(String slice) async {
    final row = await (_database.select(_database.localMetadata)
          ..where((table) => table.key.equals(_keyFor(slice))))
        .getSingleOrNull();
    if (row == null) return null;

    final value = jsonDecode(row.valueJson);
    if (value is! Map<String, Object?>) {
      throw FormatException('Invalid migration checkpoint for $slice.');
    }
    return MigrationCheckpoint.fromJson(value);
  }

  @override
  Future<void> save(MigrationCheckpoint checkpoint) =>
      _database.into(_database.localMetadata).insertOnConflictUpdate(
            LocalMetadataCompanion.insert(
              key: _keyFor(checkpoint.slice),
              valueJson: jsonEncode(checkpoint.toJson()),
              updatedAt: Value(DateTime.now().toUtc()),
            ),
          );

  static String _keyFor(String slice) => '$_keyPrefix$slice';
}
