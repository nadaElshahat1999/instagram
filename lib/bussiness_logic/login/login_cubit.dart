import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram/bussiness_logic/myShared.dart';
import 'package:instagram/data/models/user.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());
  void login ({
    required String email,
    required String password
  })async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      getUserData();
      //emit(LoginSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        emit(LoginFailState('No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        emit(LoginFailState('No user found for that email.'));
      }
    }catch(error){
      print(error.toString());
      emit(LoginFailState(''));
    }
  }
  passwordValidator(String value) {
    if (value.isEmpty) {
      return "please Enter Email";
    }
    if (value.length < 6) {
      return " password must be at least 6 characters ";
    }
    //bool passwordValid = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(value);
    //if (!passwordValid) {return "password not valid";}
    return null;
  }

  emailValidator(String value) {
    if (value.isEmpty) {
      return "please Enter Email";
    }
    bool emailValid = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(value);
    if (!emailValid) {
      return "email not valid";
    }
    return null;
  }

  void getUserData() {
    print('///////////////////////////////////////////////////////////');
    FirebaseFirestore.instance.collection('flutterUsers')
    .doc(FirebaseAuth.instance.currentUser!.uid)
        .get().then((json) {
          if(json.data()==null) return;
          MyUser user=MyUser.fromJson(json.data());
          print('///////////////////////////////////////////////////////////'+user.profileImageUrl!.toString());
          saveUserData(user);

    });
  }

  void saveUserData(MyUser user) {
    print('///////////////////////////////////////////////////////////'+user.profileImageUrl!);
    //encode
    MyShared.putString(key: 'user', value: jsonEncode(user));
    //decode
    // String userJson=MyShared.getString('user');
    // MyUser user2=jsonDecode(userJson,reviver: (key, value) => MyUser);
    MyShared.putString(key: 'username', value:user.username!);
    print(user.profileImageUrl!);
    MyShared.putString(key: 'profileImageUrl', value:user.profileImageUrl!);

    emit(LoginSuccessState());
  }
}
