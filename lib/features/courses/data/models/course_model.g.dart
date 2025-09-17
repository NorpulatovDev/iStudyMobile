// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupModel _$GroupModelFromJson(Map<String, dynamic> json) => GroupModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  courseId: (json['courseId'] as num).toInt(),
  courseName: json['courseName'] as String,
  teacherId: (json['teacherId'] as num).toInt(),
  teacherName: json['teacherName'] as String,
  branchId: (json['branchId'] as num).toInt(),
  branchName: json['branchName'] as String,
  createdAt: json['createdAt'] as String,
  startTime: json['startTime'] as String,
  endTime: json['endTime'] as String,
  daysOfWeek: (json['daysOfWeek'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$GroupModelToJson(GroupModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'courseId': instance.courseId,
      'courseName': instance.courseName,
      'teacherId': instance.teacherId,
      'teacherName': instance.teacherName,
      'branchId': instance.branchId,
      'branchName': instance.branchName,
      'createdAt': instance.createdAt,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'daysOfWeek': instance.daysOfWeek,
    };

CourseModel _$CourseModelFromJson(Map<String, dynamic> json) => CourseModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String?,
  price: (json['price'] as num).toInt(),
  durationMonths: (json['durationMonths'] as num).toInt(),
  branchId: (json['branchId'] as num).toInt(),
  branchName: json['branchName'] as String,
  createdAt: json['createdAt'] as String,
  groups: (json['groups'] as List<dynamic>)
      .map((e) => GroupModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CourseModelToJson(CourseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'durationMonths': instance.durationMonths,
      'branchId': instance.branchId,
      'branchName': instance.branchName,
      'createdAt': instance.createdAt,
      'groups': instance.groups,
    };

CreateCourseRequest _$CreateCourseRequestFromJson(Map<String, dynamic> json) =>
    CreateCourseRequest(
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toInt(),
      durationMonths: (json['durationMonths'] as num).toInt(),
      branchId: (json['branchId'] as num).toInt(),
    );

Map<String, dynamic> _$CreateCourseRequestToJson(
  CreateCourseRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'price': instance.price,
  'durationMonths': instance.durationMonths,
  'branchId': instance.branchId,
};
