// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:json_annotation/json_annotation.dart';

part 'branch_model.g.dart';

@JsonSerializable()
class BranchModel {
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

  factory BranchModel.fromJson(Map<String, dynamic> json)=> _$BranchModelFromJson(json);
  Map<String, dynamic> toJson() => _$BranchModelToJson(this);

}


@JsonSerializable()
class CreateBranchRequest{
  final String name;
  final String? address;

  const CreateBranchRequest({
    required this.name,
    this.address
  });

  factory CreateBranchRequest.fromJson(Map<String, dynamic> json) => _$CreateBranchRequestFromJson(json);
  Map<String, dynamic> toJson()=> _$CreateBranchRequestToJson(this);
}
