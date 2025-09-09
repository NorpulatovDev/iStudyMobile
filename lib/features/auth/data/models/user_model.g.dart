// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  userId: (json['userId'] as num).toInt(),
  username: json['username'] as String,
  role: json['role'] as String,
  branchId: (json['branchId'] as num?)?.toInt(),
  branchName: json['branchName'] as String?,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'userId': instance.userId,
  'username': instance.username,
  'role': instance.role,
  'branchId': instance.branchId,
  'branchName': instance.branchName,
};

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      tokenType: json['tokenType'] as String,
      userId: (json['userId'] as num).toInt(),
      username: json['username'] as String,
      role: json['role'] as String,
      branchId: (json['branchId'] as num?)?.toInt(),
      branchName: json['branchName'] as String?,
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'tokenType': instance.tokenType,
      'userId': instance.userId,
      'username': instance.username,
      'role': instance.role,
      'branchId': instance.branchId,
      'branchName': instance.branchName,
    };

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
  username: json['username'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
    };
