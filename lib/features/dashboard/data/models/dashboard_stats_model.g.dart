// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardStatsModel _$DashboardStatsModelFromJson(Map<String, dynamic> json) =>
    DashboardStatsModel(
      totalBranches: (json['totalBranches'] as num).toInt(),
      totalUsers: (json['totalUsers'] as num).toInt(),
      totalStudents: (json['totalStudents'] as num).toInt(),
      totalTeachers: (json['totalTeachers'] as num).toInt(),
      monthlyRevenue: (json['monthlyRevenue'] as num).toDouble(),
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
    );

Map<String, dynamic> _$DashboardStatsModelToJson(
  DashboardStatsModel instance,
) => <String, dynamic>{
  'totalBranches': instance.totalBranches,
  'totalUsers': instance.totalUsers,
  'totalStudents': instance.totalStudents,
  'totalTeachers': instance.totalTeachers,
  'monthlyRevenue': instance.monthlyRevenue,
  'totalRevenue': instance.totalRevenue,
};
