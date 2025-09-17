part of 'course_bloc.dart';

sealed class CourseEvent extends Equatable {
  const CourseEvent();

  @override
  List<Object> get props => [];
}



class LoadCoursesByBranch extends CourseEvent {
  final int branchId;

  const LoadCoursesByBranch(this.branchId);

  @override
  List<Object> get props => [branchId];
}

class CreateCourse extends CourseEvent {
  final CreateCourseRequest request;

  const CreateCourse(this.request);

  @override
  List<Object> get props => [request];
}

class UpdateCourse extends CourseEvent {
  final int courseId;
  final CreateCourseRequest request;

  const UpdateCourse({
    required this.courseId,
    required this.request,
  });

  @override
  List<Object> get props => [courseId, request];
}

class DeleteCourse extends CourseEvent {
  final int courseId;

  const DeleteCourse(this.courseId);

  @override
  List<Object> get props => [courseId];
}
