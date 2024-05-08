import 'package:expensemate/screens/Home/DataModel/ExpenseItem.dart';
import 'package:expensemate/screens/Home/core/Firestore.dart';
import 'package:expensemate/screens/Home/ui/LoadingScreen.dart';
import 'package:expensemate/screens/Home/ui/addItemspage.dart';
import 'package:expensemate/screens/Home/ui/editItemScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomeDetailPage extends StatefulWidget {
  const HomeDetailPage({super.key});

  @override
  State<HomeDetailPage> createState() => _HomeDetailPageState();
}

class _HomeDetailPageState extends State<HomeDetailPage> {
  ScrollController _scrollController = ScrollController();
  bool _isFabVisible = true;
  DateTime _selectedDate = DateTime.now();
  double Amount = 0;
  String catagoryName = '';
  String Date = '';
  String Color = '';
  int totalAmount = 0;

   
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }
// Example deletion function
Future<bool> deleteExpense(String documentId) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? userauth = auth.currentUser;
  try {
    // Attempt to delete the document
    await db.collection('${userauth!.email}').doc(documentId).delete();
    // If the deletion is successful, return true
    return true;
  } catch (e) {
    // If an error occurs during deletion, return false
    print("Error deleting document: $e");
    return false;
  }
}


  List<ExpenseItemModel> expenses = [];
  List<ExpenseItemModel> reversedExpenses = [];
  Future<List<ExpenseItemModel>> read_data_List() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? userauth = auth.currentUser;

    int totalAmount = 0; // Initialize total amount to 0

    await db.collection('${userauth!.email}').get().then((event) {
      expenses = [];
      for (var doc in event.docs) {
        print('${doc.id}docdata${doc.data()}');
        print(doc['Amount']);

        // Parse the Amount field to an integer and add it to the total
        if('${doc['date'].toString().substring(0,10)}'=='${_selectedDate.toString().substring(0,10)}'){
          print('${_selectedDate.toString().substring(0,10)}');
           expenses.add(ExpenseItemModel(
          amount: doc['Amount'],
          color: doc['Color'],
          categoryName: doc['category name'],
          date: doc['date'], 
          Id: '${doc.id}',
        ));

        }
       
      }
     

    });
