import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_cl/colors.dart';
import 'package:whatsapp_cl/widgets/custom_button.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 30.h,
              ),
              Text(
                'Welcome to Whatsapp',
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30.h,
              ),
              Image.asset(
                'assets/bg.png',
                height: 300.h,
                width: 300.w,
                color: tabColor,
              ),
              SizedBox(
                height: 40.h,
              ),
              Text(
                'Read our privacy policy. Tap "Agree and continue" to accept the Terms of Service',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: textColor.withOpacity(
                    0.5,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 40.h,
              ),
              SizedBox(
                width: 300.w,
                height: 40.h,
                child: CustomButton(
                  text: 'AGREE AND CONTINUE',
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
