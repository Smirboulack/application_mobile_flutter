import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sevenapplication/core/models/Conversation.dart';

@immutable
abstract class HomeState extends Equatable {
  HomeState([List props = const <dynamic>[]]) : super();
}

class InitialHomeState extends HomeState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FetchingHomeChatsState extends HomeState{
  @override
  String toString() => 'FetchingHomeChatsState';

  @override
  // TODO: implement props
  List<Object> get props => [];
}
class FetchedHomeChatsState extends HomeState{
  List<Conversation> conversations;

  FetchedHomeChatsState(this.conversations);

  @override
  String toString() => 'FetchedHomeChatsState';

  @override
  // TODO: implement props
  List<Object> get props => [];
}
