part of 'add_post_cubit.dart';

@immutable
abstract class AddPostStates {}
class AddPostSuccessState extends AddPostStates{
}
class AddPostFailState extends AddPostStates {
  final errorMessege;
  AddPostFailState(this.errorMessege);

}
class AddPostInitialState extends AddPostStates {}
