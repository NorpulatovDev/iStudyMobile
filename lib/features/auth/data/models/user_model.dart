// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';


@JsonSerializable()
class UserModel {
  final int userId;
  final String username;
  final String role;
  final int? branchId;
  final String? branchName;


  const UserModel({
    required this.userId,
    required this.username,
    required this.role,
    this.branchId,
    this.branchName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson()=> _$UserModelToJson(this);
}

@JsonSerializable()
class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int userId;
  final String username;
  final String role;
  final int? branchId;
  final String? branchName;

  const LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.userId,
    required this.username,
    required this.role,
    this.branchId,
    this.branchName,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);

  UserModel toUserModel() {
    return UserModel(
      userId: userId,
      username: username,
      role: role,
      branchId: branchId,
      branchName: branchName,
    );
  }
}

@JsonSerializable()
class LoginRequest {
  final String username;
  final String password;

  const LoginRequest({
    required this.username,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
