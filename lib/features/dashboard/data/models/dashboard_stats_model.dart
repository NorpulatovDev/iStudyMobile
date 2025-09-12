
import 'package:json_annotation/json_annotation.dart';

part 'dashboard_stats_model.g.dart';

@JsonSerializable()
class DashboardStatsModel {
  final int totalBranches;
  final int totalUsers;
  final int totalStudents;
  final int totalTeachers;
  final double monthlyRevenue;
  final double totalRevenue;

  const DashboardStatsModel({
    required this.totalBranches,
    required this.totalUsers,
    required this.totalStudents,
    required this.totalTeachers,
    required this.monthlyRevenue,
    required this.totalRevenue,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) => _$DashboardStatsModelFromJson(json);
  Map<String, dynamic> toJson() => _$DashboardStatsModelToJson(this);
}
