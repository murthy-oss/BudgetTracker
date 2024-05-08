// ignore_for_file: file_names

import 'package:expensemate/screens/Authentication/data/Auth_data.dart';
import 'package:expensemate/screens/Home/core/Firestore.dart';
import 'package:expensemate/screens/Home/ui/Homedetailedpage.dart';
import 'package:expensemate/screens/Home/ui/Reportpage.dart';
import 'package:expensemate/screens/Home/ui/SettingPage.dart';
import 'package:expensemate/screens/Home/ui/addItemspage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  static const List<Widget> _widgetOptions = <Widget>[
    HomeDetailPage(),
    ReportPage(),
    SettingPage()
  ];

  @override
  Widget build(BuildContext context) {
     FirebaseAuth auth = FirebaseAuth.instance;

    // Get the current user
    User? user = auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: (_selectedIndex == 2)
            ? const Color.fromARGB(255, 238, 238, 238)
            : null,
        leading: (_selectedIndex == 0)
            ? Hero(
                tag: 'logo',
                child: Image.asset(
                  AuthData.AppLogo,
                  height: 20.h,
                ),
              )
            : null,
        title: Text(
          (_selectedIndex == 0)
              ? AuthData.Appname
              : (_selectedIndex == 1)
                  ? "Statistics"
                  : "Settings",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          (_selectedIndex != 2)
              ? IconButton(onPressed: () {}, icon: const Icon(Icons.search))
              : Container(),
          (_selectedIndex == 0)
              ? const CircleAvatar(
                  child: Text("V"),
                  backgroundColor: Color.fromARGB(255, 238, 238, 238),
                )
              : (_selectedIndex == 1)
                  ? IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.more_vert_outlined,
                      ))
                  : Container()
        ],
        bottom: (_selectedIndex == 2)
            ? PreferredSize(
                preferredSize: Size.fromHeight(120.0.h),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 50.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: CircleAvatar(
                              radius: 30.r,
                              backgroundColor: Colors.white,
                              child:  Text(
                                user!.displayName![0],
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                '${user.displayName}',
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                               Text(
                                '${user.email}',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ))
            : null,
      ),
     
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
        currentIndex: _selectedIndex,
        //  unselectedItemColor: Colors.,
        selectedItemColor: Colors.black,
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }
}
