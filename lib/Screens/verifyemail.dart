// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:realestate/Components/glow_button.dart';
import 'package:realestate/wrappers/navbarwrapper.dart';
import 'package:sizer/sizer.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    
    isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;
    });

    if (isEmailVerified) timer?.cancel();
  }

  Future<void> sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 60));
      setState(() => canResendEmail = true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => !isEmailVerified
    ? Scaffold(
        body: Container(
          constraints: BoxConstraints(maxHeight: 100.h),
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          decoration: const BoxDecoration(
            color: Color(0xff12232B)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Verify your email',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'A verification email has been sent to your email address. Please check your inbox and spam folder.',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              SizedBox(height: 5.h),
              MyGlowingButton(
                text: 'Resend Email',
                onTap: canResendEmail ? 
                  () async {
                    await sendVerificationEmail();
                  }
                 : () {},
                hasEmail: false,
              ),
              SizedBox(height: 2.h),
              TextButton(
                onPressed: () async {await FirebaseAuth.instance.signOut(); Navigator.pop(context);},
                child: Text(
                  'Cancel',
                  style: GoogleFonts.montserrat(
                    fontSize: 14.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    : const NavBarWrapper();
}