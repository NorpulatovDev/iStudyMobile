import 'package:json_annotation/json_annotation.dart';

part 'report_model.g.dart';

@JsonSerializable()
class ReportModel {
  final String type;
  
  // Date fields - nullable because different report types use different fields
  final int? year;
  final int? month;
  final String? date;
  final String? startDate;
  final String? endDate;
  final int? startYear;
  final int? startMonth;
  final int? endYear;
  final int? endMonth;
  
  // Branch identifier
  final int branchId;
  
  // Financial fields - all nullable with defaults
  final double? totalPayments;
  final double? totalExpenses;
  final double? totalSalaries;
  final double? totalIncome;
  final double? totalCosts;
  final double? netProfit;

  const ReportModel({
    required this.type,
    this.year,
    this.month,
    this.date,
    this.startDate,
    this.endDate,
    this.startYear,
    this.startMonth,
    this.endYear,
    this.endMonth,
    required this.branchId,
    this.totalPayments,
    this.totalExpenses,
    this.totalSalaries,
    this.totalIncome,
    this.totalCosts,
    this.netProfit,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      type: json['type'] as String,
      year: json['year'] as int?,
      month: json['month'] as int?,
      date: json['date'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      startYear: json['startYear'] as int?,
      startMonth: json['startMonth'] as int?,
      endYear: json['endYear'] as int?,
      endMonth: json['endMonth'] as int?,
      branchId: (json['branchId'] as num).toInt(),
      totalPayments: (json['totalPayments'] as num?)?.toDouble(),
      totalExpenses: (json['totalExpenses'] as num?)?.toDouble(),
      totalSalaries: (json['totalSalaries'] as num?)?.toDouble(),
      totalIncome: (json['totalIncome'] as num?)?.toDouble(),
      totalCosts: (json['totalCosts'] as num?)?.toDouble(),
      netProfit: (json['netProfit'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => _$ReportModelToJson(this);

  // Helper getters with default values
  double get safePayments => totalPayments ?? totalIncome ?? 0.0;
  double get safeExpenses => totalExpenses ?? 0.0;
  double get safeSalaries => totalSalaries ?? 0.0;
  double get safeCosts => totalCosts ?? (safeExpenses + safeSalaries);
  double get safeNetProfit => netProfit ?? (safePayments - safeCosts);

  @override
  String toString() {
    return 'ReportModel(type: $type, branchId: $branchId, payments: $safePayments, expenses: $safeExpenses, salaries: $safeSalaries, profit: $safeNetProfit)';
  }
}