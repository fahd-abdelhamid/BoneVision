part of 'user_cubit.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}
class ChangeUserPasswordSuccessState extends UserState {}
class ChangeUserPasswordLoadingState extends UserState {}
class ChangeUserPasswordErrorState extends UserState {}
class ShowNavFalseState extends UserState {}
class ShowNavTrueState extends UserState {}
class UserLogOutState extends UserState {}
class PickImageSuccess extends UserState {}