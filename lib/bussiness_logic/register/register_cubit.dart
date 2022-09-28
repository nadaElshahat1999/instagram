import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram/data/models/user.dart';
import 'package:meta/meta.dart';
part 'register_state.dart';

// 1: create account ( Auth )
// 2: upload image ( storage )
// 3: get image url ( storage )
// 4: save user data ( fireStore )

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());
   late String email;
   late String phone;
   late String userName;
   late String imageURL;
   late File imageFile;
  void register({
  required String email,
    required String password,
    required String phone,
    required String userName,
    required File imageFile,
  })async{
    this.email=email;
    this.phone=phone;
    this.userName=userName;
    this.imageFile=imageFile;
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print('register success');
      uploadFile();

    }

    ).catchError(
        (error){
          if(error is FirebaseAuthException && error.code=='weak-password')
          {
            RegisterFailState('The password provided is too weak.');
          }
          else if(error is FirebaseAuthException &&
              error.code=='email-already-in-use')
          {
            emit(RegisterFailState('the account already exists.'));
          }
          else
            {
            emit(RegisterFailState(error.toString()));
          }
        }
    );
  }

  Future<void> uploadFile() async {
    try {
      print('uploads/${FirebaseAuth.instance.currentUser!.uid}');

      await FirebaseStorage.instance
          .ref('uploads/${FirebaseAuth.instance.currentUser!.uid}')
          .putFile(imageFile);
      getImageURL();
      print('upload file success');

    } on FirebaseException catch (e) {
      print('uploadfile error : ${e.toString()}');
      // e.g, e.code == 'canceled'
    }
  }
  Future<void> getImageURL() async {
    try {
      print('uploads/${FirebaseAuth.instance.currentUser!.uid}');
      imageURL = await FirebaseStorage.instance
          .ref('uploads/${FirebaseAuth.instance.currentUser!.uid}')
          .getDownloadURL();
      saveUserData();
      print('geturl success');

    } on FirebaseException catch (e) {
      print('getImageURL error : ${e.toString()}');
      // e.g, e.code == 'canceled'
    }



  }
  void saveUserData(){
    MyUser user=MyUser(
      phone: phone,
      username: userName,
      email: email,
        profileImageUrl: imageURL,
      userId: FirebaseAuth.instance.currentUser!.uid
    );
    FirebaseFirestore.instance.collection('flutterUsers')
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .set(user.toJson()).then((value) {
      print('save success');

      emit(RegisterSuccessState());
    }).catchError((error){
      print('save user data error :${error.toString()}');
    });
  }

  passwordValidator(String value) {
    if (value.isEmpty) {
      return "please enter email";
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
      return "please enter Email";
    }
    bool emailValid = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(value);
    if (!emailValid) {
      return "email not valid";
    }
    return null;
  }
  nameValidator(String value) {
    if (value.isEmpty) {
      return "please enter name";
    }
    return null;
  }

  phoneValidator(String value) {
    if (value.isEmpty) {
      return "please enter phone";
    }
    if (value.length<11||value.length>11) {
      return "phone not valid";
    }
    return null;
  }
}


