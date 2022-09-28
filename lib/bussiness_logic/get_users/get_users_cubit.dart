import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram/data/models/user.dart';
import 'package:meta/meta.dart';

part 'get_users_state.dart';

class GetUsersCubit extends Cubit<GetUsersStates> {
  GetUsersCubit() : super(GetUsersInitialState());
  List<MyUser> usersList=[];
  void getUsers(){
    FirebaseFirestore.instance.collection('flutterUsers')
        .get()
        .then((value) {
          usersList.clear();
       for (var element in value.docs) {
         MyUser user=MyUser.fromJson(element.data());
         if(element.id==FirebaseAuth.instance.currentUser!.uid){
           continue;
         }
         usersList.add(user);
       }
       emit(GetUsersSuccessState());
    }).catchError((error){
      emit(GetUsersFailState(error.toString()));
    });
  }
}
