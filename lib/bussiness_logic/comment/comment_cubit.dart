import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/bussiness_logic/myShared.dart';
import 'package:instagram/data/models/comment.dart';
import 'package:meta/meta.dart';

part 'comment_state.dart';

class CommentCubit extends Cubit<CommentStates> {
  CommentCubit() : super(CommentInitialState());
  void addNewComment({required String comment,required String postId}){
    String userId=FirebaseAuth.instance.currentUser!.uid.toString();
    String time=DateTime.now().toString();
    Comment commentData= Comment(username: MyShared.getString('username'),
        userImageUrl: MyShared.getString('profileImageUrl'),
        userId: userId,
        comment: comment,
        commentId: time+userId,
        commentTime: time
    );
    FirebaseFirestore.instance.collection('posts')
    .doc(postId)
    .collection('comments')
    .doc(commentData.commentId)
    .set(commentData.toJson())
    .then((value) => emit(AddCommentSuccessState()))
    .catchError((error)=> emit(AddCommentFailState(error.toString())));

  }
  void getComments({required String postId}){
    FirebaseFirestore.instance.collection('posts')
        .doc(postId)
        .collection('comments')
        .get()
        .then((value) => handlePostResponse(value))
        .catchError((error)=> emit(GetCommentsFailState(error.toString())));
  }
  List<Comment> comments=[];
  handlePostResponse(QuerySnapshot<Map<String, dynamic>> value) {
    comments.clear();
    for (var element in value.docs) {
      Comment comment=Comment.fromJson(element.data());
      comments.add(comment);
    }
    emit(GetCommentsSuccessState());
  }
}
