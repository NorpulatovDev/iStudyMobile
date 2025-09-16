part of 'branch_bloc.dart';

sealed class BranchState extends Equatable {
  const BranchState();

  @override
  List<Object?> get props => [];
}

final class BranchInitial extends BranchState {}

final class BranchLoading extends BranchState {}

final class BranchesLoaded extends BranchState {
  final List<BranchModel> branches;

  const BranchesLoaded(this.branches);

  @override
  List<Object> get props => [branches];
}

final class BranchSelected extends BranchState {
  final List<BranchModel> branches;
  final BranchModel selectedBranch;

  const BranchSelected({
    required this.branches,
    required this.selectedBranch,
  });

  @override
  List<Object> get props => [branches, selectedBranch];
}

final class BranchError extends BranchState {
  final String message;

  const BranchError(this.message);

  @override
  List<Object> get props => [message];
}