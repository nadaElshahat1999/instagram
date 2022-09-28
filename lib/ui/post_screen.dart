import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/bussiness_logic/add_post/add_post_cubit.dart';
import 'package:instagram/bussiness_logic/add_post/add_post_cubit.dart';
import 'package:instagram/ui/home.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PostScreen extends StatelessWidget {
  final File imageFile;
  TextEditingController postContentController=TextEditingController();
   PostScreen({Key? key, required this.imageFile}) : super(key: key);
   late AddPostCubit cubit;
  var addPostFormkey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    cubit=BlocProvider.of<AddPostCubit>(context);
    return BlocListener<AddPostCubit, AddPostStates>(
      listener: (context, state) {
        if(state is AddPostSuccessState){
         //if(addPostFormkey.currentState!.validate()){
           Navigator.push(
               context,
               MaterialPageRoute(
                   builder: (context) => HomeScreen()
               ));
         }
        //}
        if (state is AddPostFailState){
          print(state.errorMessege);
          SnackBar snackBar=SnackBar(content: Text(state.errorMessege),
            action: SnackBarAction(label: 'ok',onPressed: (){},),);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text('New Post',
            style: TextStyle(
              color: Colors.white,
            ),),
          actions: [
            TextButton(onPressed: () {
              cubit.addPost(imageFile: imageFile, postContent: postContentController.text);
            }, child: Text(
              'Share',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 18.sp,
              ),
            ))
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(10.sp),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 15.sp),
                  width: 30.w,
                  child: Image.file(
                    imageFile,
                    fit: BoxFit.contain,
                  )),
              Expanded(
                child: TextFormField(
                  //validator:
                  //(value){
                  //   if(value!.isEmpty){
                  //     return 'write post content';
                  //   }
                  //   return null;
                  //
                  // },
                  controller: postContentController,
                  style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                  decoration: InputDecoration(
                      hintText: "Write a caption.",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                          color: Colors.grey, fontSize: 16.sp)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
