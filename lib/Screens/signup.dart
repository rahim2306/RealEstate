// ignore_for_file: avoid_print, unused_import, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:realestate/Components/glow_button.dart';
import 'package:realestate/Components/icon_button_nooutline.dart';
import 'package:realestate/Components/my_textfield.dart';
import 'package:realestate/Components/showsnackbar.dart';
import 'package:realestate/Helpers/validators.dart';
import 'package:realestate/Screens/homepage.dart';
import 'package:realestate/Screens/verifyemail.dart';
import 'package:realestate/firebase/firebase_auth_services.dart';
import 'package:realestate/wrappers/navbarwrapper.dart';
import 'package:sizer/sizer.dart';

class SignUpPage extends StatefulWidget {

  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final FirebaseAuthService _auth = FirebaseAuthService();
  

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  
  @override
  void dispose() {
    pwdController.dispose();
    emailController.dispose();
    nameController.dispose();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(maxHeight: 100.h),
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          decoration: const BoxDecoration(
            color: Color(0xff12232B)
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 6.h,),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_outlined,
                        size: 3.h,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create your ',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w400,
                        fontSize: 21.sp,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'account 👍',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 21.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h,),
                Text(
                  'Welcome to Dream Home',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                SizedBox(height: 4.h,),
                MyTextField(
                    hinttext: "Name",
                    myController: nameController,
                    myIcon: Icons.person_outline,
                    myValidator: (value) => FormValidators.validateNull(context, value, 'Name'),
                    isObsecure: false,
                ),
                SizedBox(height: 2.h),
                MyTextField(
                  hinttext: "Email",
                  myController: emailController,
                  myIcon: Icons.email_outlined,
                  myValidator: (value) => FormValidators.validateEmail(context, value),
                  isObsecure: false,
                ),
                SizedBox(height: 2.h),
                MyTextField(
                  hinttext: "Password",
                  myController: pwdController,
                  myIcon: Icons.lock_outline,
                  myValidator: (value) => FormValidators.validatePassword(context, value),
                  isObsecure: true,
                ),
                SizedBox(height: 6.h),
                MyGlowingButton(
                  text: 'Register', 
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      signUp();
                    } else {
                      print('Form is not valid');
                    }
                  }, 
                  hasEmail: false
                ),
                SizedBox(height: 4.h,),
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
                        'Or SignIn with',
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
                const LoginIconButton(
                  icon: 'assets/icons/google.png',  
                ),
                const Spacer(),
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
                        Navigator.pushReplacementNamed(context, 'SignInPage');
                      },
                      child: Text(
                        ' Sign In',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: const Color(0xff047FBA),
                        ),
                      ),
                    ),
                  ]
                ),
                SizedBox(height: 5.h,),
              ],
            ),
          ),
        ),
      )
    );
  }

  void signUp() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = pwdController.text.trim();

    try {
      User? user = await _auth.registerUser(name, email, password);
      if(user!= null) {
        Navigator.of(context).pushNamedAndRemoveUntil('verifyemail', (Route<dynamic> route) => false);
      } else {
        CustomSnackbar.showError(
          context: context,
          message: "Failed to register. Please try again.",
        );
      }
    } catch (error) {
      CustomSnackbar.showError(
        context: context,
        message: "Failure: $error",
      );
    }
  } 

}