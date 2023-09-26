// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tmdb_error_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TmdbErrorModel _$TmdbErrorModelFromJson(Map<String, dynamic> json) =>
    TmdbErrorModel(
      statusCode: json['status_code'] as int?,
      statusMessage: json['status_message'] as String?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$TmdbErrorModelToJson(TmdbErrorModel instance) =>
    <String, dynamic>{
      'status_code': instance.statusCode,
      'status_message': instance.statusMessage,
      'success': instance.success,
    };
