
// lib/features/courses/presentation/bloc/course_state.dart
part of 'course_bloc.dart';

sealed class CourseState extends Equatable {
  const CourseState();

  @override
  List<Object?> get props => [];
}

final class CourseInitial extends CourseState {}

final class CourseLoading extends CourseState {}

// For operations like create, update, delete
final class CourseOperationLoading extends CourseState {}

final class CoursesLoaded extends CourseState {
  final List<CourseModel> courses;
  final int? branchId;

  const CoursesLoaded(this.courses, {this.branchId});

  @override
  List<Object?> get props => [courses, branchId];
}

final class CourseError extends CourseState {
  final String message;

  const CourseError(this.message);

  @override
  List<Object> get props => [message];
}

// Operation-specific states
final class CourseOperationSuccess extends CourseState {
  final String message;

  const CourseOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class CourseOperationError extends CourseState {
  final String message;

  const CourseOperationError(this.message);

  @override
  List<Object> get props => [message];
}