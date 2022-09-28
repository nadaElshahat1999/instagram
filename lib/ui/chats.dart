import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram/bussiness_logic/get_users/get_users_cubit.dart';
import 'package:instagram/data/models/user.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'chatting.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  late GetUsersCubit cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of<GetUsersCubit>(context);
    cubit.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetUsersCubit, GetUsersStates>(
      listener: (context, state) {
        if (state is GetUsersFailState) {
          print(state.errorMessege);
          SnackBar snackBar = SnackBar(content: Text(state.errorMessege),
            action: SnackBarAction(label: 'ok', onPressed: () {},),);
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(foregroundColor: Colors.white,
          backgroundColor: Colors.black,
          title: Text('Chats'),),
        body: Container(
          color: Colors.black,
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<GetUsersCubit, GetUsersStates>(
            buildWhen: (previous, current) => current is GetUsersSuccessState,
            builder: (context, state) {
              return ListView.separated(
                itemBuilder: (context, index) => buildChatItem(index),
                separatorBuilder: (context, index) =>
                const SizedBox(height: 10,),
                itemCount: cubit.usersList.length,
              );
            },
          ),
        ),
      ),
    );
  }

  buildChatItem(int index) {
    MyUser user = cubit.usersList[index];
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChattingScreen(user: user),
            ));
      },
      child: Row(
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
                backgroundImage: NetworkImage(user.profileImageUrl!),
                radius: 24.sp,),

            ],
          ),
          SizedBox(width: 14.sp,),
          Text(user.username!, style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 17.sp
          ),)
        ],
      ),
    );
  }
}
