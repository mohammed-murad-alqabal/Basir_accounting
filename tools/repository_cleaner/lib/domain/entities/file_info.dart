enum FileType { file, directory, unknown }

enum FileCategory {
  sourceCode,
  asset,
  buildArtifact,
  log,
  documentation,
  configuration,
  test,
  temporary,
  archive,
  unknown
}

class FileInfo {
  FileInfo({
    required this.path,
    required this.name,
    required this.sizeBytes,
    required this.modifiedAt,
    required this.accessedAt,
    required this.type,
    this.category = FileCategory.unknown,
    this.checksum = '',
    this.isIgnored = false,
  });
  final String path;
  final String name;
  final int sizeBytes;
  final DateTime modifiedAt;
  final DateTime accessedAt;
  final FileType type;
  final FileCategory category;
  final String checksum; // SHA-256 or similar
  final bool isIgnored;

  FileInfo copyWith({
    String? path,
    String? name,
    int? sizeBytes,
    DateTime? modifiedAt,
    DateTime? accessedAt,
    FileType? type,
    FileCategory? category,
    String? checksum,
    bool? isIgnored,
  }) =>
      FileInfo(
        path: path ?? this.path,
        name: name ?? this.name,
        sizeBytes: sizeBytes ?? this.sizeBytes,
        modifiedAt: modifiedAt ?? this.modifiedAt,
        accessedAt: <credential-fixture> ?? this.accessedAt,
        type: type ?? this.type,
        category: category ?? this.category,
        checksum: checksum ?? this.checksum,
        isIgnored: isIgnored ?? this.isIgnored,
      );

  @override
  String toString() =>
      'FileInfo(path: $path, size: $sizeBytes, category: $category)';
}
