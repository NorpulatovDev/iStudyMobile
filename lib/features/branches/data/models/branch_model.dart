import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'branch_model.g.dart';

@JsonSerializable()
class BranchModel extends Equatable {
  final int id;
  final String name;
  final String? address;
  final String createdAt;

  const BranchModel({
    required this.id,
    required this.name,
    this.address,
    required this.createdAt,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) => _$BranchModelFromJson(json);
  Map<String, dynamic> toJson() => _$BranchModelToJson(this);

  @override
  List<Object?> get props => [id, name, address, createdAt];
}