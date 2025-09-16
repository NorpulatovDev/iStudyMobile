import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../models/user_model.dart';

class UserRepository {
  final ApiService _apiService;

  const UserRepository(this._apiService);

  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await _apiService.dio.get(ApiConstants.usersEndpoint);
      
      if (response.data is List) {
        final users = (response.data as List)
            .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
            .toList();
        return users;
      } else {
        throw Exception('Invalid response format');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized');
      }
      throw Exception('Failed to fetch users: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  Future<UserModel> createUser(CreateUserRequest request) async {
    try {
      final response = await _apiService.dio.post(
        ApiConstants.usersEndpoint,
        data: request.toJson(),
      );
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('Invalid user data: ${e.response?.data}');
      } else if (e.response?.statusCode == 409) {
        throw Exception('Username already exists');
      }
      throw Exception('Failed to create user: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  Future<UserModel> updateUser(int userId, UpdateUserRequest request) async {
    try {
      final response = await _apiService.dio.put(
        '${ApiConstants.usersEndpoint}/$userId',
        data: request.toJson(),
      );
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('Invalid user data: ${e.response?.data}');
      } else if (e.response?.statusCode == 404) {
        throw Exception('User not found');
      }
      throw Exception('Failed to update user: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<void> deleteUser(int userId) async {
    try {
      await _apiService.dio.delete('${ApiConstants.usersEndpoint}/$userId');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('User not found');
      }
      throw Exception('Failed to delete user: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }
}