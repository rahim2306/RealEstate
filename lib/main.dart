import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:realestate/Screens/getting_started.dart';
import 'package:realestate/Screens/homepage.dart';
import 'package:realestate/Screens/intro.dart';
import 'package:realestate/Screens/profile.dart';
import 'package:realestate/Screens/signin.dart';
import 'package:realestate/Screens/signup.dart';
import 'package:realestate/Helpers/route.dart';
import 'package:realestate/Screens/verifyemail.dart';
import 'package:realestate/wrappers/navbarwrapper.dart';
import 'firebase_options.dart';
import 'package:sizer/sizer.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
 
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  User? _user;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _user = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Sizer( 
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          routes: {
            InternalRoute.getRouteIntro(): (context) => const Intro(),
            InternalRoute.getRouteGetStarted(): (context) => const GettingStartedPage(),
            InternalRoute.getRouteSignUp() : (context) => const SignUpPage(),
            InternalRoute.getRouteSignIn(): (context) => const SignInPage(), 
            InternalRoute.getRouteHome() : (context) => const HomePage(), 
            InternalRoute.getRouteNavWrapper() : (context) => const NavBarWrapper(), 
            InternalRoute.getProfilePage() : (context) => const ProfilePage(),
            //! this doesnt work, god knows why
            // InternalRoute.getRouteVerifyPage() : (context) => const VerifyEmailPage(),
            'verifyemail': (context) => const VerifyEmailPage(),

          },
          home: _user == null ? const Intro() : const NavBarWrapper(),
        );
      }
    );
  }
}