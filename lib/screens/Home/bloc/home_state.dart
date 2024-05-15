part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

class HomeActionState extends HomeState{}


 
class HomeListOfItemsFromDateState extends HomeActionState{
 
    final List<ExpenseItemModel> expenses ;
    final DateTime selectedDate;

  HomeListOfItemsFromDateState(this.selectedDate, this.expenses);
}
 
class LogOutState extends HomeActionState{}
class AddNewElementState extends HomeActionState{}
class AddNewElementSuccessState extends HomeActionState{}
class TotalAmontCaluculatingSate extends HomeActionState{}
class DeleteItemFromHomeListState extends HomeActionState
{
   final String documentId;

  DeleteItemFromHomeListState(this.documentId);
  
}

class TotalAmountCalculateState extends HomeActionState{
  final int totalAmount;

  TotalAmountCalculateState(this.totalAmount);

}

class DateSelectedState extends HomeActionState {
  final DateTime selectedDate;

  DateSelectedState(this.selectedDate);
}



class HomePageLoading extends HomeState {}

class HomePageLoaded extends HomeState {
  final User user;

  HomePageLoaded(this.user);
}

class HomePageNotLoggedIn extends HomeState {}

class HomePageError extends HomeState {}

class HomePageIndexChanged extends HomeState {
  final int index;

  HomePageIndexChanged(this.index);
}

class EditButtonNavigationState extends HomeActionState {
  final String documentId;
  
  final String categoryName;
  final String amount;
  final String date;
  final String color;

  EditButtonNavigationState(this.documentId, this.categoryName, this.amount, this.date, this.color);

  
}

class UpdateButtonNavigationState extends HomeActionState {
  final String documentId;
  
  final String categoryName;
  final String amount;
  final String date;
  final String color;

  UpdateButtonNavigationState( this.documentId,this.categoryName, this.amount, this.date, this.color);

  
}
class PieChartBuildState extends HomeActionState {
   Map<String, double> dataMap;
    final DateTime selectedDate;
    List<ExpenseItemModel> expenses =[];
  List<Color> colors;
  PieChartBuildState(this.selectedDate,this.expenses, {
    required this.dataMap,
    required this.colors,
  });
 
  

}