part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}
class HomeListOfItemsFromDateEvent extends HomeEvent{}
class LogOutEvent extends HomeEvent{}
class AddNewElementEvent extends HomeEvent{}
class FetchDateEvent extends HomeEvent{}