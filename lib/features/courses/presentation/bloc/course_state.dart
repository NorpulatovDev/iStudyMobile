part of 'course_bloc.dart';

sealed class CourseState extends Equatable {
  const CourseState();

  @override
  List<Object> get props => [];
}

final class CourseInitial extends CourseState {}

final class CourseLoading extends CourseState {}

final class CoursesLoaded extends CourseState {
  final List<CourseModel> courses;

  const CoursesLoaded(this.courses);

  @override
  List<Object> get props => [courses];
}

final class CourseError extends CourseState {
  final String message;

  const CourseError(this.message);

  @override
  List<Object> get props => [message];
}