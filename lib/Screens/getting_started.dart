// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:realestate/Components/glow_button.dart';
import 'package:realestate/Components/icon_button_nooutline.dart';
import 'package:realestate/Screens/signin.dart';
import 'package:realestate/Screens/signup.dart';
import 'package:sizer/sizer.dart';

class GettingStartedPage extends StatefulWidget {
  const GettingStartedPage({super.key});

  @override
  State<GettingStartedPage> createState() => _GettingStartedPageState();
}

class _GettingStartedPageState extends State<GettingStartedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
          height: 100.h,
          decoration: const BoxDecoration(
            color: Color(0xff12232B)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Hero(
                tag: 'intro_image',
                child:Container(
                  height: 58.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(7.w),
                    ),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff867978),
                        spreadRadius: 0,
                        blurRadius: 12,
                        offset: Offset(0, -1.h)
                      )
                    ]
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(7.w)),
                    child: Image(
                      image: AssetImage('assets/images/IntroImage.jpg'),
                      fit: BoxFit.fill,
                      width: 100.w,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              Padding(
                padding: EdgeInsets.only(left: 4.w),
                child: Row(
                  children: [
                    Text(
                      'Ready to',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w400,
                        fontSize: 21.sp,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      ' explore ? 🤔 ',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 21.sp,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 4.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: MyGlowingButton(
                  text: 'Continue with Email',
                  onTap: () {
                    Navigator.of(context).push(_createRoute1());
                  },
                  hasEmail: true,
                ),
              ),
              SizedBox(height: 4.w,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 21.w,
                    height: 1.5,
                    color: Colors.blueGrey.withOpacity(0.3),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    child: Text(
                      'Or SignUp with',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.normal,
                        fontSize: 14.sp,
                        color: Colors.blueGrey.withOpacity(1),
                      ),
                    ),
                  ),
                  Container(
                    width: 21.w,
                    height: 1.5,
                    color: Colors.blueGrey.withOpacity(0.3),
                  ),
                ]
              ),
              SizedBox(height: 3.h,),
              LoginIconButton(
                icon: 'assets/icons/google.png',  
              ),
              SizedBox(height:3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(_createRoute2());
                    },
                    child: Text(
                      ' Sign In',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        color: Color(0xff047FBA),
                      ),
                    ),
                  ),
                ]
              )
            ],
          ),
      ),
    );
  }
}

Route _createRoute1() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => SignUpPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route _createRoute2() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => SignInPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}