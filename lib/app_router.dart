import 'package:flutter/material.dart';
import 'package:parkspace/Screen/ForgotPassword/forgot_password.dart';
import 'package:parkspace/Screen/History/history_screen.dart';
import 'package:parkspace/Screen/Map/map_screen.dart';
import 'package:parkspace/Screen/Main/main_screen.dart';
import 'package:parkspace/Screen/PaymentMethod/payment_method.dart';
import 'package:parkspace/Screen/ActiveReservations/active_reservations_screen.dart';
import 'package:parkspace/Screen/PaymentMethod/paypal_payment_screen.dart';
import 'package:parkspace/Screen/SignUp/signup.dart';
import 'package:parkspace/Screen/Login/login.dart';

import 'Screen/MyProfile/profile.dart';
import 'Screen/SplashScreen/splash_screen.dart';

class PageViewTransition<T> extends MaterialPageRoute<T> {
  PageViewTransition({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (animation.status == AnimationStatus.reverse)
      return super
          .buildTransitions(context, animation, secondaryAnimation, child);
    return FadeTransition(opacity: animation, child: child);
  }
}

class AppRoute {
  static const String splashScreen = '/splashScreen';
  static const String loginScreen = '/login';
  static const String signUpScreen = '/signup';
  static const String forgotPasswordScreen = '/forgotPassword';
  static const String mainScreen = '/main';
  static const String mapScreen = '/map';
  static const String activeReservations = '/active';
  static const String profileScreen = '/profile';
  static const String historyScreen = '/history';
  static const String paymentMethodScreen = '/paymentMethod';
  static const String paypalScreen = '/paypal';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return PageViewTransition(builder: (_) => SplashScreen());
      case loginScreen:
        return PageViewTransition(builder: (_) => LoginScreen());
      case signUpScreen:
        return PageViewTransition(builder: (_) => SignupScreen());
      case forgotPasswordScreen:
        return PageViewTransition(builder: (_) => ForgotPasswordScreen());
      case mainScreen:
        return PageViewTransition(builder: (_) => MainScreen());
      case mapScreen:
        return PageViewTransition(builder: (_) => MapScreens());
      case profileScreen:
        return PageViewTransition(builder: (_) => ProfileScreen());

      case activeReservations:
        return PageViewTransition(builder: (_) => ActiveReservationScreen());
      case historyScreen:
        return PageViewTransition(builder: (_) => HistoryScreen());

      case paymentMethodScreen:
        return PageViewTransition(builder: (_) => PaymentMethodScreen());
      case paypalScreen:
        return PageViewTransition(builder: (_) => PaypalPayment());

      default:
        return PageViewTransition(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
