// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'branch_bloc.dart';

sealed class BranchEvent extends Equatable {
  const BranchEvent();

  @override
  List<Object> get props => [];
}


class BranchFetchRequested extends BranchEvent{}

class BranchCreateRequested extends BranchEvent {
  final CreateBranchRequest request;
  const BranchCreateRequested(this.request);

  @override
  List<Object> get props => [request];
} 

class BranchUpdateRequested extends BranchEvent{
  final int id;
  final CreateBranchRequest request;

  const BranchUpdateRequested(this.id, this.request);

  @override
  List<Object> get props => [id, request];
}

class BranchDeleteRequested extends BranchEvent{
  final int id;

  const BranchDeleteRequested(this.id);

  @override
  List<Object> get props => [id];
}