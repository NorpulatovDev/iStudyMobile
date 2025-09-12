part of 'branch_bloc.dart';

sealed class BranchState extends Equatable {
  const BranchState();
  
  @override
  List<Object> get props => [];
}

final class BranchInitial extends BranchState {}

final class BranchLoading extends BranchState{}

final class BranchLoadSuccess extends BranchState{
  final List<BranchModel> branches;

  const BranchLoadSuccess(this.branches);

  @override
  List<Object> get props => [branches];
}


final class BranchError extends BranchState{
  final String message;

  const BranchError(this.message);

  @override
  List<Object> get props => [message];
}