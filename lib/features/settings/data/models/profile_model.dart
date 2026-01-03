import 'package:basir_app/core/models/sync_status.dart';
import 'package:basir_app/features/settings/domain/entities/profile.dart';
import 'package:isar/isar.dart';

part 'profile_model.g.dart';

@collection
class ProfileModel {
  ProfileModel();

  factory ProfileModel.fromEntity(Profile entity) => ProfileModel()
    ..id = entity.id
    ..email = entity.email
    ..displayName = entity.displayName
    ..avatarUrl = entity.avatarUrl
    ..phoneNumber = entity.phoneNumber
    ..userId = entity.userId
    ..syncStatus = entity.syncStatus
    ..serverUpdatedAt = entity.serverUpdatedAt
    ..isDeleted = entity.isDeleted;
  Id? isarId;

  @Index(unique: true, replace: true)
  late String id;

  late String email;
  String? displayName;
  String? avatarUrl;
  String? phoneNumber;

  @Index()
  String? userId;

  @enumerated
  late SyncStatus syncStatus;

  DateTime? serverUpdatedAt;

  late bool isDeleted;

  Profile toEntity() => Profile(
        id: id,
        email: email,
        displayName: displayName,
        avatarUrl: avatarUrl,
        phoneNumber: phoneNumber,
        userId: userId,
        syncStatus: syncStatus,
        serverUpdatedAt: serverUpdatedAt,
        isDeleted: isDeleted,
      );
}
