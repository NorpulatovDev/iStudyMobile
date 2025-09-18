// lib/features/courses/presentation/bloc/course_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/course_model.dart';
import '../../data/repositories/course_repository.dart';

part 'course_event.dart';
part 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final CourseRepository _courseRepository;
  int? _currentBranchId;

  CourseBloc(this._courseRepository) : super(CourseInitial()) {
    on<LoadCoursesByBranch>(_onLoadCoursesByBranch);
    on<LoadAllCourses>(_onLoadAllCourses);
    on<CreateCourse>(_onCreateCourse);
    on<UpdateCourse>(_onUpdateCourse);
    on<DeleteCourse>(_onDeleteCourse);
    on<ResetCourseState>(_onResetCourseState);
  }

  Future<void> _onLoadCoursesByBranch(
    LoadCoursesByBranch event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseLoading());
    
    try {
      _currentBranchId = event.branchId;
      final courses = await _courseRepository.getCoursesByBranch(event.branchId);
      emit(CoursesLoaded(courses, branchId: event.branchId));
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }

  Future<void> _onLoadAllCourses(
    LoadAllCourses event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseLoading());
    
    try {
      final courses = await _courseRepository.getAllCourses();
      emit(CoursesLoaded(courses));
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }

  Future<void> _onCreateCourse(
    CreateCourse event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseOperationLoading());
    
    try {
      await _courseRepository.createCourse(event.request);
      
      // Reload courses for the current branch if available
      if (_currentBranchId != null) {
        final courses = await _courseRepository.getCoursesByBranch(_currentBranchId!);
        emit(CoursesLoaded(courses, branchId: _currentBranchId));
      } else {
        final courses = await _courseRepository.getAllCourses();
        emit(CoursesLoaded(courses));
      }
      
      // Emit success state
      emit(CourseOperationSuccess('Course created successfully'));
    } catch (e) {
      emit(CourseOperationError(e.toString()));
    }
  }

  Future<void> _onUpdateCourse(
    UpdateCourse event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseOperationLoading());
    
    try {
      await _courseRepository.updateCourse(event.courseId, event.request);
      
      // Reload courses for the current branch if available
      if (_currentBranchId != null) {
        final courses = await _courseRepository.getCoursesByBranch(_currentBranchId!);
        emit(CoursesLoaded(courses, branchId: _currentBranchId));
      } else {
        final courses = await _courseRepository.getAllCourses();
        emit(CoursesLoaded(courses));
      }
      
      emit(CourseOperationSuccess('Course updated successfully'));
    } catch (e) {
      emit(CourseOperationError(e.toString()));
    }
  }

  Future<void> _onDeleteCourse(
    DeleteCourse event,
    Emitter<CourseState> emit,
  ) async {
    emit(CourseOperationLoading());
    
    try {
      await _courseRepository.deleteCourse(event.courseId);
      
      // Reload courses for the current branch if available
      if (_currentBranchId != null) {
        final courses = await _courseRepository.getCoursesByBranch(_currentBranchId!);
        emit(CoursesLoaded(courses, branchId: _currentBranchId));
      } else {
        final courses = await _courseRepository.getAllCourses();
        emit(CoursesLoaded(courses));
      }
      
      emit(CourseOperationSuccess('Course deleted successfully'));
    } catch (e) {
      emit(CourseOperationError(e.toString()));
    }
  }

  Future<void> _onResetCourseState(
    ResetCourseState event,
    Emitter<CourseState> emit,
  ) async {
    // Return to loaded state if we have courses, otherwise initial
    if (_currentBranchId != null) {
      try {
        final courses = await _courseRepository.getCoursesByBranch(_currentBranchId!);
        emit(CoursesLoaded(courses, branchId: _currentBranchId));
      } catch (e) {
        emit(CourseInitial());
      }
    } else {
      emit(CourseInitial());
    }
  }
}