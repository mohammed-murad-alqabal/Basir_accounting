/// Model template for Isar database entities
///
/// Usage: Replace [Entity] with your entity name
/// 
/// Example:
/// ```dart
/// @collection
/// class CustomerModel {
///   Id id = Isar.autoIncrement;
///   @Index()
///   late String name;
///   // ... fields
/// }
/// ```

import 'package:isar/isar.dart';

part '[entity]_model.g.dart';

/// Isar model for [Entity]
@collection
class [Entity]Model {
  /// Auto-increment ID
  Id id = Isar.autoIncrement;

  /// Indexed name field for fast search
  @Index()
  late String name;

  /// Additional fields
  String? description;

  /// Timestamps
  late DateTime createdAt;
  DateTime? updatedAt;

  /// Convert model to entity
  [Entity] toEntity() {
    return [Entity](
      id: id.toString(),
      name: name,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create model from entity
  static [Entity]Model fromEntity([Entity] entity) {
    return [Entity]Model()
      ..id = int.tryParse(entity.id) ?? Isar.autoIncrement
      ..name = entity.name
      ..description = entity.description
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt;
  }
}

/// Domain entity for [Entity]
class [Entity] {
  final String id;
  final String name;
  final String? description;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const [Entity]({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
    this.updatedAt,
  });

  /// Convert entity to model
  [Entity]Model toModel() {
    return [Entity]Model.fromEntity(this);
  }

  /// Copy with method
  [Entity] copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return [Entity](
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
