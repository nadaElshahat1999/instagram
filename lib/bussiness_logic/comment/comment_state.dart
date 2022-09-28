part of 'comment_cubit.dart';

@immutable
abstract class CommentStates {}
class AddCommentSuccessState extends CommentStates {
}
class AddCommentFailState extends CommentStates {
  final errorMessege;
  AddCommentFailState(this.errorMessege);
}
class GetCommentsSuccessState extends CommentStates {
}
class GetCommentsFailState extends CommentStates {
  final errorMessege;
  GetCommentsFailState(this.errorMessege);
}

class CommentInitialState extends CommentStates {}

