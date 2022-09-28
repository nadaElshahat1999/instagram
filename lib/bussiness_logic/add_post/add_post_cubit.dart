import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram/data/models/post.dart';
import 'package:meta/meta.dart';

part 'add_post_state.dart';

class AddPostCubit extends Cubit<AddPostStates> {
  AddPostCubit() : super(AddPostInitialState());
  late Post post;
  void addPost({
  required File imageFile,
    required String postContent
}){
    post = Post.newInstance(postContent: postContent);
    uploadPostImage(imageFile);
  }
  void uploadPostImage(File imageFile)async{
    try {
      print('posts_images/${post.postId}');

      await FirebaseStorage.instance
          .ref('posts_images/${post.postId}')
          .putFile(imageFile);
      getImageURL();
      print('upload file success');

    } on FirebaseException catch (e) {
      emit(AddPostFailState(e.toString()));
      // e.g, e.code == 'canceled'
    }
  }

  void getImageURL() async{
    try {
      print('posts_images/${post.postId}');
      post.postImageUrl = await FirebaseStorage.instance
          .ref('posts_images/${post.postId}')
          .getDownloadURL();
      insertNewPostData();
      print('geturl success');

    } on FirebaseException catch (e) {
      emit(AddPostFailState(e.toString()));
      // e.g, e.code == 'canceled'
    }
  }

  void insertNewPostData() {
    FirebaseFirestore.instance
        .collection("posts")
        .doc(post.postId)
        .set(post.toJson())
        .then((value) {
      emit(AddPostSuccessState());
    }).catchError((error) {
      emit(AddPostFailState(error.toString()));
    });
  }
}
