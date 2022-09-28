
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram/bussiness_logic/myShared.dart';
import 'package:instagram/data/models/story.dart';
import 'package:meta/meta.dart';

import '../../data/models/post.dart';
part 'show_posts_state.dart';

class ShowPostsCubit extends Cubit<ShowPostsStates> {
  ShowPostsCubit() : super(ShowPostsInitialState());
  List<Post> postsList=[];
  List<Story> storyDetails=[];
  List<Story> homeStories=[];
  void getPosts(){
    FirebaseFirestore.instance.collection('posts').get()
        .then((QuerySnapshot querySnapshot) async{
          postsList.clear();
          for (var doc in querySnapshot.docs) {
            Map<String,dynamic> json=doc.data() as Map<String,dynamic>;
            Post post=Post.fromJson(json);
            var likes =await FirebaseFirestore.instance
            .collection('posts')
            .doc(post.postId)
            .collection('likes')
            .get();
            post.likesCount=likes.docs.length;
            for (var element in likes.docs) {
              if(element.id==FirebaseAuth.instance.currentUser!.uid){
                post.isLiked=true;
                break;
              }
            }
            postsList.add(post);
          }
          postsList.reversed.toList();
          emit(ShowPostsSuccessState());
          print('Posts => ${postsList.length}');
    }).catchError( (error){
      emit(ShowPostsFailState(error.toString()));
    } );
  }
  void likePost({required String postId}){
    String userId =FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userId)
        .set({'userId': userId})
    .then((value) => emit(LikePostSuccessState()))
    .catchError((error)=>emit(LikePostFailState(error.toString())));
  }
  void unlikePost({required String postId}){
    String userId =FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userId)
        .delete()
        .then((value) => emit(LikePostSuccessState()))
        .catchError((error)=>emit(LikePostFailState(error.toString())));
  }
  void addStories(List<File> paths)async{
    int counter=1;
    for (var element in paths) {
      print('add story $counter');
      await addStory(element);
      print('story $counter added');
      counter++;


    }
  }
  Future<bool> addStory(File file)async{
    String ref= 'stories${FirebaseAuth.instance.currentUser!.uid+DateTime.now().toString()}';
    //1 upload image
    await uploadImage(file,ref);
    //2 get image url
    String imageUrl=await getImageUrl(ref);
    //3 insert story data on fire store
    await insertStoryData(imageUrl);
    return true;
  }
  void getStoriesDetails(String userId){
    FirebaseFirestore.instance
        .collection('stories')
        .doc(userId)
        .collection('myStories')
        .get()
        .then((value) {
          print('story docs => ${value.docs.length} ');
          storyDetails.clear();
          for (var element in value.docs) {
            Story story=Story.fromJson(element.data());
            const int day=86400000000;
            int currentMillis=DateTime.now().microsecondsSinceEpoch;
            int storyMillis=int.tryParse(story.storyTime!)??0;
            int betweenMillis=currentMillis-storyMillis;
            bool isLessThanDay=betweenMillis<day;
            if(isLessThanDay){
              storyDetails.add(story);
            }
            else{
              //delete story from firestore
              FirebaseFirestore.instance.collection('stories')
                  .doc(story.userId)
                  .collection('myStories')
                  .doc(story.storyTime)
                  .delete();
            }
          }
          print('storyDetails ${storyDetails.length}');
          emit(GetStoryDetailsSuccessState(storyDetails));
    });
  }

  Future<bool> uploadImage(File imageFile, String ref) async{
   try {
     await FirebaseStorage.instance.ref(ref).putFile(imageFile);
     print('XXXXXXXXXXXXXX uploadImage done');
      return true;
   }
   on FirebaseException catch(error){
     emit(AddStoryFailState(error.toString()));
   }
   return false;
  }
  Future<String> getImageUrl(String ref)async{

      String imageUrl = await FirebaseStorage.instance.ref(ref).getDownloadURL();
      print('XXXXXXXXXXXXXX getImageUrl done ');
      return imageUrl;


  }
  Future<bool> insertStoryData(String storyImageUrl)async{
    Story story=Story(
      username: MyShared.getString('username'),
      userId: FirebaseAuth.instance.currentUser!.uid.toString(),
      userImageUrl: MyShared.getString('profileImageUrl'),
      storyImageUrl: storyImageUrl,
      storyTime: DateTime.now().microsecondsSinceEpoch.toString()
    );
    FirebaseFirestore.instance.collection('stories')
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .set(story.toJson());
    FirebaseFirestore.instance.collection('stories')
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .collection('myStories')
    .doc(story.storyTime)
    .set(story.toJson()).then((value) {
      emit(AddStorySuccessState());
      getHomeStories();
      return true;
    }).catchError((error){
      emit(AddStoryFailState(error.toString()));
    });
    return false;
  }

  void getHomeStories() {
    FirebaseFirestore.instance.collection('stories')
        .get()
        .then((value) {
          homeStories.clear();
          for (var element in value.docs) {
            print('XXXXXXX getHomeStories ${element.data().toString()}');
        Story story=Story.fromJson(element.data());
           // homeStories.add(story);
            const double day=86400000000;
            int currentMillis=DateTime.now().microsecondsSinceEpoch;
            int storyMillis=int.tryParse(story.storyTime!)??0;
            int betweenMillis=currentMillis-storyMillis;
            bool isLessThanDay=betweenMillis<day;
            print('currentMillis $currentMillis');
            print('storyMillis $storyMillis');
            print('day $day');
            print('betweenMillis $betweenMillis');
            print('currentMillis $currentMillis');
            print('isLessThanDay $isLessThanDay');

            if(isLessThanDay){
              homeStories.add(story);
            }
            else{
              //delete story from firestore
              FirebaseFirestore.instance.collection('stories')
                  .doc(story.userId).delete();
            }
          }
          emit(GetHomeStoriesSuccessState());
          print('Home Stories length is ${homeStories.length}');
    });
  }
}
