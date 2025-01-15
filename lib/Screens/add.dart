// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realestate/Components/choosetypecard.dart';
import 'package:realestate/Components/dropdown.dart';
import 'package:realestate/Components/glow_button.dart';
import 'package:realestate/Components/my_textfield.dart';
import 'package:realestate/Components/mywilayastextfield.dart';
import 'package:realestate/Components/pricetxtfield.dart';
import 'package:realestate/Components/showsnackbar.dart';
import 'package:realestate/Helpers/validators.dart';
import 'package:realestate/Helpers/wilayas.dart';
import 'package:sizer/sizer.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class AddProperty extends StatefulWidget {
  const AddProperty({super.key});

  @override
  State<AddProperty> createState() => _AddPropertyState();
}

class _AddPropertyState extends State<AddProperty> {

  final TextEditingController wilayaController = TextEditingController();
  final TextEditingController neighborhoodController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final GlobalKey<FormState> _agentFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String selectedType = "Villa"; 
  int? selectedBeds = 1; 
  int? selectedBathrooms = 1;
  File? selectedImage;

  final ImagePicker _picker = ImagePicker(); 

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> savePropertyToFirestore() async {
    try {
      await _firestore.collection('properties').add({
        'agentId': _auth.currentUser!.uid, 
        'beds': selectedBeds,
        'bath': selectedBathrooms,
        'city': neighborhoodController.text.trim(),
        'description': descriptionController.text.trim(),
        'image': selectedImage != null ? selectedImage!.path : '', 
        'price': priceController.text.trim(),
        'type': selectedType,
        'wilaya': wilayaController.text.trim(),
      });

      await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .update({'phone': phoneController.text.trim()});

      clearFormFields();
      print('Property saved successfully');
    } catch (e) {
      CustomSnackbar.showError(context: context, message: 'Failure saving property: $e');
    }
  }

  @override
  void dispose() {
    wilayaController.dispose();
    neighborhoodController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 100.h),
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          decoration: const BoxDecoration(color: Color(0xff12232B)),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5.h),
                Text(
                  'Add a new property',
                  style: GoogleFonts.montserrat(
                    fontSize: 13 * 1.6,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2.h),
                MyWilayasTextField(
                  hinttext: 'Wilaya',
                  myController: wilayaController,
                  myIcon: Icons.location_city_outlined,
                  isObsecure: false,
                  myValidator: (value) => FormValidators.validateNull(context, value, 'Wilaya'),
                  suggestions: Wilayas.wilayaNames,
                ),
                SizedBox(height: 1.h),
                MyTextField(
                  hinttext: 'Neighborhood',
                  myController: neighborhoodController,
                  myIcon: Icons.home_outlined,
                  isObsecure: false,
                  myValidator: (value) => FormValidators.validateNull(context, value, 'Neighborhood'),
                ),
                SizedBox(height: 1.h),
                MyTextField(
                  hinttext: 'Description',
                  myController: descriptionController,
                  myIcon: Icons.description_outlined,
                  isObsecure: false,
                  myValidator: (value) => FormValidators.validateNull(context, value, 'Description'),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Property type',
                  style: GoogleFonts.montserrat(
                    fontSize: 13 * 1.6,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TypeChoiceCard(
                      title: "Villa",
                      isSelected: selectedType == "Villa",
                      onTap: () {
                        setState(() {
                          selectedType = "Villa";
                        });
                      },
                    ),
                    TypeChoiceCard(
                      title: "Bungalow",
                      isSelected: selectedType == "Bungalow",
                      onTap: () {
                        setState(() {
                          selectedType = "Bungalow";
                        });
                      },
                    ),
                    TypeChoiceCard(
                      title: "Apartment",
                      isSelected: selectedType == "Apartment",
                      onTap: () {
                        setState(() {
                          selectedType = "Apartment";
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Text(
                  'Home details',
                  style: GoogleFonts.montserrat(
                    fontSize: 13 * 1.6,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomDropdown(
                      label: "Beds",
                      options: const [1, 2, 3, 4, 5],
                      selectedValue: selectedBeds,
                      onChanged: (value) {
                        setState(() {
                          selectedBeds = value;
                        });
                      },
                    ),
                    CustomDropdown(
                      label: "Bathrooms",
                      options: const [1, 2, 3, 4, 5],
                      selectedValue: selectedBathrooms,
                      onChanged: (value) {
                        setState(() {
                          selectedBathrooms = value;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                PriceTextField(
                  controller: priceController,
                  hinttext: 'Price',
                  myValidator: (value) => FormValidators.priceValidator(context, value),
                ),
                SizedBox(height: 3.h),
                GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    height: 20.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Center(
                            child: Text(
                              'Tap to select image',
                              style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 19.sp),
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 3.h,),
                MyGlowingButton(
                  text: 'Add Property',
                  onTap: () {
                    if (submitForm()) {
                      _openWoltModalSheet();
                    }
                  },
                  hasEmail: false
                ),
                SizedBox(height: 14.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openWoltModalSheet() {
    WoltModalSheet.show<void>(context: context, pageListBuilder: (context) {
      return [
        WoltModalSheetPage(
          hasTopBarLayer: false,
          child: _modalSheetContent(),
        ),
      ];
    });
  }

  Widget _modalSheetContent() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setModalState) {
        return Container(
          constraints: BoxConstraints(maxHeight: 100.h),
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          width: double.infinity,
          decoration: const BoxDecoration(color: Color(0xff12232B)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _agentFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  SizedBox(height: 3.h),
                  Text(
                    'Agent Information',
                    style: GoogleFonts.montserrat(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  MyTextField(
                    hinttext: 'Phone Number',
                    myController: phoneController,
                    myIcon: Icons.phone_outlined,
                    isObsecure: false,
                    myValidator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone number cannot be empty';
                      }
                      if (!RegExp(r'^\+?\d{10,15}$').hasMatch(value)) {
                        return 'Enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 3.h),
                  MyGlowingButton(
                    text: 'Submit',
                    onTap: () {
                      if (_agentFormKey.currentState!.validate()) {
                        savePropertyToFirestore();
                        Navigator.of(context).pop();
                      }
                    },
                    hasEmail: false
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  pickImage() async {
    XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return await pickedFile.readAsBytes();
    }
  }


  bool submitForm() {
    if (_formKey.currentState!.validate()) {
      if (selectedType.isEmpty) {
        // Show error if no type is selected
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a property type')),
        );
        return false;
      }
      print('Form Submitted: ${wilayaController.text}, ${neighborhoodController.text}, $selectedType, Beds: $selectedBeds, Bathrooms: $selectedBathrooms');
      return true;
    } else {
      print('Form validation failed');
      return false;
    }
  }

  void clearFormFields() {
    wilayaController.clear();
    neighborhoodController.clear();
    descriptionController.clear();
    priceController.clear();
    phoneController.clear();
    setState(() {
      selectedType = "Villa"; 
      selectedBeds = 1; 
      selectedBathrooms = 1;
    });
  }

}
