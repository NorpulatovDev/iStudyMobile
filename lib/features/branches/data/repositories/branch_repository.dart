import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../models/branch_model.dart';
import '../models/create_branch_request.dart';

class BranchRepository {
  final ApiService _apiService;

  const BranchRepository(this._apiService);

  Future<List<BranchModel>> getAllBranches() async {
    try {
      final response = await _apiService.dio.get(ApiConstants.branchesEndpoint);
      
      if (response.data is List) {
        final branches = (response.data as List)
            .map((json) => BranchModel.fromJson(json as Map<String, dynamic>))
            .toList();
        
        return branches;
      } else {
        throw Exception('Invalid response format');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized - please check authentication');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Branches endpoint not found');
      }
      throw Exception('Failed to fetch branches: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch branches: $e');
    }
  }

  Future<BranchModel> getBranchById(int id) async {
    try {
      final response = await _apiService.dio.get('${ApiConstants.branchesEndpoint}/$id');
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
      if (e.response?.statusCode == 400) {
        throw Exception('Invalid branch data: ${e.response?.data}');
      }
      throw Exception('Failed to create branch: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create branch: $e');
    }
  }

  Future<BranchModel> updateBranch(int branchId, CreateBranchRequest request) async {
    try {
      final response = await _apiService.dio.put(
        '${ApiConstants.branchesEndpoint}/$branchId',
        data: request.toJson(),
      );
      return BranchModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('Invalid branch data: ${e.response?.data}');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Branch not found');
      }
      throw Exception('Failed to update branch: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update branch: $e');
    }
  }

  Future<void> deleteBranch(int branchId) async {
    try {
      await _apiService.dio.delete('${ApiConstants.branchesEndpoint}/$branchId');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Branch not found');
      }
      throw Exception('Failed to delete branch: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete branch: $e');
    }
  }
}