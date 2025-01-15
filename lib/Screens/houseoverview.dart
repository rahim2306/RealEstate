// ignore_for_file: avoid_print, use_build_context_synchronously, unnecessary_null_comparison, unnecessary_import, non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:realestate/Components/littlebutton.dart';
import 'package:realestate/Components/showsnackbar.dart';
import 'package:realestate/Models/housemodel.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class HouseOverView extends StatefulWidget {
  final HouseModel house;

  const HouseOverView({super.key, required this.house});

  @override
  State<HouseOverView> createState() => _HouseOverViewState();
}

class _HouseOverViewState extends State<HouseOverView> {
  Map<String, dynamic>? sellerInfo;
  bool isLoading = true;
  bool isFavorite = false;
  final db = FirebaseFirestore.instance;
  String _Name = '';
  String _phone = '';

  @override
  void initState() {
    super.initState();
    fetchSellerFromDb();
    checkIfFavorite();
  }

  Future<void> fetchSellerFromDb() async {
    try {
      final docRef = db.collection('users').doc(widget.house.sellerId);
      final doc = await docRef.get();
      final data = doc.data() as Map<String, dynamic>;

      setState(() {
        sellerInfo = data;
        _Name = data['name'];
        _phone = data['phone'];
        print(_phone);
        isLoading = false;
      });
    } catch (error) {
      CustomSnackbar.showError(context: context, message: 'Failue fetching Seller: $error');
    }
  }

  Future<void> checkIfFavorite() async {
    try {
      final docRef = db.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);
      final favDocRef = await docRef.collection('favorites').get();
      final isFav = favDocRef.docs.any((doc) => doc['houseId'] == widget.house.houseId);

      setState(() {
        isFavorite = isFav;
      });
    } catch (error) {
      print('Error checking favorite: $error');
    }
  }

  Future<void> addOrToFavorite() async {
    try {
      final docRef = db.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);
      final favDocRef = docRef.collection('favorites');

      if (isFavorite) {
        // Remove from favorites
        final favDocs = await favDocRef.where('houseId', isEqualTo: widget.house.houseId).get();
        for (var doc in favDocs.docs) {
          await doc.reference.delete();
        }
        print('House removed from favorites.');
      } else {
        // Add to favorites
        await favDocRef.add({
          'houseId': widget.house.houseId,
        });
        print('House added to favorites.');
      }

      setState(() {
        isFavorite = !isFavorite;
      });
    } catch (error) {
      print('Error updating favorites: $error');
    }
  }

  Future<void> _launchUrl() async {
    final phone = _phone.replaceAll(' ', '');
    try {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: phone,
      );
      
      // Add debug print
      print('Attempting to launch: $launchUri');
      
      bool canLaunch = await canLaunchUrl(launchUri);
      if (canLaunch) {
        await launchUrl(launchUri, mode: LaunchMode.platformDefault);
      } else {
        if (mounted) {
          CustomSnackbar.showError(context: context, message: 'Could not launch phone call');
        }
      }
    } catch (e) {
      print('Launch error: $e');
      if (mounted) {
        CustomSnackbar.showError(context: context, message: 'Error: $e');
      }
    }
  }

  Future<void> _launchUrlsms() async {
    final phone = _phone.replaceAll(' ', '');
    try {
      final Uri launchUri = Uri(
        scheme: 'sms',
        path: phone,
      );
      
      print('Attempting to launch: $launchUri');
      
      bool canLaunch = await canLaunchUrl(launchUri);
      if (canLaunch) {
        await launchUrl(launchUri, mode: LaunchMode.platformDefault);
      } else {
        if (mounted) {
          CustomSnackbar.showError(context: context, message: 'Could not launch SMS');
        }
      }
    } catch (e) {
      print('Launch error: $e');
      if (mounted) {
        CustomSnackbar.showError(context: context, message: 'Error: $e');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: Container(
                height: 100.h,
                width: 100.w,
                decoration: const BoxDecoration(
                  color: Color(0xff12232B),
                ),
                child: Container(
                  height: 10.w,
                  width: 10.w,
                  decoration: const BoxDecoration(
                    color: Color(0xff12232B),
                  ),
                  child: const CircularProgressIndicator(
                                  ),
                ),
              ),
            )
          : Container(
              constraints: BoxConstraints(minHeight: 100.h),
              decoration: const BoxDecoration(
                color: Color(0xff12232B),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 100.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: 
                              widget.house.type == 'Villa' ?
                                const AssetImage('assets/images/villa.jpg') 
                                :
                                widget.house.type == 'Apartment'? 
                                const AssetImage('assets/images/apartment.jpg')
                                : const AssetImage('assets/images/bunglow.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 3.h),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(
                                  Icons.arrow_back,
                                  size: 24.0,
                                  color: Colors.white,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  addOrToFavorite();
                                },
                                child: Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                                  size: 24.0,
                                  color: isFavorite ? Colors.red : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyLittleButton(
                                text: widget.house.type,
                                onTap: () {},
                              ),
                              MyLittleButton(
                                text: '${widget.house.price} Da',
                                onTap: null,
                              )
                            ],
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            widget.house.city,
                            style: GoogleFonts.montserrat(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 0.6.h),
                          Row(
                            children: [
                              ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (Rect bounds) =>
                                    const LinearGradient(
                                  colors: [
                                    Color(0xff20A9EB),
                                    Color.fromARGB(25, 28, 156, 215)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ).createShader(bounds),
                                child: Icon(
                                  Icons.gps_fixed_rounded,
                                  color: Colors.white,
                                  size: 4.h,
                                ),
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                '${widget.house.wilaya}, Algeria',
                                style: GoogleFonts.montserrat(
                                  fontSize: 22.sp / 1.6,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white54,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Icon(
                                Icons.bed_outlined,
                                color: Colors.white,
                                size: 7.w,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                widget.house.beds == null
                                    ? '4 Bedrooms'
                                    : '${widget.house.beds} Bedrooms',
                                style: GoogleFonts.montserrat(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Icon(
                                Icons.bathtub_outlined,
                                color: Colors.white,
                                size: 7.w,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                '${widget.house.baths} Bathrooms',
                                style: GoogleFonts.montserrat(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 3.h),
                          Container(
                            width: double.infinity,
                            height: 1,
                            decoration: const BoxDecoration(
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            'Listing Agent',
                            style: GoogleFonts.montserrat(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3.w),
                            child: Row(
                              children: [
                                Container(
                                  width: 13.w,
                                  height: 13.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.grey[300],
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                    size: 32.0,
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _Name.split(' ')[1] == null ||  _Name.split(' ')[1] == '' ? _Name.split(' ')[0] : _Name.split(' ')[1],
                                      style: GoogleFonts.montserrat(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Real Estate Agent',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white54,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: _launchUrlsms,
                                  child: Container(
                                    width: 13.w,
                                    height: 13.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.white12.withOpacity(0.05),
                                    ),
                                    child: const Icon(
                                      Icons.message_outlined,
                                      size: 28.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                GestureDetector(
                                  onTap: _launchUrl,
                                  child: Container(
                                    width: 13.w,
                                    height: 13.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.blue,
                                    ),
                                    child: const Icon(
                                      Icons.phone_in_talk_outlined,
                                      size: 28.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Overview',
                            style: GoogleFonts.montserrat(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3.w),
                            child: Text(
                              widget.house.description,
                              style: GoogleFonts.montserrat(
                                fontSize: 20.sp / 1.6,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
