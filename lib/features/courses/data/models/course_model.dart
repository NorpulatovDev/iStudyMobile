// lib/features/courses/data/models/course_model.dart
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'course_model.g.dart';

@JsonSerializable()
class GroupModel extends Equatable {
  final int id;
  final String name;
  final int courseId;
  final String courseName;
  final int teacherId;
  final String teacherName;
  final int branchId;
  final String branchName;
  final String createdAt;
  final String startTime;
  final String endTime;
  final List<String> daysOfWeek;

  const GroupModel({
    required this.id,
    required this.name,
    required this.courseId,
    required this.courseName,
    required this.teacherId,
    required this.teacherName,
    required this.branchId,
    required this.branchName,
    required this.createdAt,
    required this.startTime,
    required this.endTime,
    required this.daysOfWeek,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) => _$GroupModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupModelToJson(this);

  @override
  List<Object> get props => [
    id, name, courseId, courseName, teacherId, teacherName,
    branchId, branchName, createdAt, startTime, endTime, daysOfWeek
  ];
}

@JsonSerializable()
class CourseModel extends Equatable {
  final int id;
  final String name;
  final String? description;
  final int price;
  final int durationMonths;
  final int branchId;
  final String branchName;
  final String createdAt;
  final List<GroupModel> groups;

  const CourseModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.durationMonths,
    required this.branchId,
    required this.branchName,
    required this.createdAt,
    required this.groups,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) => _$CourseModelFromJson(json);
  Map<String, dynamic> toJson() => _$CourseModelToJson(this);

  @override
  List<Object?> get props => [
    id, name, description, price, durationMonths,
    branchId, branchName, createdAt, groups
  ];
}

@JsonSerializable()
class CreateCourseRequest extends Equatable {
  final String name;
  final String? description;
  final int price;
  final int durationMonths;
  final int branchId;

  const CreateCourseRequest({
    required this.name,
    this.description,
    required this.price,
    required this.durationMonths,
    required this.branchId,
  });

  factory CreateCourseRequest.fromJson(Map<String, dynamic> json) => _$CreateCourseRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateCourseRequestToJson(this);

  @override
  List<Object?> get props => [name, description, price, durationMonths, branchId];
}