import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensemate/screens/Home/core/Firestore.dart';
import 'package:expensemate/screens/LoadingScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class editItemScreen extends StatefulWidget {
  final String Id;
  final String categoryName;
  final String amount;
  final String date;
  final String color;
  const editItemScreen(this.Id, this.categoryName, this.amount, this.date,this.color, {super.key});

  @override
  State<editItemScreen> createState() => _editItemScreenState();
}

class _editItemScreenState extends State<editItemScreen> {
 
 String categoryname='';
 String Amount1='';
 String selectedColor1='';
  FocusNode name = FocusNode();
  FocusNode Amount_focus = FocusNode();

  FocusNode categoryName_focus = FocusNode();

  bool AmountVisible = false;
 
  bool IsColor = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  

FirebaseFirestore db = FirebaseFirestore.instance;
Future<void> updateData(String categoryName, String amount, String date, String selectedColor,String Id) {
   FirebaseAuth auth = FirebaseAuth.instance;

    // Get the current user
    User? userauth = auth.currentUser;
    // [START get_started_add_data_1]
    // Create a new user with a first and last name
    final user = <String, dynamic>{
     
      "date":date,
      "category name": categoryName,
      "Amount": amount,
      "Color": selectedColor,

    };
  return db.collection('${userauth!.email}')
      .doc(Id)
      .update(user)
      .then((value) => print("User Updated"))
      .catchError((error) => print("Failed to update user: $error"));
}


  String? _validateInput(String? value, {String? fieldName}) {
    if (fieldName == 'color') {
      if (value ==null) {
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

    if (pickedDate!= null && pickedDate!= _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
       

      });
    }
  }
  @override
  Widget build(BuildContext context) {
     String categoryName = widget.categoryName;
  String Amount = widget.amount;
  String date=widget.date;

  String SelectedColor=widget.color;
    //List<String> ColorList = ["Blue", "black", "red", "yellow"];

    // String selectedValue='Blue';
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
        title: Row(
          children: [
            Hero(
              tag: 'edit',
              child: Icon(Icons.edit,
              color: Colors.white,),
            ),
            SizedBox(
              width: 5.w,
            ),
            Text(
              "Edit",
              style: TextStyle(color: Colors.white, fontSize: 25.sp),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 150.h,
              ),
              /* Padding(
                 padding:  EdgeInsets.symmetric(horizontal: 18.w,vertical: 8.h
                 ),
                 child: GestureDetector(
                    
                    onTap: () => _selectDate(context),
                    child: Container(
                      width: double.infinity,
                      height: 40.h,
                      decoration: BoxDecoration(
                       
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: Colors.black
                        )
                  
                      ),
                      child: Padding(
                        padding:  EdgeInsets.all(8.0.r),
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
               ),*/
               Padding(
                 padding:  EdgeInsets.symmetric(horizontal: 18.w),
                 child: Row(
                   children: [
                     Text("Category Name"),
                   ],
                 ),
               ),
              buildTextFormField(
                  'categoryName', 'Enter category Name', categoryName_focus,categoryName),
                  Padding(
                 padding:  EdgeInsets.symmetric(horizontal: 18.w),
                 child: Row(
                   children: [
                     Text("Amount"),
                   ],
                 ),
               ),
              buildTextFormField('Amount', 'Enter Amount', Amount_focus,Amount),
              Padding(
                 padding:  EdgeInsets.symmetric(horizontal: 18.w),
                 child: Row(
                   children: [
                     Text("Select Color"),
                   ],
                 ),
               ),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 18.w,vertical: 5.h),
                child: DropdownButtonFormField<String>(
                  value: SelectedColor,
                  items: ['Red', 'Blue', 'Yellow','Orange','Green'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                               color:(value=='Red')?Colors.red:
                               (value=='Blue')?Colors.blue:
                               (value=='Yellow')? Colors.yellow[600]:
                               (value=='Orange')?Colors.orange:
                                (value=='Green')?Colors.green:null,
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
                      
                      selectedColor1=newValue!;
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
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Proceed with saving the data
                      print('Category Name: $categoryName');
                      print('Amount: $Amount');
                    }
                    updateData(categoryname, Amount1, date, (selectedColor1=='')?SelectedColor:selectedColor1,widget.Id);
                   print(categoryname);
                    Navigator.push(context,MaterialPageRoute(
                      builder: (context)=>LoadingScreen('EditElementToHome')));
                    
                    
                  },
                  child: Button()),
            ],
          ),
        ),
      ),
    );
  }

  Padding Button() {
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
            "Update expense",
            style: TextStyle(color: Colors.white, fontSize: 18),
          )),
        ),
      ),
    );
  }

  Widget buildTextFormField(String key, String hintText, FocusNode focus_Node, String initialValue) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 18.w),
      child: Container(
        width: 358.w,
        // height:40.h ,
        decoration: const BoxDecoration(),
        child: TextFormField(
          initialValue: initialValue,
          
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
                categoryname = value!;
              } else if (key == 'Amount') {
                 Amount1 = value!;
              }
            });
          },
        ),
      ),
    );
  }
}
