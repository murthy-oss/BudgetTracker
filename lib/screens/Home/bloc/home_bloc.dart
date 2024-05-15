import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:expensemate/screens/Home/DataModel/ExpenseItem.dart';
import 'package:expensemate/screens/Home/core/Firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FirebaseAuth _auth;
  HomeBloc(this._auth) : super(HomeInitial()) {
    on<AddNewElementEvent>(addNewElementEvent);
    on<LogOutEvent>(logOutState);
    on<FetchUserData>(_onFetchUserData);
    on<ChangePageIndex>(_onChangePageIndex);
    on<DateSelectedEvent>(_dateSelectedEvent);
    on<AddNewElementSuccessEvent>(_addNewElementSuccessEvent);
    on<TotalAmountCalculateEvent>(_totalAmountCalculateEvent);
    on<HomeListOfItemsFromDateEvent>(_homeListOfItemsFromDateEvent);
    on<DeleteItemFromHomeListEvent>(_deleteItemFromHomeListEvent);
    on<EditButtonNavigationEvent>(_editButtonNavigationEvent);
    on<UpdateButtonNavigationEvent>(_updateButtonNavigationEvent);
    on<PieChartBuildEvent>(_pieChartBuildEvent);
  }

  FutureOr<void> logOutState(LogOutEvent event, Emitter<HomeState> emit) {
    print("logout ra");
    emit(LogOutState());
  }

  FutureOr<void> _onFetchUserData(
      FetchUserData event, Emitter<HomeState> emit) {
    try {
      emit(HomePageLoading());
      final user = _auth.currentUser;
      if (user != null) {
        emit(HomePageLoaded(user));
      } else {
        emit(HomePageNotLoggedIn());
      }
    } catch (_) {
      emit(HomePageError());
    }
  }

  FutureOr<void> _onChangePageIndex(
      ChangePageIndex event, Emitter<HomeState> emit) {
    print(event.index);

    emit(HomePageIndexChanged(event.index));
  }

  FutureOr<void> addNewElementEvent(
      AddNewElementEvent event, Emitter<HomeState> emit) {
    print("Add New Element");
    emit(AddNewElementState());
  }

  FutureOr<void> _dateSelectedEvent(
      DateSelectedEvent event, Emitter<HomeState> emit) {
    print(event.selectedDate);
    emit(DateSelectedState(event.selectedDate));
  }

  FutureOr<void> _addNewElementSuccessEvent(
      AddNewElementSuccessEvent event, Emitter<HomeState> emit) {
    emit(AddNewElementSuccessState());
  }

  Future<FutureOr<void>> _totalAmountCalculateEvent(
      TotalAmountCalculateEvent event, Emitter<HomeState> emit) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? userauth = auth.currentUser;
    emit(TotalAmontCaluculatingSate());
    int totalAmount = 0; // Initialize total amount to 0

    await db.collection('${userauth!.email}').get().then((event) {
      for (var doc in event.docs) {
        print('${doc.id}docdata${doc.data()}');
        print(doc['Amount']);

        // Parse the Amount field to an integer and add it to the total
        int amount = int.tryParse(doc['Amount'].toString()) ?? 0;
        totalAmount += amount;
      }
      //_homeBloc.add(TotalAmountCalculateEvent(totalAmount));
    });

    print('total amount ho:${totalAmount}');
    emit(TotalAmountCalculateState(totalAmount));
  }

  Future<FutureOr<void>> _homeListOfItemsFromDateEvent(
      HomeListOfItemsFromDateEvent event, Emitter<HomeState> emit) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? userauth = auth.currentUser;

    List<ExpenseItemModel> reversedExpenses = [];
    DateTime _selectDate = event.selectedDate;
    print(event.selectedDate);
    print("vasthundhi");

    // Initialize total amount to 0

    await db.collection('${userauth!.email}').get().then((Event) {
      event.expenses = [];
      for (var doc in Event.docs) {
        print('${doc.id}docdata${doc.data()}');
        print(doc['Amount']);

        // Parse the Amount field to an integer and add it to the total
        if ('${doc['date'].toString().substring(0, 10)}' ==
            '${event.selectedDate.toString().substring(0, 10)}') {
          print('${event.selectedDate.toString().substring(0, 10)}');
          event.expenses.add(ExpenseItemModel(
            amount: doc['Amount'],
            color: doc['Color'],
            categoryName: doc['category name'],
            date: doc['date'],
            Id: '${doc.id}',
          ));
        }
      }
    });
    reversedExpenses = event.expenses.reversed.toList();
    emit(HomeListOfItemsFromDateState(_selectDate, reversedExpenses));
  }

  Future<FutureOr<void>> _deleteItemFromHomeListEvent(
      DeleteItemFromHomeListEvent event, Emitter<HomeState> emit) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? userauth = auth.currentUser;
    try {
      // Attempt to delete the document
      await db.collection('${userauth!.email}').doc(event.documentId).delete();
      // If the deletion is successful, return true
      emit(DeleteItemFromHomeListState(event.documentId));
    } catch (e) {
      // If an error occurs during deletion, return false
      print("Error deleting document: $e");
      return false;
    }
  }

  FutureOr<void> _editButtonNavigationEvent(
      EditButtonNavigationEvent event, Emitter<HomeState> emit) {
    emit(EditButtonNavigationState(event.documentId, event.categoryName,
        event.amount, event.date, event.color));
  }

  FutureOr<void> _updateButtonNavigationEvent(
      UpdateButtonNavigationEvent event, Emitter<HomeState> emit) {
    FirebaseAuth auth = FirebaseAuth.instance;

    // Get the current user
    User? userauth = auth.currentUser;
    // [START get_started_add_data_1]
    // Create a new user with a first and last name
    print("Ekkadaki vacchindhi");
    final user = <String, dynamic>{
      "date": event.date,
      "category name": event.categoryName,
      "Amount": event.amount,
      "Color": event.color,
    };
    db
        .collection('${userauth!.email}')
        .doc(event.documentId)
        .update(user)
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
    emit(UpdateButtonNavigationState(event.documentId, event.categoryName,
        event.amount, event.date, event.color));
  }

  Future<FutureOr<void>> _pieChartBuildEvent(PieChartBuildEvent event, Emitter<HomeState> emit) async {

     FirebaseAuth auth = FirebaseAuth.instance;
    User? userauth = auth.currentUser;
    DateTime _selectDate=event.selectedDate;
    //int totalAmount = 0; // Initialize total amount to 0
List<Color> _colors = event.colors;
  Map<String, double> dataMap = event.dataMap;
  List<ExpenseItemModel> expenses = [];
  List<ExpenseItemModel> reversedExpenses = [];
    await db.collection('${userauth!.email}').get().then((event) {
      expenses = [];
      // dataMap={};
      for (var doc in event.docs) {
        print('${doc.id}docdata${doc.data()}');
        print(doc['Amount']);

        // Parse the Amount field to an integer and add it to the total
        if ('${doc['date'].toString().substring(0, 10)}' ==
            '${_selectDate.toString().substring(0, 10)}') {
          print('${_selectDate.toString().substring(0, 10)}');
          expenses.add(ExpenseItemModel(
            amount: doc['Amount'],
            color: doc['Color'],
            categoryName: doc['category name'],
            date: doc['date'],
            Id: '${doc.id}',
          ));
          int amount = int.tryParse(doc['Amount'].toString()) ?? 0;
          dataMap.putIfAbsent(doc['category name'], () => amount / 100);

          _colors.add(doc['Color'].toString() == 'Blue'
              ? Colors.blue
              : doc['Color'].toString() == 'Red'
                  ? Colors.red
                  : doc['Color'].toString() == 'Yellow'
                      ? Colors.yellow
                      : doc['Color'].toString() == 'Orange'
                          ? Colors.orange
                          : doc['Color'].toString() == 'Green'
                              ? Colors.green
                              : Colors.black);
        }
        print("Color$_colors");
      }
    });
    reversedExpenses = expenses.reversed.toList();
   emit(PieChartBuildState(colors: _colors,dataMap: dataMap,_selectDate,reversedExpenses));
  }
}