reversedExpenses = expenses.reversed.toList();
    return reversedExpenses; // Return the total amount after processing all documents
  }

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
    // TODO: implement initState
    read_data();
     _scrollController.addListener(() {
      // Check if the user has scrolled to the bottom
  bool isScrollingUp = _scrollController.position.userScrollDirection == ScrollDirection.reverse;
  print('$isScrollingUp');
      // Update the visibility flag based on the scroll direction
      setState(() {
        _isFabVisible =isScrollingUp;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          FloatingActionButton.extended(
              backgroundColor:  Colors.blue[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    30.0), // Customize the border radius
              ),
              onPressed:_isFabVisible? () {
                   Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => addItemsPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ));
             /*   setState(() {
                 (_selectedIndex == 0)? getStarted_addData():
                  read_data();
                print("object");
                });*/
                
              }:null,
              label:  Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SvgPicture.asset('assets/Vector.svg'),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          "Add new",
                          style: TextStyle(
                              color: Colors.white, fontSize: 14.sp),
                        ),
                      ],
                    )
                 
            
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
                  onTap: () => _selectDate(context),
                  child: Container(
                    width: 140.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                        color: Colors.blueGrey.shade50,
                        borderRadius: BorderRadius.circular(18.r),
                        border: Border.all(color:  Colors.black
                        )),
                    child: Padding(
                      padding: EdgeInsets.all(8.0.r),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(Icons.date_range),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text('${DateFormat.yMMMd().format(_selectedDate)}'),
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
            SizedBox(
              height: 12.h,
            ),
            //next
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.circular(8.r)),
              child: Padding(
                padding: EdgeInsets.all(20.0.r),
                child: Column(children: [
                  SvgPicture.asset('assets/Group.svg'),
                  FutureBuilder<int>(
                    future: read_data(), // Pass the future to FutureBuilder
                    builder:
                        (BuildContext context, AsyncSnapshot<int> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return LoadingAnimationWidget.waveDots(
                          color: Colors.black,
                          size: 30,
                        ); // Show loading indicator while waiting
                      } else if (snapshot.hasError) {
                        return Text(
                            'Error: ${snapshot.error}'); // Show error if any
                      } else {
                        return Text("₹${snapshot.data ?? 0}",
                            style: TextStyle(fontSize: 14));
                      }
                    },
                  ),
                  Text(
                    "Expenses",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ]),
              ),
            ),

            Expanded(
              child: FutureBuilder<List<ExpenseItemModel>>(
                future: read_data_List(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<ExpenseItemModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingAnimationWidget.waveDots(
                      color: Colors.black,
                      size: 30,
                    ); // Show loading indicator while waiting
                  } else if (snapshot.hasError) {
                    return Text(
                        'Error: ${snapshot.error}'); // Show error if any
                  } else {
                    if((expenses.length==0)){
                      return Center(child: Text("No Item Added!"));
                    }
                    else{
  return ListView.builder(
    //controller: _scrollController,
    itemCount: expenses.length,
    itemBuilder: (context, index) {
      
      final expense = expenses[index];
      return  Padding(
        padding:  EdgeInsets.symmetric(vertical: 8.h,horizontal: 18.w),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: Colors.white,
            border: Border.all(
              color: Colors.grey.shade300
            )
          ),
          child: Column(
                children: [ 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.r),
                                bottomLeft: Radius.circular(8.r)
                                                              
                              ),
                              color:(expense.color=='Blue')? Colors.blue:(expense.color=='Red')?
                              Colors.red:(expense.color=='Yellow')?Colors.yellow:
                              (expense.color=='Orange')?Colors.orange:(expense.color=='Green')?Colors.green:null,
                            ),
                            height: 75.h,
                            width: 30.w,
                            
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(expense.categoryName[0].toUpperCase() + expense.categoryName.substring(1),
                                  style: TextStyle(
                                    fontSize: 20
                                  ),),
                              
                                  
                                ],
                              ),
                               Text('${expense.date.substring(10,16)}')
                            ],
                          ),
                        ],
                      ),
                     Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                       children: [
                         Padding(
                           padding: EdgeInsets.fromLTRB(0, 0, 10.w, 0),
                           child: Text('\$${expense.amount}',
                                style: TextStyle(
                                  fontSize: 20
                                ) ,),
                         ),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [ 
                            Hero(
                              tag: 'edit',
                              child: IconButton(
                                onPressed:(){
                                  Navigator.push(context, 
                                  MaterialPageRoute(builder: (context)=>editItemScreen(expense.Id,
                                  expense.categoryName,expense.amount,expense.date,expense.color)));
                                } 
                              , icon: Icon(Icons.edit,
                              size: 18.r,)),
                            ),
                            IconButton(
                              onPressed:() async {

                                print(expense.Id);

                                await deleteExpense(expense.Id);
                               Navigator.push(context,
                               MaterialPageRoute(builder: (context)=>LoadingScreen("DeleteToHome"))) ;
                              Fluttertoast.showToast(
  msg: "Item Deleted",
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.BOTTOM,
  
);
                               

                              } 
                            , icon: Icon(Icons.delete,
                            size: 18.r,))
                          ],
                         )
                       ],
                     ),
                          
                      
                    ],
                  ),
                 
                  Row(
                    children: [ 
                     
                    ],
                  )
                ],
          )
        ),
      );
    },
  );
}
                  }
                },
              ),
            ),
          ],
        ),
      ),
      
    );
    
  }
  @override
void dispose() {
  _scrollController.dispose();
  super.dispose();
}

}
