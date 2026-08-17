import 'dart:convert';

/// نوع حركة يسمح به parser، مع إبقاء transfer محجوبًا في clean fixtures.
enum StockMovementGoldenType {
  inbound,
  outbound,
  transfer,
  adjustment,
}

/// سجل حركة اصطناعي معقم للاختبار؛ لا يرتبط بكيان Isar أو Drift.
class StockMovementGoldenRecord {
  const StockMovementGoldenRecord({
    required this.id,
    required this.itemId,
    required this.warehouseId,
    required this.type,
    required this.quantity,
    required this.unitCost,
    required this.date,
    required this.createdAt,
    required this.referenceId,
    required this.description,
    required this.userId,
    required this.syncStatus,
  });

  final String id;
  final String itemId;
  final String? warehouseId;
  final StockMovementGoldenType type;
  final double quantity;
  final double unitCost;
  final DateTime date;
  final DateTime createdAt;
  final String referenceId;
  final String description;
  final String userId;
  final String syncStatus;
}

class StockMovementGoldenExpectedBalance {
  const StockMovementGoldenExpectedBalance({
    required this.asOfDate,
    required this.warehouseId,
    required this.quantity,
    this.userId,
  });

  final DateTime asOfDate;
  final String warehouseId;
  final double quantity;
  final String? userId;
}

class StockMovementGoldenBlockedFixture {
  const StockMovementGoldenBlockedFixture({
    required this.id,
    required this.reason,
    required this.expectedOutcome,
  });

  final String id;
  final String reason;
  final String expectedOutcome;
}

/// حالة golden واحدة للصنف والمستخدم ونتائج الرصيد المتوقعة.
class StockMovementGoldenFixture {
  const StockMovementGoldenFixture({
    required this.id,
    required this.userId,
    required this.itemId,
    required this.warehouseId,
    required this.movements,
    required this.expectedBalances,
    required this.expectedReferenceCounts,
  });

  factory StockMovementGoldenFixture.fromJson(Map<String, Object?> json) {
    final fixture = StockMovementGoldenFixture(
      id: _requiredString(json, 'id'),
      userId: _requiredString(json, 'userId'),
      itemId: _requiredString(json, 'itemId'),
      warehouseId: _requiredString(json, 'warehouseId'),
      movements: _readList(
        json['movements'],
        _stockMovementGoldenRecordFromJson,
      ),
      expectedBalances: _readList(
        json['expectedBalances'],
        _stockMovementGoldenExpectedBalanceFromJson,
      ),
      expectedReferenceCounts: _readReferenceCounts(
        json['expectedReferenceCounts'],
      ),
    );
    fixture._validateCleanContract();
    return fixture;
  }

  final String id;
  final String userId;
  final String itemId;
  final String warehouseId;
  final List<StockMovementGoldenRecord> movements;
  final List<StockMovementGoldenExpectedBalance> expectedBalances;
  final Map<String, int> expectedReferenceCounts;

  void _validateCleanContract() {
    if (movements.isEmpty || expectedBalances.isEmpty) {
      throw FormatException('Fixture $id must contain movements and balances.');
    }
    final movementIds = <String>{};
    for (final movement in movements) {
      if (!movementIds.add(movement.id)) {
        throw FormatException('Fixture $id contains duplicate movement IDs.');
      }
      if (movement.itemId != itemId) {
        throw FormatException(
          'Fixture $id contains a movement for another item.',
        );
      }
      if (movement.type == StockMovementGoldenType.transfer) {
        throw FormatException(
          'Fixture $id contains blocked standalone transfer type.',
        );
      }
      if (movement.type == StockMovementGoldenType.adjustment &&
          movement.quantity <= 0) {
        throw FormatException(
          'Fixture $id contains a signed adjustment before contract approval.',
        );
      }
    }
  }
}

