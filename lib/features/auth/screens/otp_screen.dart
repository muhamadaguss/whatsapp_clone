import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:whatsapp_cl/colors.dart';
import 'package:whatsapp_cl/features/auth/controller/auth_controller.dart';

class OTPScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> arguments;
  const OTPScreen({
    super.key,
    required this.arguments,
  });

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 56.w,
      textStyle: TextStyle(
        fontSize: 22.sp,
        color: Colors.white,
      ),
      // textStyle: GoogleFonts.poppins(
      //   fontSize: 22,
      //   color: const Color.fromRGBO(30, 60, 87, 1),
      // ),
      decoration: const BoxDecoration(),
    );

    final cursor = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 56.w,
          height: 3.h,
          decoration: BoxDecoration(
            color: messageColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ],
    );
    final preFilledWidget = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 56.w,
          height: 3.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify your phone number'),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 30.h,
            ),
            Text(
              'We have sent you an SMS with a 6-digit code',
              style: TextStyle(
                color: Colors.white.withOpacity(.7),
                fontSize: 12.sp,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 40.w,
                vertical: 20.h,
              ),
              child: Pinput(
                onChanged: (value) {
                  if (value.length == 6) {
                    ref.watch(authControllerProvider).verifyOTP(
                          context,
                          widget.arguments['verificationId'],
                          value.trim(),
                          widget.arguments['number'],
                        );
                  }
                },
                autofillHints: const [AutofillHints.oneTimeCode],
                length: 6,
                pinAnimationType: PinAnimationType.slide,
                controller: controller,
                focusNode: focusNode,
                defaultPinTheme: defaultPinTheme,
                showCursor: true,
                cursor: cursor,
                preFilledWidget: preFilledWidget,
              ),
            )
          ],
        ),
      ),
    );
  }
}
