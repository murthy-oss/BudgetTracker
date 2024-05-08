import 'package:expensemate/screens/Authentication/core/AuthFunction.dart';
import 'package:expensemate/screens/Home/bloc/home_bloc.dart';
import 'package:expensemate/screens/LoadingScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final _homeBloc=HomeBloc();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: _homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is !HomeActionState,
      listener: (context, state) {
        if(state is LogOutState){
           signOut();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoadingScreen('HometoAuth')));
        }
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          body: Column(children: [
            SettingAttributes('assets/categories.svg', "Manage categories"),
            SettingAttributes('assets/pdf.svg', "Export to PDF"),
            SettingAttributes('assets/dollar.svg', "Choose currency"),
            SettingAttributes('assets/language.svg', "Choose language"),
            SettingAttributes(
                'assets/question.svg', "Frequently asked questions"),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
              child: GestureDetector(
                onTap: () {
                 _homeBloc.add(LogOutEvent());
                },
                child: Container(
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        "Logout",
                        style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.w100),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ]),
        );
      },
    );
  }

  Padding SettingAttributes(String imgpath, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SvgPicture.asset(imgpath),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  title,
                  style:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w100),
                ),
              ],
            ),
            Icon(
              Icons.keyboard_arrow_right,
              color: const Color.fromARGB(255, 189, 189, 189),
            )
          ],
        ),
      ),
    );
  }
}