StockMovementGoldenRecord _stockMovementGoldenRecordFromJson(
  Map<String, Object?> json,
) =>
    StockMovementGoldenRecord(
      id: _requiredString(json, 'id'),
      itemId: _requiredString(json, 'itemId'),
      warehouseId: _optionalString(json, 'warehouseId'),
      type: _movementType(_requiredString(json, 'type')),
      quantity: _requiredPositiveFiniteNumber(json, 'quantity'),
      unitCost: _requiredFiniteNumber(json, 'unitCost'),
      date: _requiredUtcDate(json, 'date'),
      createdAt: _requiredUtcDate(json, 'createdAt'),
      referenceId: _requiredString(json, 'referenceId'),
      description: _requiredString(json, 'description'),
      userId: _requiredString(json, 'userId'),
      syncStatus: _requiredSyncStatus(json, 'syncStatus'),
    );

StockMovementGoldenExpectedBalance _stockMovementGoldenExpectedBalanceFromJson(
  Map<String, Object?> json,
) =>
    StockMovementGoldenExpectedBalance(
      asOfDate: _requiredUtcDate(json, 'asOfDate'),
      warehouseId: _requiredString(json, 'warehouseId'),
      quantity: _requiredFiniteNumber(json, 'quantity'),
      userId: _optionalString(json, 'userId'),
    );

/// كتالوج كامل: clean fixtures قابلة للتشغيل وحالات blocked قابلة للتصنيف.
class StockMovementGoldenCatalog {
  const StockMovementGoldenCatalog({
    required this.fixtureVersion,
    required this.cleanFixtures,
    required this.blockedFixtures,
  });

  factory StockMovementGoldenCatalog.fromJsonString(String source) {
    final decoded = jsonDecode(source);
    return StockMovementGoldenCatalog.fromJson(_asMap(decoded));
  }

  factory StockMovementGoldenCatalog.fromJson(Map<String, Object?> json) {
    if (json['sanitized'] != true) {
      throw const FormatException(
        'Golden fixtures must explicitly be sanitized.',
      );
    }
    final version = json['fixtureVersion'];
    if (version != 1) {
      throw FormatException('Unsupported golden fixture version: $version.');
    }
    return StockMovementGoldenCatalog(
      fixtureVersion: 1,
      cleanFixtures: _readList(
        json['cleanFixtures'],
        StockMovementGoldenFixture.fromJson,
      ),
      blockedFixtures: _readList(
        json['blockedFixtures'],
        _stockMovementGoldenBlockedFixtureFromJson,
      ),
    );
  }

  final int fixtureVersion;
  final List<StockMovementGoldenFixture> cleanFixtures;
  final List<StockMovementGoldenBlockedFixture> blockedFixtures;
}

StockMovementGoldenBlockedFixture _stockMovementGoldenBlockedFixtureFromJson(
  Map<String, Object?> json,
) =>
    StockMovementGoldenBlockedFixture(
      id: _requiredString(json, 'id'),
      reason: _requiredString(json, 'reason'),
      expectedOutcome: _requiredString(json, 'expectedOutcome'),
    );

/// Replay مرجعي مستقل عن SQLite/Isar، يستخدم تاريخ الحركة لا createdAt.
class StockMovementGoldenReplay {
  const StockMovementGoldenReplay._();

  static double balanceFor(
    StockMovementGoldenFixture fixture, {
    required String userId,
    required String warehouseId,
    required DateTime asOfDate,
  }) {
    final cutoff = asOfDate.toUtc();
    final movements = fixture.movements
        .where(
          (movement) =>
              movement.userId == userId &&
              movement.itemId == fixture.itemId &&
              !movement.date.isAfter(cutoff) &&
              (movement.warehouseId == null ||
                  movement.warehouseId == warehouseId),
        )
        .toList()
      ..sort(_compareMovements);

    var balance = 0.0;
    for (final movement in movements) {
      switch (movement.type) {
        case StockMovementGoldenType.inbound:
          balance += movement.quantity;
        case StockMovementGoldenType.outbound:
          balance -= movement.quantity;
        case StockMovementGoldenType.adjustment:
          balance += movement.quantity;
        case StockMovementGoldenType.transfer:
          throw StockMovementGoldenBlockedException(
            'Standalone transfer ${movement.id} requires dual-entry semantics.',
          );
      }
    }
    return balance;
  }

