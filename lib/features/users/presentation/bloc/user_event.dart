part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class LoadUsers extends UserEvent {}

class CreateUser extends UserEvent {
  final CreateUserRequest request;

  const CreateUser(this.request);

  @override
  List<Object> get props => [request];
}

class UpdateUser extends UserEvent {
  final int userId;
  final UpdateUserRequest request;

  const UpdateUser({
    required this.userId,
    required this.request,
  });

  @override
  List<Object> get props => [userId, request];
}

class DeleteUser extends UserEvent {
  final int userId;

  const DeleteUser(this.userId);

  @override
  List<Object> get props => [userId];
}
