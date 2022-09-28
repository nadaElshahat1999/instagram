part of 'login_cubit.dart';

@immutable
abstract class LoginStates {}

class LoginInitialState extends LoginStates {

}
class LoginSuccessState extends LoginStates {
}
class LoginFailState extends LoginStates {
  final errorMessege;
  LoginFailState(this.errorMessege);
}

