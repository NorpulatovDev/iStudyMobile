// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_branch_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateBranchRequest _$CreateBranchRequestFromJson(Map<String, dynamic> json) =>
    CreateBranchRequest(
      name: json['name'] as String,
      address: json['address'] as String?,
    );

Map<String, dynamic> _$CreateBranchRequestToJson(
  CreateBranchRequest instance,
) => <String, dynamic>{'name': instance.name, 'address': instance.address};
