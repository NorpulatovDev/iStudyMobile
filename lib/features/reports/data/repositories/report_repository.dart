import 'package:dio/dio.dart';
import '../../../../core/services/api_service.dart';
import '../models/report_model.dart';

class ReportRepository {
  final ApiService _apiService;

  const ReportRepository(this._apiService);

  // Payment Reports
  Future<ReportModel> getDailyPaymentReport(int branchId, String date) async {
    try {
      final response = await _apiService.dio.get(
        '/reports/payments/daily',
        queryParameters: {
          'branchId': branchId,
          'date': date,
        },
      );
      return ReportModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to fetch daily payment report: ${e.message}');
    }
  }

  Future<ReportModel> getMonthlyPaymentReport(int branchId, int year, int month) async {
    try {
      final response = await _apiService.dio.get(
        '/reports/payments/monthly',
        queryParameters: {
          'branchId': branchId,
          'year': year,
          'month': month,
        },
      );
      return ReportModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to fetch monthly payment report: ${e.message}');
    }
  }

  Future<ReportModel> getPaymentRangeReport(int branchId, String startDate, String endDate) async {
    try {
      final response = await _apiService.dio.get(
        '/reports/payments/range',
        queryParameters: {
          'branchId': branchId,
          'startDate': startDate,
          'endDate': endDate,
        },
      );
      return ReportModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to fetch payment range report: ${e.message}');
    }
  }

  // Expense Reports
  Future<ReportModel> getDailyExpenseReport(int branchId, String date) async {
    try {
      final response = await _apiService.dio.get(
        '/reports/expenses/daily',
        queryParameters: {
          'branchId': branchId,
          'date': date,
        },
      );
      return ReportModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to fetch daily expense report: ${e.message}');
    }
  }

  Future<ReportModel> getMonthlyExpenseReport(int branchId, int year, int month) async {
    try {
      final response = await _apiService.dio.get(
        '/reports/expenses/monthly',
        queryParameters: {
          'branchId': branchId,
          'year': year,
          'month': month,
        },
      );
      return ReportModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to fetch monthly expense report: ${e.message}');
    }
  }

  Future<ReportModel> getExpenseRangeReport(int branchId, String startDate, String endDate) async {
    try {
      final response = await _apiService.dio.get(
        '/reports/expenses/range',
        queryParameters: {
          'branchId': branchId,
          'startDate': startDate,
          'endDate': endDate,
        },
      );
      return ReportModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to fetch expense range report: ${e.message}');
    }
  }

  // Salary Reports
  Future<ReportModel> getMonthlySalaryReport(int branchId, int year, int month) async {
    try {
      final response = await _apiService.dio.get(
        '/reports/salaries/monthly',
        queryParameters: {
          'branchId': branchId,
          'year': year,
          'month': month,
        },
      );
      return ReportModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to fetch monthly salary report: ${e.message}');
    }
  }

  Future<ReportModel> getSalaryRangeReport(int branchId, int startYear, int startMonth, int endYear, int endMonth) async {
    try {
      final response = await _apiService.dio.get(
        '/reports/salaries/range',
        queryParameters: {
          'branchId': branchId,
          'startYear': startYear,
          'startMonth': startMonth,
          'endYear': endYear,
          'endMonth': endMonth,
        },
      );
      return ReportModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to fetch salary range report: ${e.message}');
    }
  }

  // Financial Summary Reports
  Future<ReportModel> getFinancialSummary(int branchId, int year, int month) async {
    try {
      final response = await _apiService.dio.get(
        '/reports/financial/summary',
        queryParameters: {
          'branchId': branchId,
          'year': year,
          'month': month,
        },
      );
      return ReportModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to fetch financial summary: ${e.message}');
    }
  }

  Future<ReportModel> getFinancialSummaryRange(int branchId, String startDate, String endDate) async {
    try {
      final response = await _apiService.dio.get(
        '/reports/financial/summary-range',
        queryParameters: {
          'branchId': branchId,
          'startDate': startDate,
          'endDate': endDate,
        },
      );
      return ReportModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to fetch financial summary range: ${e.message}');
    }
  }
}