// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}
class HomeListOfItemsFromDateEvent extends HomeEvent{
  final DateTime selectedDate;
   List<ExpenseItemModel> expenses =[];

  HomeListOfItemsFromDateEvent(this.selectedDate, this.expenses);
  

 
}

class DeleteItemFromHomeListEvent extends HomeEvent
{
  final String documentId;

  DeleteItemFromHomeListEvent(this.documentId);
}
class LogOutEvent extends HomeEvent{}
class AddNewElementEvent extends HomeEvent{}
class AddNewElementSuccessEvent extends HomeEvent{}

class FetchUserData extends HomeEvent {}
class DateSelectedEvent extends HomeEvent {
  final DateTime selectedDate;

  DateSelectedEvent(this.selectedDate);
}
class TotalAmontCaluculatingEvent extends HomeEvent{}

class TotalAmountCalculateEvent extends HomeEvent{
  final int totalAmount;

  TotalAmountCalculateEvent(this.totalAmount);
}

class ChangePageIndex extends HomeEvent {
  final int index;

  ChangePageIndex(this.index,);
}
class EditButtonNavigationEvent extends HomeEvent {
  final String documentId;
  
  final String categoryName;
  final String amount;
  final String date;
  final String color;

  EditButtonNavigationEvent(this.documentId, this.categoryName, this.amount, this.date, this.color);

  
}

class UpdateButtonNavigationEvent extends HomeEvent {
  final String documentId;
  
  final String categoryName;
  final String amount;
  final String date;
  final String color;

  UpdateButtonNavigationEvent(this.documentId, this.categoryName, this.amount, this.date, this.color);

  
}

class PieChartBuildEvent extends HomeEvent {
   Map<String, double> dataMap;
    final DateTime selectedDate;
    List<ExpenseItemModel> expenses =[];
  List<Color> colors;
  PieChartBuildEvent(this.selectedDate,this.expenses, {
    required this.dataMap,
    required this.colors,
  });
 
  

}
