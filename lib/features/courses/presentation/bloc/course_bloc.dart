import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/course_model.dart';
import '../../data/repositories/course_repository.dart';

part 'course_event.dart';
part 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final CourseRepository _courseRepository;

  CourseBloc(this._courseRepository) : super(CourseInitial()) {
    on<LoadCoursesByBranch>(_onLoadCoursesByBranch);
    on<CreateCourse>(_onCreateCourse);
    on<UpdateCourse>(_onUpdateCourse);
    on<DeleteCourse>(_onDeleteCourse);
  }


  Future<void> _onLoadCoursesByBranch(
    LoadCoursesByBranch event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseLoading());
    
    try {
      final courses = await _courseRepository.getCoursesByBranch(event.branchId);
      emit(CoursesLoaded(courses));
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }

  Future<void> _onCreateCourse(
    CreateCourse event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseLoading());
    
    try {
      await _courseRepository.createCourse(event.request);
      final courses = await _courseRepository.getAllCourses();
      emit(CoursesLoaded(courses));
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }

  Future<void> _onUpdateCourse(
    UpdateCourse event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseLoading());
    
    try {
      await _courseRepository.updateCourse(event.courseId, event.request);
      final courses = await _courseRepository.getAllCourses();
      emit(CoursesLoaded(courses));
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }

  Future<void> _onDeleteCourse(
    DeleteCourse event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseLoading());
    
    try {
      await _courseRepository.deleteCourse(event.courseId);
      final courses = await _courseRepository.getAllCourses();
      emit(CoursesLoaded(courses));
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }
}