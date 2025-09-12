import 'package:dio/dio.dart';
import 'package:istudy/core/constants/api_constants.dart';
import 'package:istudy/core/services/api_service.dart';
import 'package:istudy/features/dashboard/data/models/dashboard_stats_model.dart';

class DashboardRepository {
  final ApiService _apiService;

  const DashboardRepository(this._apiService);


  Future<DashboardStatsModel> getDashboardStats()async{
    try{
      final response = await _apiService.dio.get(ApiConstants.dashboardStatsEndpoint);

      return DashboardStatsModel.fromJson(response.data);
    }on DioException catch(e){
      throw Exception("Failed to fetch dashboard stats ${e.message}");
    }catch (e){
      throw Exception("Failed to fetch dashboard stats $e");
    }
  }
}