import 'package:json_annotation/json_annotation.dart';

part 'report_model.g.dart';

@JsonSerializable()
class ReportModel {
  final String type;
  final int? year;
  final int? month;
  final String? date;
  final String? startDate;
  final String? endDate;
  final int branchId;
  final double totalPayments;
  final double totalExpenses;
  final double totalSalaries;
  final double totalCosts;
  final double netProfit;

  const ReportModel({
    required this.type,
    this.year,
    this.month,
    this.date,
    this.startDate,
    this.endDate,
    required this.branchId,
    required this.totalPayments,
    required this.totalExpenses,
    required this.totalSalaries,
    required this.totalCosts,
    required this.netProfit,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) => _$ReportModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReportModelToJson(this);
}