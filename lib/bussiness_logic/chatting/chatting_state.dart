part of 'chatting_cubit.dart';

@immutable
abstract class ChattingStates {}

class ChattingInitialState extends ChattingStates {}
class SendMessageSuccessState extends ChattingStates {

}
class SendMessageFailState extends ChattingStates {
  final errorMessage;
  SendMessageFailState(this.errorMessage);
}
class GetMessagesSuccessState extends ChattingStates {

}
class GetMessagesFailState extends ChattingStates {
  final errorMessage;
  GetMessagesFailState(this.errorMessage);
}
class ListenToMessagesSuccessState extends ChattingStates {

}
class ListenToMessagesFailState extends ChattingStates {
  final errorMessage;
  ListenToMessagesFailState(this.errorMessage);
}
