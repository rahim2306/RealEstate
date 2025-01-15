import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:realestate/Components/littlebutton.dart';
import 'package:realestate/Models/housemodel.dart';
import 'package:sizer/sizer.dart';

class HouseCard extends StatelessWidget {

  final HouseModel house;
  final Function onTap;

  const HouseCard({super.key, required this.house, required this.onTap});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.4.h),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => onTap(),
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
                      image: house.type == 'Villa' ?
                          const AssetImage('assets/images/villa.jpg') 
                          :
                          house.type == 'Apartment'? 
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
                      Text(
                        house.city,
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
                            '${house.wilaya}, Algeria',
                            style: GoogleFonts.montserrat(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${house.price} Da',
                            style: GoogleFonts.montserrat(
                              fontSize: 14.sp * 1.6,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          MyLittleButton(
                            text: house.type,
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
        ),
      ),
    );
  }
}