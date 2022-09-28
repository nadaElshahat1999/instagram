part of 'register_cubit.dart';

@immutable
abstract class RegisterStates {}
class RegisterSuccessState extends RegisterStates{
}
class RegisterFailState extends RegisterStates {
  final errorMessege;
  RegisterFailState(this.errorMessege);

}
class RegisterInitialState extends RegisterStates {}
