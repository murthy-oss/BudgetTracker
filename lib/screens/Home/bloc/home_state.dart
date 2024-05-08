part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

class HomeActionState extends HomeState{}

class FetchDateAction extends HomeActionState{}
 
class HomeListOfItemsFromDateState extends HomeState{}
 
class LogOutState extends HomeActionState{}
class AddNewElementState extends HomeActionState{}

