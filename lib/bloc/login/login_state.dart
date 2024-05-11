part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}
class LoginLoadingState extends LoginState {}
class LoginSuccessState extends LoginState {}
class LoginErrorState extends LoginState {
  final error;

  LoginErrorState(this.error);
}
class GetUserDataState extends LoginState {}
class ReceiveUserNameSuccessState extends LoginState {}
class ReceiveUserNameLoadingState extends LoginState {}
class ReceiveUserNameErrorState extends LoginState {}