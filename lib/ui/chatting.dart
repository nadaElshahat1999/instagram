import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/bussiness_logic/chatting/chatting_cubit.dart';
import 'package:instagram/data/models/message.dart';
import 'package:instagram/data/models/user.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ChattingScreen extends StatefulWidget {
  final MyUser user;

  ChattingScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  final ScrollController _controller = ScrollController(initialScrollOffset: 50.0);
  var messageController = TextEditingController();
  late ChattingCubit cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of<ChattingCubit>(context);
    cubit.getMessages(widget.user.userId!).then((value) {
      cubit.listenToMessages(widget.user.userId!);
    });


  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<ChattingCubit, ChattingStates>(
      listener: (context, state) {
        if (state is SendMessageFailState) {
          print(state.errorMessage);
          SnackBar snackBar = SnackBar(content: Text(state.errorMessage),
            action: SnackBarAction(label: 'ok', onPressed: () {},),);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
         if (state is SendMessageSuccessState) {
          SnackBar snackBar = SnackBar(content: Text('message sent successfully'),
            action: SnackBarAction(label: 'ok', onPressed: () {},),);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

        }
         if (state is ListenToMessagesSuccessState) {
         _scrollDown();
        }

      },
      child: Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: FloatingActionButton.small(
          elevation: 10,
          onPressed: _scrollDown,
          child: Icon(Icons.arrow_downward),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
                    backgroundImage: NetworkImage(widget.user.profileImageUrl!),
                    radius: 20.sp,),

                ],
              ),
              SizedBox(width: 14.sp,),
              Text(widget.user.username!, style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17.sp
              ),)
            ],
          ),
        ),
        body: Column(
          children: [
            buildChattingListView(),
            buildMessageTextFormField(),
          ],
        ),
      ),
    );
  }

  Widget buildChattingListView() {
    return Expanded(
      child: BlocBuilder<ChattingCubit, ChattingStates>(
        buildWhen: (previous, current) => current is GetMessagesSuccessState,
        builder: (context, state) {
          return ListView.separated(
            controller: _controller,
            itemBuilder: (context, index)  {
            Message message = cubit.messages[index];

              if (message.senderId == FirebaseAuth.instance.currentUser!.uid){
            return buildSenderMessage(message.message);
          }
              else {
          return buildReceiverMessage(message.message);
              }
          },
            separatorBuilder: (context, index) => const SizedBox(width: 10,),
            itemCount: cubit.messages.length,
          );
        },
      ),
    );
  }
  void _scrollDown() {
    _controller.jumpTo(_controller.position.maxScrollExtent);
  }

  Widget buildReceiverMessage(String? message) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Container(
        margin:
        EdgeInsets.only(top: 10.sp, bottom: 10.sp, right: 25.w,
          left: 15.sp,),
        padding: EdgeInsets.symmetric(
          vertical: 15.sp,
          horizontal: 15.sp,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.sp),
            topRight: Radius.circular(15.sp),
            bottomRight: Radius.circular(15.sp),
          ),
          color: Colors.white,
        ),
        child: Text(message!,
          style: TextStyle(fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildSenderMessage(String? message) {
    return Container(
      alignment: Alignment.centerRight,
      child: Container(
        margin:
        EdgeInsets.only(top: 10.sp, bottom: 10.sp, right: 15.sp, left: 25.w),
        padding: EdgeInsets.symmetric(
          vertical: 15.sp,
          horizontal: 15.sp,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.sp),

            topRight: Radius.circular(15.sp),
            bottomLeft: Radius.circular(15.sp),
          ),
          color: Colors.lightBlueAccent[100],
        ),
        child: Text(
          message!,
          style: TextStyle(fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildMessageTextFormField() {
    return Container(
      padding: EdgeInsets.all(10.sp),
      margin: EdgeInsets.all(15.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.sp),
      ),
      child: Row(
        children: [
          Expanded(child: TextFormField(
            controller: messageController,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'write your message',
              hintStyle: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp
              ),
            ),
          )
          ),
          IconButton(onPressed: () {
            sendMessage();
          },
              icon: Icon(Icons.send, color: Colors.lightBlueAccent[200],
              )),
        ],
      ),
    );
  }

  void sendMessage() {
    String messageContent = messageController.text.toString();
    String senderId = FirebaseAuth.instance.currentUser!.uid;
    String time = DateTime.now().toString();
    Message message = Message(messageId: time + senderId,
        senderId: senderId,
        message: messageContent,
        reciverId: widget.user.userId,
        time: time);
    cubit.sendMessage(message);
    messageController.clear();
  }
}
