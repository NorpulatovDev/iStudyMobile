import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/branch_model.dart';
import '../../data/repositories/branch_repository.dart';

part 'branch_event.dart';
part 'branch_state.dart';

class BranchBloc extends Bloc<BranchEvent, BranchState> {
  final BranchRepository _branchRepository;

  BranchBloc(this._branchRepository) : super(BranchInitial()) {
    print('=== BranchBloc initialized ===');
    
    on<LoadBranches>(_onLoadBranches);
    on<SelectBranch>(_onSelectBranch);
    on<DeleteBranch>(_onDeleteBranch);
  }

  Future<void> _onLoadBranches(
    LoadBranches event,
    Emitter<BranchState> emit,
  ) async {
    print('=== BranchBloc: LoadBranches event received ===');
    
    emit(BranchLoading());
    
    try {
      final branches = await _branchRepository.getAllBranches();
      print('BranchBloc: Loaded ${branches.length} branches');
      
      // Log branch details
      for (final branch in branches) {
        print('Branch: ${branch.name} (ID: ${branch.id})');
      }
      
      emit(BranchesLoaded(branches));
    } catch (e) {
      print('BranchBloc error: $e');
      emit(BranchError(e.toString()));
    }
  }

  Future<void> _onSelectBranch(
    SelectBranch event,
    Emitter<BranchState> emit,
  ) async {
    print('=== BranchBloc: SelectBranch event received ===');
    print('Selected branch ID: ${event.branch.id}');
    print('Selected branch name: ${event.branch.name}');
    
    if (state is BranchesLoaded) {
      final currentState = state as BranchesLoaded;
      emit(BranchSelected(
        branches: currentState.branches,
        selectedBranch: event.branch,
      ));
    } else if (state is BranchSelected) {
      final currentState = state as BranchSelected;
      emit(BranchSelected(
        branches: currentState.branches,
        selectedBranch: event.branch,
      ));
    }
  }

  Future<void> _onDeleteBranch(
    DeleteBranch event,
    Emitter<BranchState> emit,
  ) async {
    emit(BranchLoading());
    
    try {
      await _branchRepository.deleteBranch(event.branchId);
      final branches = await _branchRepository.getAllBranches();
      emit(BranchesLoaded(branches));
    } catch (e) {
      emit(BranchError(e.toString()));
    }
  }
}
