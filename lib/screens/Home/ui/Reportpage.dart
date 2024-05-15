import 'package:expensemate/screens/Home/DataModel/ExpenseItem.dart';
import 'package:expensemate/screens/Home/bloc/home_bloc.dart';
import 'package:expensemate/screens/Home/core/Firestore.dart';
import 'package:expensemate/screens/Home/ui/LoadingScreen.dart';
import 'package:expensemate/screens/Home/ui/addItemspage.dart';
import 'package:expensemate/screens/Home/ui/editItemScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pie_chart/pie_chart.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  DateTime _selectedDate = DateTime.now(); // Initial selected date

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000), // Minimum selectable date
      lastDate: DateTime.now(), // Maximum selectable date
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        dataMap.clear();
        _colors.clear();
       _homeBloc.add(PieChartBuildEvent(_selectedDate, dataMap: dataMap, colors: _colors,expenses));
      });
    }
  }

  List<Color> _colors = [];
  Map<String, double> dataMap = {};
  List<ExpenseItemModel> expenses = [];
  List<ExpenseItemModel> reversedExpenses = [];
  // Future<List<ExpenseItemModel>> read_data_List() async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   User? userauth = auth.currentUser;

  //   //int totalAmount = 0; // Initialize total amount to 0

  //   await db.collection('${userauth!.email}').get().then((event) {
  //     expenses = [];
  //     // dataMap={};
  //     for (var doc in event.docs) {
  //       print('${doc.id}docdata${doc.data()}');
  //       print(doc['Amount']);

  //       // Parse the Amount field to an integer and add it to the total
  //       if ('${doc['date'].toString().substring(0, 10)}' ==
  //           '${_selectedDate.toString().substring(0, 10)}') {
  //         print('${_selectedDate.toString().substring(0, 10)}');
  //         expenses.add(ExpenseItemModel(
  //           amount: doc['Amount'],
  //           color: doc['Color'],
  //           categoryName: doc['category name'],
  //           date: doc['date'],
  //           Id: '${doc.id}',
  //         ));
  //         int amount = int.tryParse(doc['Amount'].toString()) ?? 0;
  //         dataMap.putIfAbsent(doc['category name'], () => amount / 100);

  //         _colors.add(doc['Color'].toString() == 'Blue'
  //             ? Colors.blue
  //             : doc['Color'].toString() == 'Red'
  //                 ? Colors.red
  //                 : doc['Color'].toString() == 'Yellow'
  //                     ? Colors.yellow
  //                     : doc['Color'].toString() == 'Orange'
  //                         ? Colors.orange
  //                         : doc['Color'].toString() == 'Green'
  //                             ? Colors.green
  //                             : Colors.black);
  //       }
  //       print("Color$_colors");
  //     }
  //   });
  //   reversedExpenses = expenses.reversed.toList();
  //   return reversedExpenses; // Return the total amount after processing all documents
  // }

  Future<int> read_data() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? userauth = auth.currentUser;

    int totalAmount = 0; // Initialize total amount to 0

    await db.collection('${userauth!.email}').get().then((event) {
      for (var doc in event.docs) {
        print('${doc.id}docdata${doc.data()}');
        print(doc['Amount']);

        // Parse the Amount field to an integer and add it to the total
        int amount = int.tryParse(doc['Amount'].toString()) ?? 0;
        totalAmount += amount;
      }
    });

    return totalAmount; // Return the total amount after processing all documents
  }

  @override
  void initState() {
     _homeBloc.add(HomeListOfItemsFromDateEvent(_selectedDate, expenses));
     _homeBloc.add(PieChartBuildEvent(_selectedDate, dataMap: dataMap, colors: _colors,expenses));
         //_homeBloc.add(TotalAmountCalculateEvent(totalAmount));
     

    //read_data_List();
    super.initState();
  }
  HomeBloc _homeBloc=HomeBloc(FirebaseAuth.instance);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if(state is EditButtonNavigationState){
           Navigator.push(
                context,
                          MaterialPageRoute(
                          builder: (context) => editItemScreen(
                             state.documentId,
                          state.amount,
                                 state.date,
                                       state.color,
                                       state.categoryName)));
        }
        else if (state is DateSelectedState) {
          _selectedDate = state.selectedDate;
          print('selected$_selectedDate');
          // _homeBloc.add(HomeListOfItemsFromDateEvent(_selectedDate, expenses));
        }
        else if(state is PieChartBuildState){
          _colors=state.colors;
          print("colore$_colors");
          dataMap=state.dataMap;
          print("datamape$dataMap");
          expenses=state.expenses;
        }
      },
      bloc: _homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) =>  current is PieChartBuildState,
      builder: (context, state) {
         if( state is PieChartBuildState){
        return Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: const Color.fromARGB(255, 0, 123, 239),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(30.0), // Customize the border radius
              ),
              onPressed: () {
                // Navigator.of(context).push(PageRouteBuilder(
                //   pageBuilder: (context, animation, secondaryAnimation) =>
                //       addItemsPage(),
                //   transitionsBuilder:
                //       (context, animation, secondaryAnimation, child) {
                //     var begin = Offset(0.0, 1.0);
                //     var end = Offset.zero;
                //     var curve = Curves.easeInOut;

                //     var tween = Tween(begin: begin, end: end)
                //         .chain(CurveTween(curve: curve));

                //     return SlideTransition(
                //       position: animation.drive(tween),
                //       child: child,
                //     );
                //   },
                // ));
                /*   setState(() {
                     (_selectedIndex == 0)? getStarted_addData():
                      read_data();
                    print("object");
                    });*/
              },
              label: Row(
                children: [
                  SvgPicture.asset('assets/download.svg'),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    "Download report",
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  ),
                ],
              ),
              heroTag: 'myHeroTag',
            ),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                  SizedBox(
                    height: 8.h,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.keyboard_arrow_left,
                          size: 40.r,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            dataMap = {};
                            _selectDate(context);
                          });
                        },
                        child: Container(
                          width: 140.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 244, 244, 244),
                              borderRadius: BorderRadius.circular(18.r),
                              border: Border.all(color: Colors.black)),
                          child: Padding(
                            padding: EdgeInsets.all(8.0.r),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(Icons.date_range),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Text(
                                    '${DateFormat.yMMMd().format(_selectedDate)}'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.keyboard_arrow_right,
                          size: 40.r,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: Row(
                      children: [
                        Text(
                          "Dash Board",
                          style: TextStyle(
                              fontSize: 20.sp, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  //next
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.r),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(255, 192, 191, 191),
                          ),
                          borderRadius: BorderRadius.circular(8.r)),
                      child: 
                      
                           
                            ((expenses.length == 0))? 
                               Center(child: Text("No Item Added!")):
                             GestureDetector(
                                child: Padding(
                                  padding: EdgeInsets.all(20.r),
                                  child: PieChart(
                                    dataMap: state.dataMap,
                                    animationDuration:
                                        Duration(milliseconds: 800),
                                    chartLegendSpacing: 32,
                                    chartRadius: 120.r,
                                    colorList: state.colors,
                                    initialAngleInDegree: 0,
                                    // chartType: ChartType.ring,
                                    ringStrokeWidth: 25,
                                    //centerText: "Report ",
                                    legendOptions: LegendOptions(
                                      showLegendsInRow: false,
                                      legendPosition: LegendPosition.right,
                                      showLegends: false,
                                      //legendShape: _BoxShape.circle,
                                      legendTextStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    chartValuesOptions: ChartValuesOptions(
                                      showChartValueBackground: true,
                                      showChartValues: true,
                                      showChartValuesInPercentage: true,
                                      showChartValuesOutside: true,
                                      decimalPlaces: 0,
                                    ),
                                  ),
                                ),
                              ),
                            
                          
                        
                      
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 18.w, vertical: 5.h),
                    child: Row(
                      children: [
                        Text(
                          "Details",
                          style: TextStyle(
                              fontSize: 20.sp, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: 
                        
                           
                               ((expenses.length == 0)) ?
                                 Center(child: Text("No Item Added!")):
                                
                                 ListView.builder(
                                  //controller: _scrollController,
                                  itemCount: state.expenses.length,
                                  itemBuilder: (context, index) {
                                    final expense = expenses[index];
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.h, horizontal: 18.w),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.grey.shade300)),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          8.r),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          8.r)),
                                                          color: (expense
                                                                      .color ==
                                                                  'Blue')
                                                              ? Colors.blue
                                                              : (expense.color ==
                                                                      'Red')
                                                                  ? Colors.red
                                                                  : (expense.color ==
                                                                          'Yellow')
                                                                      ? Colors
                                                                          .yellow
                                                                      : (expense.color ==
                                                                              'Green')
                                                                          ? Colors
                                                                              .green
                                                                          : (expense.color == 'Orange')
                                                                              ? Colors.orange
                                                                              : null,
                                                        ),
                                                        height: 75.h,
                                                        width: 30.w,
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                expense.categoryName[
                                                                            0]
                                                                        .toUpperCase() +
                                                                    expense
                                                                        .categoryName
                                                                        .substring(
                                                                            1),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                            ],
                                                          ),
                                                          Text(
                                                              '${expense.date.substring(10, 16)}')
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                0, 0, 10.w, 0),
                                                        child: Text(
                                                          '\$${expense.amount}',
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Hero(
                                                            tag: 'edit',
                                                            child: IconButton(
                                                                onPressed: () {
                                                                   _homeBloc.add(EditButtonNavigationEvent(
                                                       expense
                                                                            .Id,
                                                                        expense
                                                                            .categoryName,
                                                                        expense
                                                                            .amount,
                                                                        expense
                                                                            .date,
                                                                        expense
                                                                            .color
                                                     )) ;   
                                                                 
                                                                },
                                                                icon: Icon(
                                                                  Icons.edit,
                                                                  size: 18.r,
                                                                )),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [],
                                              )
                                            ],
                                          )),
                                    );
                                  },
                                ),
                              
                            
                          
                          
                          
                          )
                ])));
         }
         else{
          return    Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: const Color.fromARGB(255, 0, 123, 239),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(30.0), // Customize the border radius
              ),
              onPressed: () {
                // Navigator.of(context).push(PageRouteBuilder(
                //   pageBuilder: (context, animation, secondaryAnimation) =>
                //       addItemsPage(),
                //   transitionsBuilder:
                //       (context, animation, secondaryAnimation, child) {
                //     var begin = Offset(0.0, 1.0);
                //     var end = Offset.zero;
                //     var curve = Curves.easeInOut;

                //     var tween = Tween(begin: begin, end: end)
                //         .chain(CurveTween(curve: curve));

                //     return SlideTransition(
                //       position: animation.drive(tween),
                //       child: child,
                //     );
                //   },
                // ));
                /*   setState(() {
                     (_selectedIndex == 0)? getStarted_addData():
                      read_data();
                    print("object");
                    });*/
              },
              label: Row(
                children: [
                  SvgPicture.asset('assets/download.svg'),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    "Download report",
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  ),
                ],
              ),
              heroTag: 'myHeroTag',
            ),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                  SizedBox(
                    height: 8.h,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.keyboard_arrow_left,
                          size: 40.r,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            dataMap = {};
                            _selectDate(context);
                          });
                        },
                        child: Container(
                          width: 140.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 244, 244, 244),
                              borderRadius: BorderRadius.circular(18.r),
                              border: Border.all(color: Colors.black)),
                          child: Padding(
                            padding: EdgeInsets.all(8.0.r),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(Icons.date_range),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Text(
                                    '${DateFormat.yMMMd().format(_selectedDate)}'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.keyboard_arrow_right,
                          size: 40.r,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: Row(
                      children: [
                        Text(
                          "Dash Board",
                          style: TextStyle(
                              fontSize: 20.sp, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  //next
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.r),
                    child: Container(
                      
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(255, 192, 191, 191),
                          ),
                          borderRadius: BorderRadius.circular(8.r)),
                      child: 
                            
                             LoadingAnimationWidget.waveDots(
                             color: Colors.black,
                              size: 30,
                        ),
                          
                       
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 18.w, vertical: 5.h),
                    child: Row(
                      children: [
                        Text(
                          "Details",
                          style: TextStyle(
                              fontSize: 20.sp, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child:
                        
                            
                               Center(
                                child: LoadingAnimationWidget.waveDots(
                                  color: Colors.black,
                                  size: 30,
                                ),
                              )// Show loading indicator while waiting
                            
                            
                          )
                ])));
       
         }
      },
    );
  }
}
