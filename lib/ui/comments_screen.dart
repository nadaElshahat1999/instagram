import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/bussiness_logic/comment/comment_cubit.dart';
import 'package:instagram/bussiness_logic/myShared.dart';
import 'package:instagram/data/models/comment.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CommentsScreen extends StatefulWidget {
  late String postId;
   CommentsScreen({Key? key,required this.postId}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late CommentCubit cubit;
  TextEditingController commentController=TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit=BlocProvider.of<CommentCubit>(context);
    cubit.comments.clear();
    cubit.getComments(postId: widget.postId);
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<CommentCubit, CommentStates>(
  listener: (context, state) {
    if(state is AddCommentSuccessState){
      commentController.clear();
      cubit.getComments(postId: widget.postId);
    }
    else if (state is AddCommentFailState){
      print(state.errorMessege);
      SnackBar snackBar=SnackBar(content: Text(state.errorMessege),
        action: SnackBarAction(label: 'ok',onPressed: (){},),);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    if(state is AddCommentSuccessState){

    }
    else if (state is AddCommentFailState){
      print(state.errorMessege);
      SnackBar snackBar=SnackBar(content: Text(state.errorMessege),
        action: SnackBarAction(label: 'ok',onPressed: (){},),);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

  },
  child: Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Comments',
        style: TextStyle(color: Colors.white,),),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: buildCommentsList(),
          ),
          Padding(
            padding: EdgeInsets.all(20.sp),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(MyShared.getString('profileImageUrl')),
                  radius: 22.sp,),
                SizedBox(width: 10.sp,),
                Expanded(
                  child: TextFormField(
                    controller: commentController,
                    textInputAction: TextInputAction.send,
                    validator: (value){
                      if(value!.isEmpty){
                        return 'add comment';
                      }
                    },
                    onFieldSubmitted: (value){
                      cubit.addNewComment(comment: value.toString(), postId: widget.postId);
                    },
                    style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                    decoration: InputDecoration(
                        hintText: "Add a comment",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 15.sp,
                        fontWeight: FontWeight.bold),
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0.sp),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0.sp),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 2.0.sp,
                        ),
                      ),),


                  ),
                )
              ],
            ),
          ),
          space(),
        ],
      ),
    ),
);
  }

  space() {
    if (Platform.isIOS) {
      return SizedBox(
        height: 19.sp,
      );
    }
    else{
      return const SizedBox(height: 0,);
    }
  }

  buildComment(Comment comment){
    return Padding(padding: EdgeInsets.all(16.sp),
      child:Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
                comment.userImageUrl),
            radius: 18.sp,),
          SizedBox(width: 10.sp,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text:  TextSpan(
                      children: [
                        TextSpan(
                          text: '${comment.username}' +'  ',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w900
                            ,color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: comment.comment,
                          style: TextStyle(
                            fontSize: 15.sp
                            ,color: Colors.white,

                          ),
                        ),
                      ]
                  ),
                ),
                Text(comment.commentTime,
                style: TextStyle(color: Colors.grey,
                fontSize: 15.sp),)
              ],
            ),
          ),
        ],
      ),);
  }

  buildCommentsList() {
    return BlocBuilder<CommentCubit, CommentStates>(
      buildWhen: (previous, current) => current is GetCommentsSuccessState,
  builder: (context, state) {
    return ListView.builder(
      //physics: NeverScrollableScrollPhysics(),
      //shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder:(context,index) {
        Comment comment=cubit.comments[index];
        return buildComment(comment);
      },
      itemCount: cubit.comments.length,);
  },
);
  }
}
