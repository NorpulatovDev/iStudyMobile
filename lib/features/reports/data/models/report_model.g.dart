// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportModel _$ReportModelFromJson(Map<String, dynamic> json) => ReportModel(
  type: json['type'] as String,
  year: (json['year'] as num?)?.toInt(),
  month: (json['month'] as num?)?.toInt(),
  date: json['date'] as String?,
  startDate: json['startDate'] as String?,
  endDate: json['endDate'] as String?,
  startYear: (json['startYear'] as num?)?.toInt(),
  startMonth: (json['startMonth'] as num?)?.toInt(),
  endYear: (json['endYear'] as num?)?.toInt(),
  endMonth: (json['endMonth'] as num?)?.toInt(),
  branchId: (json['branchId'] as num).toInt(),
  totalPayments: (json['totalPayments'] as num?)?.toDouble(),
  totalExpenses: (json['totalExpenses'] as num?)?.toDouble(),
  totalSalaries: (json['totalSalaries'] as num?)?.toDouble(),
  totalIncome: (json['totalIncome'] as num?)?.toDouble(),
  totalCosts: (json['totalCosts'] as num?)?.toDouble(),
  netProfit: (json['netProfit'] as num?)?.toDouble(),
);

Map<String, dynamic> _$ReportModelToJson(ReportModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'year': instance.year,
      'month': instance.month,
      'date': instance.date,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'startYear': instance.startYear,
      'startMonth': instance.startMonth,
      'endYear': instance.endYear,
      'endMonth': instance.endMonth,
      'branchId': instance.branchId,
      'totalPayments': instance.totalPayments,
      'totalExpenses': instance.totalExpenses,
      'totalSalaries': instance.totalSalaries,
      'totalIncome': instance.totalIncome,
      'totalCosts': instance.totalCosts,
      'netProfit': instance.netProfit,
    };
