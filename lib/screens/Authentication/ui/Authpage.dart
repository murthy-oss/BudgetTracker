// ignore_for_file: file_names

import 'package:expensemate/screens/Authentication/bloc/auth_bloc.dart';
import 'package:expensemate/screens/Authentication/core/AuthFunction.dart';
import 'package:expensemate/screens/Authentication/data/Auth_data.dart';
import 'package:expensemate/screens/LoadingScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final  _authBloc = AuthBloc();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      bloc: _authBloc,
      listenWhen: (previous, current) => current is AuthActionState,
      buildWhen: (previous, current) => current is !AuthActionState,
      listener: (context, state) {
        if(state is NavigateAuthToHomeState ){
            signInWithGoogle(context);

            checkUserSignInStatus();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 200.h,
                ),
                Hero(
                  tag: 'logo',
                  child: Image.asset(
                    AuthData.AppLogo,
                    height: 150.h,
                  ),
                ),
                Text(
                  AuthData.Appname,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 40.h,
                ),
                const Text(
                  "Create an account",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 66, 66, 66)),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.w, vertical: 8.h),
                  child: Column(
                    children: [
                      const Text(
                        "Get started by creating your account to ",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                      const Text(
                        "secure your data & manage on multiple ",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                      const Text(
                        " devices anytime!",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          // color: Colors.white,

                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.grey.withOpacity(0.2), // Shadow color
                              spreadRadius: 1, // Spread radius
                              blurRadius: 1, // Blur radius
                              offset: const Offset(0, 2), // Shadow position
                            ),
                          ],

                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            _authBloc.add(googleAuthButtonClicked());
                          
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 0, 123, 239)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                            ),
                            overlayColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 0, 123, 239)),
                            elevation: MaterialStateProperty.all<double>(2),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(
                                  vertical: 5.h, horizontal: 50),
                            ),
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(AuthData.GoogleIcon,
                                  height: 35.h),
                              SizedBox(width: 10.w),
                              Text(
                                AuthData.AuthButtonDescription,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> checkUserSignInStatus() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    // Get the current user
    User? user = auth.currentUser;
  

    if (user != null) {
      // The user is signed in
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const LoadingScreen('AuthtoHome')),
      );
    } else {
      // The user is not signed in
    }
  }
}
