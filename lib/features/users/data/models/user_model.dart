import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final int id;
  final String username;
  final String role;
  final int? branchId;
  final String? branchName;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.username,
    required this.role,
    this.branchId,
    this.branchName,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  List<Object?> get props => [id, username, role, branchId, branchName, createdAt];
}

@JsonSerializable()
class CreateUserRequest extends Equatable {
  final String username;
  final String password;
  final String role;
  final int? branchId;

  const CreateUserRequest({
    required this.username,
    required this.password,
    required this.role,
    this.branchId,
  });

  factory CreateUserRequest.fromJson(Map<String, dynamic> json) => _$CreateUserRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateUserRequestToJson(this);

  @override
  List<Object?> get props => [username, password, role, branchId];
}

@JsonSerializable()
class UpdateUserRequest extends Equatable {
  final String username;
  final String role;
  final String? password;
  final int? branchId;

  const UpdateUserRequest({
    required this.username,
    required this.role,
    this.password,
    this.branchId,
  });

  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) => _$UpdateUserRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateUserRequestToJson(this);

  @override
  List<Object?> get props => [username, role, branchId, password];
}