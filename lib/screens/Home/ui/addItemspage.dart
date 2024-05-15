import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensemate/screens/Home/bloc/home_bloc.dart';
import 'package:expensemate/screens/Home/core/Firestore.dart';
import 'package:expensemate/screens/LoadingScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class addItemsPage extends StatefulWidget {
  const addItemsPage({super.key});

  @override
  State<addItemsPage> createState() => _addItemsPageState();
}

class _addItemsPageState extends State<addItemsPage> {
  String categoryName = '';
  String Amount = '';
  String date = '';
  String SelectedColor = '';

  FocusNode name = FocusNode();
  FocusNode Amount_focus = FocusNode();

  FocusNode categoryName_focus = FocusNode();

  bool AmountVisible = false;
  String? _selectedGender;
  bool IsColor = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _validateInput(String? value, {String? fieldName}) {
    if (fieldName == 'color') {
      if (value == null) {
        return 'Please select a valid Color';
      }
    }
    return null;
  }

  DateTime _selectedDate = DateTime.now();
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
       _homeBloc.add(DateSelectedEvent(_selectedDate));
    }
  }
HomeBloc _homeBloc=HomeBloc(FirebaseAuth.instance);
  @override
  Widget build(BuildContext context) {
    //List<String> ColorList = ["Blue", "black", "red", "yellow"];

    // String selectedValue='Blue';
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if(state is DateSelectedState){
           _selectedDate = state.selectedDate;
           print('selected$_selectedDate');
        }
        if(state is AddNewElementSuccessState){
  if (_formKey.currentState!.validate()  ) {
                          _formKey.currentState!.save();
                         

                        }
                        

                        if(categoryName!='' && Amount!='' && SelectedColor!=''){
                         getStarted_addData(categoryName, Amount,
                            '$_selectedDate', SelectedColor);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LoadingScreen('AddElementToHome')));
                        }
                        else{
                        
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Enter all Fields")));
                        }
                       
        }
       
      },
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is !HomeActionState,
      bloc:_homeBloc ,
      builder: (context, state) {

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.keyboard_arrow_left_outlined,
                size: 30.r,
                color: Colors.white,
              ),
            ),
            title: Text(
              "Add new",
              style: TextStyle(color: Colors.white, fontSize: 25.sp),
            ),
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 150.h,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
                    child: GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Container(
                        width: double.infinity,
                        height: 40.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
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
                  ),
                  buildTextFormField('categoryName', 'Enter category Name',
                      categoryName_focus),
                  buildTextFormField('Amount', 'Enter Amount', Amount_focus),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
                    child: DropdownButtonFormField<String>(
                      value: _selectedGender,
                      items: ['Red', 'Blue', 'Yellow', 'Orange', 'Green']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: (value == 'Red')
                                      ? Colors.red
                                      : (value == 'Blue')
                                          ? Colors.blue
                                          : (value == 'Yellow')
                                              ? Colors.yellow[600]
                                              : (value == 'Orange')
                                                  ? Colors.orange
                                                  : (value == 'Green')
                                                      ? Colors.green
                                                      : null,
                                ),
                                width: 10.w,
                                height: 10.h,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(value),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedGender = newValue;
                          SelectedColor = newValue!;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Select Color',
                        prefixIcon: Icon(Icons.color_lens),
                      ),
                      validator: (value) =>
                          _validateInput(value, fieldName: 'color'),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                      _homeBloc.add(
                        AddNewElementSuccessEvent()
                      );
                      },
                      child: Button()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget Button() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(30.r)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Center(
              child: Text(
            "Add new expense",
            style: TextStyle(color: Colors.white, fontSize: 18),
          )),
        ),
      ),
    );
  }

  Widget buildTextFormField(String key, String hintText, FocusNode focus_Node) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 18.w),
      child: Container(
        width:double.infinity,
        // height:40.h ,
        decoration: const BoxDecoration(),
        child: TextFormField(
          focusNode: focus_Node,
          keyboardType:
              (key == 'Amount') ? TextInputType.number : TextInputType.name,
          //obscureText: (key == 'Amount' && !AmountVisible) ? true : false,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(
                    255, 173, 179, 189), // Specify the border color here
                // width: 2.0, // Specify the border width here
              ),
              borderRadius: BorderRadius.circular(8.0.r),
            ),
            contentPadding: EdgeInsets.all(10.w),
            hintText: hintText,
            hintStyle: TextStyle(
                fontFamily: 'InterRegular',
                color: Color.fromARGB(255, 173, 179, 189),
                fontSize: 16.sp,
                fontWeight: FontWeight.w400),
            //fillColor: Color(0xFFF2F2F2),
            //filled: true,
            focusColor: Colors.blue,
          ),
          key: ValueKey(key),
          validator: (value) {
            if (key == 'categoryName') {
              if (value.toString().length <= 0) {
                return 'Enter catogory correctly';
              } else {
                return null;
              }
            }
            if (key == 'Amount') {
              if ((value.toString().length <= 0)) {
                return 'Amount is not valid';
              } else {
                return null;
              }
            }
          },
          onSaved: (value) {
            setState(() {
              if (key == 'categoryName') {
                categoryName = value!;
              } else if (key == 'Amount') {
                Amount = value!;
              }
            });
          },
        ),
      ),
    );
  }
}
