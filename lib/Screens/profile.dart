// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:realestate/Components/glow_button.dart';
import 'package:realestate/Components/littlebutton.dart';
import 'package:realestate/Components/showsnackbar.dart';
import 'package:sizer/sizer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot>? _propertiesStream;

  @override
  void initState() {
    super.initState();
    if (_auth.currentUser != null) {
      _propertiesStream = _firestore
          .collection('properties')
          .where('agentId', isEqualTo: _auth.currentUser!.uid)
          .snapshots();
    }
  }


  Future<void> _deleteProperty(String propertyId) async {
    try {
      await _firestore.collection('properties').doc(propertyId).delete();
      CustomSnackbar.showSuccess(context: context, message: 'Property deleted successfully');
    } catch (e) {
      CustomSnackbar.showError(context: context, message: 'Error deleting property: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if user is not logged in
    if (_auth.currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please log in to view your profile'),
        ),
      );
    }

    return Scaffold(
      body: Container(
        constraints: BoxConstraints(minHeight: 100.h),
        width: double.infinity,
        decoration: const BoxDecoration(color: Color(0xff12232B)),
        child: SafeArea(
          child: StreamBuilder<DocumentSnapshot>(
            stream: _firestore
                .collection('users')
                .doc(_auth.currentUser?.uid)
                .snapshots(),
            builder: (context, userSnapshot) {
              if (userSnapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }

              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final userData = userSnapshot.data?.data() as Map<String, dynamic>?;
              final userName = userData?['name'] ?? 'User';
              final userEmail = userData?['mail'] ?? '';
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Column(
                  children: [
                    SizedBox(height: 3.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    CircleAvatar(
                      radius: 15.w,
                      backgroundColor: Colors.white24,
                      child: Icon(
                        Icons.person,
                        size: 20.w,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    // User Info
                    Text(
                      'Hello, $userName',
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      userEmail,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    // My Listings Section
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'My Listings',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 19.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    // Listings Stream
                    StreamBuilder<QuerySnapshot>(
                      stream: _propertiesStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong',
                              style: TextStyle(color: Colors.white));
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        final properties = snapshot.data?.docs ?? [];

                        if (properties.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              'No properties listed yet',
                              style: TextStyle(color: Colors.white70),
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: properties.length,
                          itemBuilder: (context, index) {
                            final property = properties[index].data() as Map<String, dynamic>;
                            final propertyId = properties[index].id;

                            return Padding(
                              padding: EdgeInsets.only(bottom: 0.4.h),
                              child: Container(
                                height: 31.w,
                                width: 100.w,
                                padding: EdgeInsets.all(3.w),
                                constraints: BoxConstraints(maxWidth: 100.w-3.w),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                                  color: Colors.transparent,
                                  border: Border.all(
                                    color: Colors.white54, 
                                    width: .6, 
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 27.w-8,
                                      height: 31.w-8,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        image: DecorationImage(
                                          image: property['type'] == 'Villa' ?
                                              const AssetImage('assets/images/villa.jpg') 
                                              :
                                              property['type'] == 'Apartment'? 
                                              const AssetImage('assets/images/apartment.jpg')
                                              : const AssetImage('assets/images/bunglow.jpg'),
                                          fit: BoxFit.cover, 
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 3.w),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    property['city'],
                                                    style: GoogleFonts.montserrat(
                                                      fontSize: 14.sp * 1.6,
                                                      fontWeight: FontWeight.w700,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      ShaderMask(
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
                                                          Icons.gps_fixed_rounded,
                                                          color: Colors.white,
                                                          size: 3.h,
                                                        ),
                                                      ),
                                                      SizedBox(width: 1.w),
                                                      Text(
                                                        '${property['wilaya']}, Algeria',
                                                        style: GoogleFonts.montserrat(
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.white54,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const Spacer(),
                                              IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        backgroundColor: const Color(0xff12232B),
                                                        title: Text(
                                                          'Delete Property',
                                                          style: GoogleFonts.montserrat(color: Colors.white),
                                                        ),
                                                        content:  Text(
                                                          'Are you sure you want to delete this property?',
                                                          style: GoogleFonts.montserrat(color: Colors.white70),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            child: Text(
                                                              'Cancel',
                                                              style: GoogleFonts.montserrat()
                                                            ),
                                                            onPressed: () => Navigator.pop(context),
                                                          ),
                                                          TextButton(
                                                            child: Text(
                                                              'Delete',
                                                              style: GoogleFonts.montserrat(color: Colors.red),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                              _deleteProperty(propertyId);
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.red,
                                                  size: 23.sp,
                                                ),
                                              )
                                            ],
                                          ),
                                          const Spacer(),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${property['price']} Da',
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 14.sp * 1.6,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              MyLittleButton(
                                                text: property['type'],
                                                onTap: null,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ),
                            );
                          },
                        );
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: MyGlowingButton(
                        text: 'Log Out',
                        onTap: () async {
                          try {
                          await FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushNamedAndRemoveUntil('GettingStartedPage', (Route<dynamic> route) => false);
                          } catch (error) {
                            CustomSnackbar.showError(context: context, message: 'failure: $error');
                          }
                        },
                        hasEmail: false
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
