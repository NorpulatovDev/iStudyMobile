import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:istudy/features/branches/data/models/branch_model.dart';
import 'package:istudy/features/branches/data/repositories/branch_repository.dart';

part 'branch_event.dart';
part 'branch_state.dart';

class BranchBloc extends Bloc<BranchEvent, BranchState> {
  final BranchRepository _branchRepository;

  BranchBloc(this._branchRepository) : super(BranchInitial()) {
    on<BranchFetchRequested>(_onFetchRequested);
    on<BranchCreateRequested>(_onCreateRequested);
    on<BranchUpdateRequested>(_onUpdateRequested);
    on<BranchDeleteRequested>(_onDeleteRequested);
  }


  Future<void> _onFetchRequested(
    BranchFetchRequested event,
    Emitter<BranchState> emit,
  ) async {
    emit(BranchLoading());
    
    try {
      final branches = await _branchRepository.getAllBranches();
      emit(BranchLoadSuccess(branches));
    } catch (e) {
      emit(BranchError(e.toString()));
    }
  }

  Future<void> _onCreateRequested(
    BranchCreateRequested event,
    Emitter<BranchState> emit,
  ) async {
    emit(BranchLoading());
    
    try {
      await _branchRepository.createBranch(event.request);
      final branches = await _branchRepository.getAllBranches();
      emit(BranchLoadSuccess(branches));
    } catch (e) {
      emit(BranchError(e.toString()));
    }
  }

  Future<void> _onUpdateRequested(
    BranchUpdateRequested event,
    Emitter<BranchState> emit,
  ) async {
    emit(BranchLoading());
    
    try {
      await _branchRepository.updateBranch(event.id, event.request);
      final branches = await _branchRepository.getAllBranches();
      emit(BranchLoadSuccess(branches));
    } catch (e) {
      emit(BranchError(e.toString()));
    }
  }

  Future<void> _onDeleteRequested(
    BranchDeleteRequested event,
    Emitter<BranchState> emit,
  ) async {
    emit(BranchLoading());
    
    try {
      await _branchRepository.deleteBranch(event.id);
      final branches = await _branchRepository.getAllBranches();
      emit(BranchLoadSuccess(branches));
    } catch (e) {
      emit(BranchError(e.toString()));
    }
  }
}
