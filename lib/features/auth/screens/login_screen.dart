import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:whatsapp_cl/colors.dart';
import 'package:whatsapp_cl/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_cl/utils/utils.dart';
import 'package:whatsapp_cl/widgets/custom_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String? phoneNumber = '';
  String? countryCode = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter your phone number'),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30.h,
            ),
            Text(
              'Enter your phone number to continue',
              style: TextStyle(
                color: textColor,
                fontSize: 12.sp,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15.w,
              ),
              child: IntlPhoneField(
                autovalidateMode: AutovalidateMode.disabled,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.r),
                    ),
                  ),
                ),
                onChanged: (phone) {
                  print(phone.completeNumber);
                  phoneNumber = phone.completeNumber;
                  countryCode = phone.countryCode;
                },
                onCountryChanged: (country) {
                  print('Country changed to: ' + country.name);
                },
                initialCountryCode: 'ID',
                pickerDialogStyle: PickerDialogStyle(
                  backgroundColor: backgroundColor,
                  countryCodeStyle: TextStyle(
                    color: textColor,
                    fontSize: 11.sp,
                  ),
                  countryNameStyle: TextStyle(
                    color: textColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  searchFieldInputDecoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      color: textColor,
                      fontSize: 12.sp,
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: textColor,
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  width: 280.w,
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 300.w,
              height: 30.h,
              child: CustomButton(
                text: 'LOGIN',
                onPressed: () {
                  if (phoneNumber != '' &&
                      countryCode != '' &&
                      countryCode != phoneNumber) {
                    ref.read(authControllerProvider).signInWithPhone(
                          context,
                          phoneNumber!,
                        );
                  } else {
                    showSnackbar(
                      context: context,
                      content:
                          'Nomor Telepon tidak boleh kosong atau tidak valid',
                    );
                  }
                },
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
          ],
        ),
      ),
    );
  }
}
