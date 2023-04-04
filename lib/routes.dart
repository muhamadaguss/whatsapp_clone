import 'package:flutter/material.dart';
import 'package:whatsapp_cl/features/auth/screens/login_screen.dart';
import 'package:whatsapp_cl/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_cl/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp_cl/features/contacts/screens/contacts_screen.dart';
import 'package:whatsapp_cl/features/landing/screens/landing_screen.dart';
import 'package:whatsapp_cl/features/chat/screens/mobile_chat_screen.dart';
import 'package:whatsapp_cl/screens/mobile_layout_screen.dart';
import 'package:whatsapp_cl/screens/web_layout_screen.dart';
import 'package:whatsapp_cl/utils/responsive_layout.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(
        builder: (context) => const LandingScreen(),
      );
    case '/login':
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case '/otp':
      return MaterialPageRoute(
        builder: (context) => OTPScreen(
          arguments: settings.arguments as Map<String, dynamic>,
        ),
      );
    case '/user-info':
      return MaterialPageRoute(
        builder: (context) => UserInformationScreen(
          arguments: settings.arguments as Map<String, dynamic>,
        ),
      );
    case '/home':
      return MaterialPageRoute(
        builder: (context) => const ResponsiveLayout(
          mobileScreenLayout: MobileLayoutScreen(),
          webScreenLayout: WebLayoutScreen(),
        ),
      );
    case '/contacts':
      return MaterialPageRoute(
        builder: (context) => const ContactsScreen(),
      );
    case '/chat':
      var arguments = settings.arguments as Map<String, dynamic>;
      var name = arguments['name'];
      var uid = arguments['uid'];
      return MaterialPageRoute(
        builder: (context) => LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 938) {
              // return WebLayoutScreen();
            }
            return MobileChatScreen(
              name: name,
              uid: uid,
            );
          },
        ),
      );
    default:
      return MaterialPageRoute(builder: (context) => const Scaffold());
  }
}
