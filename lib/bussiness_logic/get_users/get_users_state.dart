part of 'get_users_cubit.dart';

@immutable
abstract class GetUsersStates {}

class GetUsersInitialState extends GetUsersStates {}
class GetUsersSuccessState extends GetUsersStates {

}
class GetUsersFailState extends GetUsersStates {
  final errorMessege;
  GetUsersFailState(this.errorMessege);
}
