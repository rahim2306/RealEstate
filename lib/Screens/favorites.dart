// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:realestate/Components/housecards.dart';
import 'package:realestate/Components/choicecard.dart';
import 'package:realestate/Components/showsnackbar.dart';
import 'package:realestate/Models/housemodel.dart';
import 'package:realestate/Screens/houseoverview.dart';
import 'package:sizer/sizer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<HouseModel> _favoriteHouses = [];
  bool _isLoading = false;

  final List<String> cardTitles = ['Villa', 'Banglow', 'Apartment'];
  final List<IconData> cardIcons = [
    Icons.home_rounded,
    Icons.holiday_village_rounded,
    Icons.apartment
  ];

  final List<int> _selectedCardIndexes = [0];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Get favorites subcollection
      final favoritesSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('favorites')
          .get();

      if (favoritesSnapshot.docs.isEmpty) {
        setState(() {
          _favoriteHouses = [];
          _isLoading = false;
        });
        return;
      }

      // Get the house IDs from favorites
      final List<String> favoriteHouseIds = 
          favoritesSnapshot.docs.map((doc) => doc['houseId'] as String).toList();

      // Get all favorite properties
      final propertiesSnapshot = await FirebaseFirestore.instance
          .collection('properties')
          .where(FieldPath.documentId, whereIn: favoriteHouseIds)
          .get();

      // Filter by selected property types
      final List<String> selectedTypes =
          _selectedCardIndexes.map((index) => cardTitles[index]).toList();

      final List<HouseModel> houses = propertiesSnapshot.docs
          .where((doc) => selectedTypes.contains(doc['type']))
          .map((doc) {
        final data = doc.data();
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

      setState(() {
        _favoriteHouses = houses;
        _isLoading = false;
      });
    } catch (e) {
      CustomSnackbar.showError(context: context, message: 'Failure Loading Favorites');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _removeFromFavorites(String houseId) async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('favorites')
          .where('houseId', isEqualTo: houseId)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });

      // Reload favorites
      await _loadFavorites();
    } catch (e) {
      CustomSnackbar.showError(context: context, message: 'Failure removing property: $e');
    }
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
          onRefresh: _loadFavorites,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 6.h),
                Text(
                  'Favorites',
                  style: GoogleFonts.montserrat(
                    fontSize: 13 * 1.6,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 3.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(cardTitles.length, (index) {
                    return HomeChoiceCard(
                      icon: cardIcons[index],
                      title: cardTitles[index],
                      onTap: () {
                        setState(() {
                          if (_selectedCardIndexes.contains(index)) {
                            if (_selectedCardIndexes.length != 1) {
                              _selectedCardIndexes.remove(index);
                            }
                          } else {
                            _selectedCardIndexes.add(index);
                          }
                          _loadFavorites(); // Reload with new filters
                        });
                      },
                      isSelected: _selectedCardIndexes.contains(index),
                    );
                  }),
                ),
                SizedBox(height: 3.h),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else if (_favoriteHouses.isEmpty)
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.question_mark_outlined,
                          size: 16.w,
                          color: Colors.white54,
                        ),
                        Text(
                          'No favorites added yet!',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _favoriteHouses.length,
                    itemBuilder: (context, index) {
                      final house = _favoriteHouses[index];
                      return Dismissible(
                        key: Key(house.houseId),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.red,
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (direction) {
                          _removeFromFavorites(house.houseId);
                        },
                        child: HouseCard(
                          house: house,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HouseOverView(
                                  house: house,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}