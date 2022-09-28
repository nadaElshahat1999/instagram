import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/data/models/message.dart';
import 'package:meta/meta.dart';

part 'chatting_state.dart';

class ChattingCubit extends Cubit<ChattingStates> {
  ChattingCubit() : super(ChattingInitialState());

  void sendMessage(Message message)async{
    await FirebaseFirestore.instance
        .collection('flutterUsers')
        .doc(message.senderId)
        .collection('chats')
        .doc(message.reciverId)
        .collection('messages')
        .doc(message.messageId)
        .set(message.toJson()).catchError((error){
      emit(SendMessageFailState(error.toString()));});

    await FirebaseFirestore.instance
        .collection('flutterUsers')
        .doc(message.reciverId)
        .collection('chats')
        .doc(message.senderId)
        .collection('messages')
        .doc(message.messageId)
        .set(message.toJson()).catchError((error){
          emit(SendMessageFailState(error.toString()));
    });

    emit(SendMessageSuccessState());
  }
  List<Message> messages=[];
  Future<void> getMessages(String receiverId)async{
    await FirebaseFirestore.instance
        .collection('flutterUsers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .get().then((value) {
          messages.clear();
          for (var element in value.docs) {
            Message message=Message.fromJson(element.data());
            messages.add(message);
          }
          print(messages.length);
          emit(GetMessagesSuccessState());
    }).catchError((error){
      emit(GetMessagesFailState(error.toString()));
    });
  }
  void listenToMessages(String receiverId)async{
    await FirebaseFirestore.instance
        .collection('flutterUsers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy("time")
        .limitToLast(1)
        .snapshots()
        .listen((event) { 
          for (var element in event.docs) {
            print(event.docs.length);
            Message message = Message.fromJson(element.data());
            if(messages.length>0){
            if (message.time != messages.last.time) {
              messages.add(message);
              print(message.message);
              emit(GetMessagesSuccessState());
              emit(ListenToMessagesSuccessState());
            }
          }
            else{
              messages.add(message);
              print(message.message);
              emit(GetMessagesSuccessState());
              emit(ListenToMessagesSuccessState());
            }
          }
    });
  }
}
