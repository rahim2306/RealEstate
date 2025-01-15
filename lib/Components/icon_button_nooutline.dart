
// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:realestate/Components/showsnackbar.dart';
import 'package:sizer/sizer.dart';

import 'package:realestate/firebase/firebase_auth_services.dart';

class LoginIconButton extends StatelessWidget {
  final String icon;

  const LoginIconButton({
    super.key,
    required this.icon,
  });

  @override
  Widget build (BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: const Color(0xff182931),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              final FirebaseAuthService auth = FirebaseAuthService();
              User? user = await auth.signInWithGoogle();
              if (user != null) {
                Navigator.of(context).pushNamedAndRemoveUntil('NavWrapper', (Route<dynamic> route) => false);
              } else {
                CustomSnackbar.showError(context: context, message: 'Failed to sign in with Google');
              }
            },
            borderRadius: BorderRadius.circular(12.0),
            splashColor: Colors.blueGrey.withOpacity(0.3),
            highlightColor:Colors.blueGrey.withOpacity(0.2),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.4.w, vertical: 2.h),
                child: Image(
                  image: AssetImage(icon), 
                  width: 2.5.h,
                  height: 2.5.h,
                )
              ),
            ),
          ),
        ),
      ),
    );
  }
}
