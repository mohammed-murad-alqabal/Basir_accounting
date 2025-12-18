import 'package:dartz/dartz.dart';

/// ${REPOSITORY_NAME} - ${DESCRIPTION}
/// 
/// المشروع: بصير MVP
/// المؤلف: فريق وكلاء تطوير مشروع بصير
/// 
/// يطبق Clean Architecture pattern
abstract class ${REPOSITORY_NAME} {
  /// ${METHOD_DESCRIPTION}
  Future<Either<Failure, ${RETURN_TYPE}>> ${METHOD_NAME}(${PARAMETERS});
}

/// تنفيذ ${REPOSITORY_NAME} باستخدام Isar
class ${REPOSITORY_NAME}Impl implements ${REPOSITORY_NAME} {
  const ${REPOSITORY_NAME}Impl({
    required this.localDataSource,
  });

  final ${LOCAL_DATASOURCE_NAME} localDataSource;

  @override
  Future<Either<Failure, ${RETURN_TYPE}>> ${METHOD_NAME}(${PARAMETERS}) async {
    try {
      final result = await localDataSource.${METHOD_NAME}(${PARAMETER_NAMES});
      return Right(result);
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }
}

/// مصدر البيانات المحلي
abstract class ${LOCAL_DATASOURCE_NAME} {
  Future<${RETURN_TYPE}> ${METHOD_NAME}(${PARAMETERS});
}

/// تنفيذ مصدر البيانات المحلي باستخدام Isar
class ${LOCAL_DATASOURCE_NAME}Impl implements ${LOCAL_DATASOURCE_NAME} {
  const ${LOCAL_DATASOURCE_NAME}Impl({
    required this.isar,
  });

  final Isar isar;

  @override
  Future<${RETURN_TYPE}> ${METHOD_NAME}(${PARAMETERS}) async {
    // TODO: تنفيذ العملية باستخدام Isar
    throw UnimplementedError();
  }
}