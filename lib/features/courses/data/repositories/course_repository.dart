// lib/features/courses/data/repositories/course_repository.dart
import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service.dart';
import '../models/course_model.dart';

class CourseRepository {
  final ApiService _apiService;

  const CourseRepository(this._apiService);

  Future<List<CourseModel>> getAllCourses() async {
    try {
      final response = await _apiService.dio.get(ApiConstants.coursesEndpoint);
      
      if (response.data is List) {
        final courses = (response.data as List)
            .map((json) => CourseModel.fromJson(json as Map<String, dynamic>))
            .toList();
        
        return courses;
      } else {
        throw Exception('Invalid response format');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized - please check authentication');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Courses endpoint not found');
      }
      throw Exception('Failed to fetch courses: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch courses: $e');
    }
  }

  Future<List<CourseModel>> getCoursesByBranch(int branchId) async {
    try {
      final response = await _apiService.dio.get(
        ApiConstants.coursesEndpoint,
        queryParameters: {'branchId': branchId},
      );
      
      if (response.data is List) {
        final courses = (response.data as List)
            .map((json) => CourseModel.fromJson(json as Map<String, dynamic>))
            .toList();
        
        return courses;
      } else {
        throw Exception('Invalid response format');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized - please check authentication');
      }
      throw Exception('Failed to fetch courses for branch: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch courses for branch: $e');
    }
  }

  Future<CourseModel> getCourseById(int id) async {
    try {
      final response = await _apiService.dio.get('${ApiConstants.coursesEndpoint}/$id');
      return CourseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to fetch course: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch course: $e');
    }
  }

  Future<CourseModel> createCourse(CreateCourseRequest request) async {
    try {
      final response = await _apiService.dio.post(
        ApiConstants.coursesEndpoint,
        data: request.toJson(),
      );
      return CourseModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('Invalid course data: ${e.response?.data}');
      }
      throw Exception('Failed to create course: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create course: $e');
    }
  }

  Future<CourseModel> updateCourse(int courseId, CreateCourseRequest request) async {
    try {
      final response = await _apiService.dio.put(
        '${ApiConstants.coursesEndpoint}/$courseId',
        data: request.toJson(),
      );
      return CourseModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('Invalid course data: ${e.response?.data}');
      } else if (e.response?.statusCode == 404) {
        throw Exception('Course not found');
      }
      throw Exception('Failed to update course: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update course: $e');
    }
  }

  Future<void> deleteCourse(int courseId) async {
    try {
      await _apiService.dio.delete('${ApiConstants.coursesEndpoint}/$courseId');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw Exception('Course not found');
      }
      throw Exception('Failed to delete course: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete course: $e');
    }
  }
}