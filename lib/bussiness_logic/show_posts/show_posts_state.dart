part of 'show_posts_cubit.dart';

@immutable
abstract class ShowPostsStates {}

class ShowPostsInitialState extends ShowPostsStates {
}
class ShowPostsFailState extends ShowPostsStates {
  final errorMessege;
  ShowPostsFailState(this.errorMessege);
}
class ShowPostsSuccessState extends ShowPostsStates {
}
class LikePostFailState extends ShowPostsStates {
  final errorMessege;
  LikePostFailState(this.errorMessege);
}
class LikePostSuccessState extends ShowPostsStates {
}
class UnlikePostFailState extends ShowPostsStates {
  final errorMessege;
  UnlikePostFailState(this.errorMessege);
}
class GetStoryDetailsSuccessState extends ShowPostsStates {
  final List<Story> storyDetails;

  GetStoryDetailsSuccessState(this.storyDetails);
}
class GetStoryDetailsFailState extends ShowPostsStates {
  final errorMessege;
  GetStoryDetailsFailState(this.errorMessege);
}
class UnlikePostSuccessState extends ShowPostsStates {
}
class AddStoryFailState extends ShowPostsStates {
  final errorMessege;
  AddStoryFailState(this.errorMessege);
}
class AddStorySuccessState extends ShowPostsStates {
}
class GetHomeStoriesFailState extends ShowPostsStates {
  final errorMessege;
  GetHomeStoriesFailState(this.errorMessege);
}
class GetHomeStoriesSuccessState extends ShowPostsStates {
}

