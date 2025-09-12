import 'package:dio/dio.dart';
import 'package:istudy/core/constants/api_constants.dart';
import 'package:istudy/core/services/api_service.dart';
import '../models/branch_model.dart';

class BranchRepository {
  final ApiService _apiService;

  BranchRepository(this._apiService);

  Future<List<BranchModel>> getAllBranches() async {
    try {
      final response = await _apiService.dio.get(ApiConstants.branchesEndpoint);

      final List<dynamic> data = response.data;
      return data.map((json) => BranchModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch branches: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch branches: $e');
    }
  }

  Future<BranchModel> getBranchById(int id) async {
    try {
      final response = await _apiService.dio.get(
        "${ApiConstants.branchesEndpoint}/$id",
      );
      return BranchModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to fetch branch: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch branch: $e');
    }
  }

  Future<BranchModel> createBranch(CreateBranchRequest request) async {
    try {
      final response = await _apiService.dio.post(
        ApiConstants.branchesEndpoint,
        data: request.toJson(),
      );

      return BranchModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to create branch: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create branch: $e');
    }
  }

  Future<BranchModel> updateBranch(int id, CreateBranchRequest request) async {
    try {
      final response = await _apiService.dio.put(
        '${ApiConstants.branchesEndpoint}/$id',
        data: request.toJson(),
      );

      return BranchModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to update branch: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update branch: $e');
    }
  }

  Future<void> deleteBranch(int id)async{
    try{
      await _apiService.dio.delete('${ApiConstants.branchesEndpoint}/$id');
    } on DioException catch (e) {
      throw Exception('Failed to delete branch: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete branch: $e');
    }
  }
}
