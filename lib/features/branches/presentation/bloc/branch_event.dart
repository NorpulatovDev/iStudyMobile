part of 'branch_bloc.dart';

sealed class BranchEvent extends Equatable {
  const BranchEvent();

  @override
  List<Object> get props => [];
}

class LoadBranches extends BranchEvent {}

class SelectBranch extends BranchEvent {
  final BranchModel branch;

  const SelectBranch(this.branch);

  @override
  List<Object> get props => [branch];
}