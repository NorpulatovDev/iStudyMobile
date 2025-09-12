// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BranchModel _$BranchModelFromJson(Map<String, dynamic> json) => BranchModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  address: json['address'] as String?,
  createdAt: json['createdAt'] as String,
);

Map<String, dynamic> _$BranchModelToJson(BranchModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'createdAt': instance.createdAt,
    };

CreateBranchRequest _$CreateBranchRequestFromJson(Map<String, dynamic> json) =>
    CreateBranchRequest(
      name: json['name'] as String,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$CreateBranchRequestToJson(
  CreateBranchRequest instance,
) => <String, dynamic>{'name': instance.name, 'address': instance.address};
