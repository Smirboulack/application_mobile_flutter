import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sevenapplication/core/models/Conversation.dart';

@immutable
abstract class HomeEvent extends Equatable {
  HomeEvent([List props = const <dynamic>[]]) : super();
}
class FetchHomeChatsEvent extends HomeEvent{
  @override
  String toString() => 'FetchHomeChatsEvent';

  @override
  // TODO: implement props
  List<Object> get props => [];
}
class ReceivedChatsEvent extends HomeEvent{
  final List<Conversation> conversations;
  ReceivedChatsEvent(this.conversations);

  @override
  String toString() => 'ReceivedChatsEvent';

  @override
  // TODO: implement props
  List<Object> get props => [];

}