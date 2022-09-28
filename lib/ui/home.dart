import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/bussiness_logic/show_posts/show_posts_cubit.dart';
import 'package:instagram/ui/comments_screen.dart';
import 'package:instagram/ui/maps_screen.dart';
import 'package:instagram/ui/post_screen.dart';
import 'package:instagram/ui/story_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../data/models/post.dart';
import '../data/models/story.dart';
import 'chats.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late ShowPostsCubit cubit;
  @override
  void initState() {
    // TODO: implement initState
    cubit=BlocProvider.of<ShowPostsCubit>(context);
    super.initState();
    cubit.getPosts();
    cubit.getHomeStories();
  }
  @override
  Widget build(BuildContext context) {
    return BlocListener<ShowPostsCubit, ShowPostsStates>(
  listener: (context, state) {
    if (state is ShowPostsFailState){
      print(state.errorMessege);
      SnackBar snackBar=SnackBar(content: Text(state.errorMessege),
        action: SnackBarAction(label: 'ok',onPressed: (){},),);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    else if (state is GetStoryDetailsSuccessState) {
      onShowStoryTapped(state.storyDetails);
    }
     else if (state is AddStoryFailState){
      print(state.errorMessege);
      SnackBar snackBar=SnackBar(content: Text(state.errorMessege),
        action: SnackBarAction(label: 'ok',onPressed: (){},),);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    else if (state is AddStorySuccessState){
      SnackBar snackBar=const SnackBar(content: Text('Story added successfully'),
       );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    },
  child: Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(foregroundColor: Colors.white,
        backgroundColor:Colors.black,
        title: Text('Instagram'),actions: [
        IconButton(onPressed: (){
          onAddBoxPressed();
        }, icon: Icon(Icons.add_box_outlined),),
        IconButton(onPressed: (){}, icon: Icon(Icons.favorite_border),),
        IconButton(onPressed: (){
          onChatIconTapped();
        }, icon: Icon(Icons.chat_outlined),),
      ],),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
          SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    InkWell(
                      onTap: (){
                        onAddStoryTapped();
                      },
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://track2traininginstitute.files.wordpress.com/2021/08/android-vs-ios_1200x675.jpg',),
                          radius: 25.sp,),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(backgroundColor: Colors.black,radius: 16.sp,),
                              CircleAvatar(backgroundColor: Colors.blue,
                              child: Icon(Icons.add,color: Colors.white,
                              size: 18.sp,),radius: 14.sp,),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.sp,),
                    Text('Your Story',style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp
                    ),)],),
                SizedBox(width:10.sp),
                Expanded(child: SizedBox(
                  height: 45.sp,
                  child: BlocBuilder<ShowPostsCubit, ShowPostsStates>(
                   buildWhen: (previous, current) {
                    return current is GetHomeStoriesSuccessState
                    || current is AddStorySuccessState;
                   },
                    builder: (context, state) {
                    return ListView.separated(itemBuilder: (context,index)=>
                        buildStoryItem(index),
                      separatorBuilder: (context,index)=>const SizedBox(width: 10,),
                      itemCount: cubit.homeStories.length,
                  scrollDirection: Axis.horizontal,);
  },
),
                ))
              ],
            ),
          ),
          SizedBox(height: 10.sp,),
          BlocBuilder<ShowPostsCubit, ShowPostsStates>(
            buildWhen: (previous, current) {
              return current is ShowPostsSuccessState ||
              current is LikePostSuccessState ||current is UnlikePostSuccessState;
            },
            builder: (context, state) {
              return ListView.separated(itemBuilder: (context,index)=>buildPostItem(cubit.postsList[index],index),
                reverse: true,
                separatorBuilder: (context,index)=>const SizedBox(height: 10,),
                itemCount: cubit.postsList.length,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              );
  },
)
        ],),
      ),
    ),
);
  }

  buildStoryItem(int index){
    Story story=cubit.homeStories[index];
    return InkWell(
      onTap: (){
        cubit.getStoriesDetails(story.userId!);
        //onShowStoryTapped();
      },
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(radius: 25.sp,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff833ab4),
                      Color(0xfffcb045),
                      Color(0xfffd1d1d),
                    ]
                  ),
                ),
              ),),
              CircleAvatar(
                backgroundImage: NetworkImage(story.storyImageUrl!),
              radius: 24.sp,),

            ],
          ),
          SizedBox(height: 14.sp,),
          Text(story.username!,style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp
          ),)
        ],
      ),
    );
  }

  buildPostItem(Post post, int index){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.all(7),
        child:Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(radius: 21.sp,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          colors: [
                            Color(0xff833ab4),
                            Color(0xfffcb045),
                            Color(0xfffd1d1d),
                          ]
                      ),
                    ),
                  ),),
                CircleAvatar(
                  backgroundImage: NetworkImage(post.userImageUrl),
                  radius: 20.sp,),
              ],
            ),
            SizedBox(width: 10.sp,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
               children:[
                 Text(post.username
                   //'Nada Mohamed'
                   ,style: TextStyle(
                   fontSize: 16.sp,
                   fontWeight: FontWeight.bold
                     ,color: Colors.white,

                 ),),
                 SizedBox(height: 8.sp,),
                 InkWell(
                   onTap: (){
                     Navigator.of(context).push(MaterialPageRoute(
                       builder: (context) => MapsScreen(),
                     ));
                   },
                   child: Text('Cairo,Nasr City'
                     //'Meenu island resort&spa meenu island resort&spa meenu island resort&spa '
                     ,style: TextStyle(
                       overflow: TextOverflow.ellipsis,
                     color: Colors.white,
                     fontSize: 15.sp,

                   ),),
                 ),

               ]
              ),
            ),
          ],
        ),),
        Image(
          fit: BoxFit.cover,
          height: 60.sp,
          width: double.infinity,
          image: NetworkImage(
              post.postImageUrl
            //'https://track2traininginstitute.files.wordpress.com/2021/08/android-vs-ios_1200x675.jpg'
        ),),

        Padding(padding: EdgeInsets.all(9.sp)
        ,child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(onPressed: (){
                    if(post.isLiked){
                      cubit.unlikePost(postId: post.postId);
                      cubit.postsList[index].isLiked=false;
                      cubit.postsList[index].likesCount--;
                    }
                    else{
                      cubit.likePost(postId: post.postId);
                      cubit.postsList[index].isLiked=true;
                      cubit.postsList[index].likesCount++;
                    }
                  }, icon:
                  Icon(
                    post.isLiked?Icons.favorite:Icons.favorite_border,color: Colors.white,)),
                  IconButton(onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CommentsScreen(postId: post.postId,),
                    ));
                  }, icon:
                  Icon(Icons.mode_comment_outlined,color: Colors.white,)),
                  IconButton(onPressed: (){}, icon:
                  Icon(Icons.send_outlined,color: Colors.white,)),
                ],
              ),
             IconButton(onPressed: (){

             },
               icon:  Icon(Icons.bookmark_border,color: Colors.white,),)
            ],
          ),),
        Padding(padding: EdgeInsets.only(left:18.sp),
            child:Text(post.likesCount.toString(),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),)),
        SizedBox(height: 10.sp,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.sp),
          child:RichText(
            text:  TextSpan(
              children: [
                TextSpan(
                  text: '${post.username}'+'  ',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900
                    ,color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: post.postContent.toString(),
                  style: TextStyle(
                    fontSize: 15.sp
                    ,color: Colors.white,

                  ),
                ),
              ]
            ),
          ) ,
        ),
      ],
    );
  }

  onAddBoxPressed(){
    showMenu(
        context: context,
        position:const RelativeRect.fromLTRB(100, 80, 99.8, 100) ,
        items: [
          PopupMenuItem(
              value: '1',
              child: Row(
            children: [
              Text('Post',style: TextStyle(color: Colors.white),),
              Spacer(),
              Icon(Icons.post_add,color: Colors.white),
            ],
          )),
          PopupMenuItem(
              value: '2',
              child: Row(
            children: [
              Text('Story',style: TextStyle(color: Colors.white),),
              Spacer(),
              Icon(Icons.add_circle_outline,color: Colors.white,),
            ],
          )),
          PopupMenuItem(
              value: '3',
              child: Row(
            children: [
              Text('Real',style: TextStyle(color: Colors.white),),
              Spacer(),
              Icon(Icons.live_tv,color: Colors.white),
            ],
          )),
          PopupMenuItem(
              value: '4',
              child: Row(
            children: [
              Text('Live',style: TextStyle(color: Colors.white),),
              Spacer(),
              Icon(Fontisto.livestream,color: Colors.white),
            ],
          )),

        ],
      elevation: 8.0,
    color: Color(0xD6000000),

      shape: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),),
    ).then<void>((String? itemSelected) {
      if (itemSelected == null) return;

      if (itemSelected == "1") {
        pickImage();
      } else if (itemSelected == "2") {
        //code here
      } else {
        //code here
      }
    });
  }

  pickImage(){
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    _picker.pickImage(source: ImageSource.gallery).then((value) {
      File file = File(value!.path);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostScreen(
              imageFile: file,
            ),
          ))
          //ال.then مش هتتنفذ غير لما اروح الpostscreen  و اقفلها تانى عنى لما ارجع تانى ال home ال.then  هتشتغل
          .then((value) => cubit.getPosts());
  });
  }

  onShowStoryTapped(List<Story> storyDetails) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => StoryScreen(storyDetails),
    ));
  }
  onChatIconTapped() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ChatsScreen(),
    ));
  }
  void onAddStoryTapped()async {
    final ImagePicker picker=ImagePicker();
    // final XFile? image=await picker.pickImage(source: ImageSource.gallery);
    // File file=File(image!.path);
    // cubit.addStory(file);
    final List<XFile>? images =await picker.pickMultiImage();

    List<File> paths = images!.map((xFile) => File(xFile.path)).toList();

    cubit.addStories(paths);

  }
}




