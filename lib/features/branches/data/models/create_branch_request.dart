import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_branch_request.g.dart';

@JsonSerializable()
class CreateBranchRequest extends Equatable {
  final String name;
  final String? address;

  const CreateBranchRequest({
    required this.name,
    this.address,
  });

  factory CreateBranchRequest.fromJson(Map<String, dynamic> json) => _$CreateBranchRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateBranchRequestToJson(this);

  @override
  List<Object?> get props => [name, address];
}