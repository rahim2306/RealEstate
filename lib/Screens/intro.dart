
import 'package:flutter/material.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:realestate/Components/glow_button.dart';
import 'package:realestate/Components/littlebutton.dart';
import 'package:realestate/Components/text_column_intro.dart';
import 'package:sizer/sizer.dart';

class Intro extends StatefulWidget {

  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  
  int currentStep = 1;
  final PageController _pageController = PageController();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      body: Container(
        width: double.infinity,
        height: 100.h,
        decoration: const BoxDecoration(
          color: Color(0xff12232B)
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(height: 3.h,),
              Row(
                children: [
                  SizedBox(width: 3.w,),                  
                  MyLittleButton(
                    text: 'GO BACK', 
                    onTap: ()  { setState(() {
                      if (currentStep>1) currentStep--;
                    }); _pageController.animateToPage(currentStep - 1, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut); },
                  ),
                  const Spacer(),
                  if(currentStep != 3)
                    MyLittleButton(
                      text: 'Skip', onTap: () {
                          Navigator.pushNamed(context,  'GettingStartedPage');
                        },
                    ),
                  SizedBox(width: 5.w,)
                ],
              ),
              SizedBox(height: 2.h,),
              SizedBox(
                height: 20.h,
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    MyTextColumn(
                      firstText: 'Find perfect rentals here',
                      secondText: 'for good prices 💰',
                      thirdText: 'Explore homes that suit your needs and lifestyle, offering options to match your preferences.'
                    ),
                    MyTextColumn(
                      firstText: 'List properties for rent',
                      secondText: 'in just a few clicks 🏠',
                      thirdText: 'Easily connect with renters and save time, ensuring your property gets visibility it deserves.'
                    ),
                    MyTextColumn(
                      firstText: 'Get your Dream Home',
                      secondText: 'Today 🔑',
                      thirdText: 'Browse listings to find your ideal new home, making the process simple and stress-free.'
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 4.w,right: 80.w),
                child: LinearProgressBar(
                  maxSteps: 3,
                  progressType: LinearProgressBar.progressTypeLinear,
                  currentStep: currentStep,
                  progressColor: const Color(0xff0F90CE),
                  backgroundColor: const Color(0xff2B3B42),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xff0F90CE)),
                  minHeight: 3.5,
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              SizedBox(height: 2.5.h,),
              Row( 
                children: [
                  SizedBox(width: 4.w),
                  currentStep < 3
                    ?
                      MyGlowingButton(
                        text: 'Next',
                        onTap: () {
                          setState(() {
                            currentStep++;
                          });
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        hasEmail: false,
                      )
                    :
                      MyGlowingButton(
                        text: 'Continue',
                        onTap: () {
                          Navigator.pushNamed(context,  'GettingStartedPage');
                        },
                        hasEmail: false,
                      ),
                  const Spacer()
                ],
              ),
              const Spacer(),
              Hero(
                tag: 'intro_image',
                child:Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(7.w),
                    ),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white,
                        spreadRadius: -60,
                        blurRadius: 60,
                      ),
                      BoxShadow(
                        color: Colors.white,
                        spreadRadius: -30,
                        blurRadius: 40,
                      )
                    ]
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(7.w)),
                    child: Image(
                      image: const AssetImage('assets/images/IntroImage.jpg'),
                      fit: BoxFit.fill,
                      width: 100.w,
                      height: 50.h,
                      
                    ),
                  ),
                ),
              ),
            ]
          ),
        )
      ),
    );
  }
}