  static int referenceCount(
    StockMovementGoldenFixture fixture, {
    required String userId,
    required String referenceId,
  }) =>
      fixture.movements
          .where(
            (movement) =>
                movement.userId == userId &&
                movement.referenceId == referenceId,
          )
          .length;

  static List<String> verifyFixture(StockMovementGoldenFixture fixture) {
    final errors = <String>[];
    for (final expected in fixture.expectedBalances) {
      final actual = balanceFor(
        fixture,
        userId: expected.userId ?? fixture.userId,
        warehouseId: expected.warehouseId,
        asOfDate: expected.asOfDate,
      );
      if ((actual - expected.quantity).abs() > 0.000000001) {
        errors.add(
          '${fixture.id}: ${expected.userId ?? fixture.userId}/'
          '${expected.warehouseId}/${expected.asOfDate.toIso8601String()}: '
          'expected ${expected.quantity}, actual $actual',
        );
      }
    }
    for (final entry in fixture.expectedReferenceCounts.entries) {
      final actual = referenceCount(
        fixture,
        userId: fixture.userId,
        referenceId: entry.key,
      );
      if (actual != entry.value) {
        errors.add(
          '${fixture.id}: reference ${entry.key}: '
          'expected ${entry.value}, actual $actual',
        );
      }
    }
    return errors;
  }

  static int _compareMovements(
    StockMovementGoldenRecord left,
    StockMovementGoldenRecord right,
  ) {
    final dateComparison = left.date.compareTo(right.date);
    if (dateComparison != 0) return dateComparison;
    return left.id.compareTo(right.id);
  }
}

class StockMovementGoldenBlockedException implements Exception {
  const StockMovementGoldenBlockedException(this.message);

  final String message;

  @override
  String toString() => 'StockMovementGoldenBlockedException: $message';
}

String _requiredString(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! String || value.isEmpty) {
    throw FormatException('Golden field $key must be a non-empty string.');
  }
  return value;
}

String? _optionalString(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is! String) {
    throw FormatException('Golden field $key must be a string or null.');
  }
  return value;
}

DateTime _requiredUtcDate(Map<String, Object?> json, String key) {
  final value = _requiredString(json, key);
  final parsed = DateTime.tryParse(value);
  if (!value.endsWith('Z') || parsed == null || !parsed.isUtc) {
    throw FormatException('Golden field $key must be canonical UTC.');
  }
  return parsed;
}

double _requiredFiniteNumber(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is num && value.toDouble().isFinite) return value.toDouble();
  throw FormatException('Golden field $key must be a finite number.');
}

double _requiredPositiveFiniteNumber(Map<String, Object?> json, String key) {
  final value = _requiredFiniteNumber(json, key);
  if (value <= 0) {
    throw FormatException('Golden field $key must be positive.');
  }
  return value;
}

String _requiredSyncStatus(Map<String, Object?> json, String key) {
  final value = _requiredString(json, key);
  if (!const {'synced', 'pendingPush', 'pendingPull', 'conflict'}
      .contains(value)) {
    throw FormatException('Golden field $key has an unsupported value.');
  }
  return value;
}

StockMovementGoldenType _movementType(String value) {
  for (final type in StockMovementGoldenType.values) {
    if (type.name == value) return type;
  }
  throw FormatException('Golden movement type $value is unsupported.');
}

Map<String, int> _readReferenceCounts(Object? value) {
  if (value == null) return const {};
  final map = _asMap(value);
  return map.map((key, value) {
    if (value is! num || value < 0 || value != value.round()) {
      throw FormatException('Reference count $key must be a non-negative int.');
    }
    return MapEntry(key, value.toInt());
  });
}

List<T> _readList<T>(
  Object? value,
  T Function(Map<String, Object?> json) decode,
) {
  if (value is! List) {
    throw const FormatException('Golden collection is missing.');
  }
  return value.map((item) => decode(_asMap(item))).toList(growable: false);
}

Map<String, Object?> _asMap(Object? value) {
  if (value is! Map) {
    throw const FormatException('Golden record must be an object.');
  }
  return value.map<String, Object?>((key, value) => MapEntry('$key', value));
}
