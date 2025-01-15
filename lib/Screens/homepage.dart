// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:realestate/Components/choicecard.dart';
import 'package:realestate/Components/glow_button.dart';
import 'package:realestate/Components/housecards.dart';
import 'package:realestate/Components/littlebutton.dart';
import 'package:realestate/Components/showsnackbar.dart';
import 'package:realestate/Helpers/wilayas.dart';
import 'package:realestate/Models/housemodel.dart';
import 'package:realestate/Screens/houseoverview.dart';
import 'package:realestate/Screens/profile.dart';
import 'package:sizer/sizer.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  final List<IconData> _selectedIcons = [Icons.home_rounded, Icons.holiday_village_rounded, Icons.apartment];
  final List<String> _wilayas = Wilayas.wilayaNames;

  String _selectedWilaya = '';
  int _selectedWilayaNumber = -1;
  List<String> cardTitles = ['Villa', 'Bungalow', 'Apartment'];
  final List<int> _selectedCardIndexes = [0]; 

  List<HouseModel> _properties = [];
  bool _isLoading = false;
  

  Future<void> fetchProperties() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      Query query = FirebaseFirestore.instance.collection('properties');
      
      // If types are selected, filter by them
      if (_selectedCardIndexes.isNotEmpty) {
        List<String> selectedTypes = _selectedCardIndexes
            .map((index) => cardTitles[index])
            .toList();
            print(selectedTypes);
        query = query.where('type', whereIn: selectedTypes);
      }

      if (_selectedWilaya.isNotEmpty) {
        query = query.where('wilaya', isEqualTo: _selectedWilaya);
        print(_selectedWilaya);
      }

      final QuerySnapshot snapshot = await query.get();

      setState(() {
        _properties = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          print(data['agentId']);
          return HouseModel(
            city: data['city'] ?? '',
            wilaya: data['wilaya'] ?? '',
            price: data['price'] ?? 0,
            houseId: doc.id,
            type: data['type'] ?? '',
            image: data['image'] ?? '',
            description: data['description'] ?? '',
            sellerId: data['agentId'],
            beds: data['beds'],
            baths: data['bath'],
          );
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      CustomSnackbar.showError(context: context, message: 'Failure fetching property: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkWilayaAndOpenModal();
      await fetchProperties();
    });
  }

  void updateSelectedTypes(int index) {
    setState(() {
      if (_selectedCardIndexes.contains(index)) {
        if(_selectedCardIndexes.length != 1){
          _selectedCardIndexes.remove(index);
        }
      } else {
        _selectedCardIndexes.add(index);
      }
      fetchProperties(); // Fetch new properties when selection changes
    });
  }

  Widget buildPropertiesList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_properties.isEmpty) {
      return Center(
        child: Text(
          'No properties found',
          style: GoogleFonts.montserrat(
            fontSize: 16,
            color: Colors.white54,
          ),
        ),
      );
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _properties.length,
      itemBuilder: (context, index) => HouseCard(
        house: _properties[index],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HouseOverView(
                house: _properties[index],
              ),
            ),
          );
        },
      ),
    );
  }


  
 @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      constraints: BoxConstraints(minHeight: 100.h),
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      width: double.infinity,
      decoration: const BoxDecoration(color: Color(0xff12232B)),
      child: RefreshIndicator(
        onRefresh: fetchProperties,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 6.h),
              Text(
                'Location',
                style: GoogleFonts.montserrat(
                  fontSize: 13 * 1.6,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              // Location Row
              Row(
                children: [
                  GestureDetector(
                    onTap: _openWoltModalSheet,
                    child: ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (Rect bounds) => const LinearGradient(
                        colors: [
                          Color(0xff20A9EB),
                          Color.fromARGB(255, 3, 98, 142)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: Icon(
                        Icons.location_city_rounded,
                        color: Colors.white,
                        size: 4.h,
                      ),
                    ),
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    _selectedWilaya.isEmpty 
                        ? 'Select Location' 
                        : '$_selectedWilaya, Algeria',
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white54,
                    ),
                  ),
                  const Spacer(),
                  MyLittleButton(
                    text: 'My Profile',
                    onTap: () => Navigator.of(context).push(_createRoute1()),
                  )
                ],
              ),
              SizedBox(height: 3.h),
              // Property Type Selection Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(3, (index) {
                  return HomeChoiceCard(
                    icon: _selectedIcons[index],
                    title: cardTitles[index],
                    onTap: () => updateSelectedTypes(index),
                    isSelected: _selectedCardIndexes.contains(index),
                  );
                }),
              ),
              SizedBox(height: 2.h),
              // Properties List
              buildPropertiesList(),
              // Bottom padding for scrolling
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    ),
  );
}


  Future<void> _checkWilayaAndOpenModal() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {return;}

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;

        if (data != null && data['wilaya'] == '') {
          _openWoltModalSheet();
        } else {
          setState(() {
            _selectedWilaya = data?['wilaya'];
            _selectedWilayaNumber = _wilayas.indexOf(_selectedWilaya) + 1;
          });
        }
      }
    } catch (e) {
      CustomSnackbar.showError(context: context, message: 'Error: $e');
    }
  }

  void _openWoltModalSheet() {
    WoltModalSheet.show<void>(
      context: context,
      pageListBuilder: (context) {
        return [
          WoltModalSheetPage(
            hasTopBarLayer: false,
            child: _modalSheetContent(),
          ),
        ];
      },
    );
  }

  Widget _modalSheetContent() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setModalState) {
        return Container(
          constraints: BoxConstraints(maxHeight: 100.h),
          height: 60.h,
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          width: double.infinity,
          decoration: const BoxDecoration(color: Color(0xff12232B)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                Text(
                  'Select a Wilaya',
                  style: GoogleFonts.montserrat(
                    fontSize: 16 * 1.6,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 40.h,
                  child: ListView.builder(
                    itemCount: _wilayas.length,
                    itemBuilder: (context, index) => ListTile(
                      leading: _selectedWilayaNumber == index + 1
                          ? const Icon(Icons.check)
                          : null,
                      title: Text(
                        _wilayas[index],
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: _selectedWilayaNumber == index + 1
                              ? const Color(0xff1F96CF)
                              : Colors.white,
                        ),
                      ),
                      iconColor: const Color(0xff1F96CF),
                      onTap: () {
                        setState(() {
                          _selectedWilaya = _wilayas[index];
                          _selectedWilayaNumber = index + 1;
                        });
                        setModalState(() {
                          _selectedWilaya = _wilayas[index];
                          _selectedWilayaNumber = index + 1;
                        });
                      },
                    ),
                  ),
                ),
                MyGlowingButton(
                  text: 'Submit',
                  onTap: () => _saveWilayaAndCloseModal(),
                  hasEmail: false,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveWilayaAndCloseModal() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({'wilaya': _selectedWilaya});
      }
      fetchProperties();
      Navigator.pop(context); 
    } catch (e) {
      CustomSnackbar.showError(context: context, message: 'Failure saving wilaya, try Again please');
    }
  }

  Route _createRoute1() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const ProfilePage(),
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

}