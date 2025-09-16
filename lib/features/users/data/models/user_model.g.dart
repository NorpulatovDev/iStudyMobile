// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String,
  role: json['role'] as String,
  branchId: (json['branchId'] as num?)?.toInt(),
  branchName: json['branchName'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'role': instance.role,
  'branchId': instance.branchId,
  'branchName': instance.branchName,
  'createdAt': instance.createdAt.toIso8601String(),
};

CreateUserRequest _$CreateUserRequestFromJson(Map<String, dynamic> json) =>
    CreateUserRequest(
      username: json['username'] as String,
      password: json['password'] as String,
      role: json['role'] as String,
      branchId: (json['branchId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CreateUserRequestToJson(CreateUserRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'role': instance.role,
      'branchId': instance.branchId,
    };

UpdateUserRequest _$UpdateUserRequestFromJson(Map<String, dynamic> json) =>
    UpdateUserRequest(
      username: json['username'] as String,
      role: json['role'] as String,
      branchId: (json['branchId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UpdateUserRequestToJson(UpdateUserRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'role': instance.role,
      'branchId': instance.branchId,
    };
