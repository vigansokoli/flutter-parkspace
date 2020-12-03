import 'dart:async';

import 'package:flutter/material.dart';
import 'package:parkspace/app_router.dart';
import 'package:parkspace/services/user_service.dart';
import 'package:parkspace/theme/style.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Animation animation,
      delayedAnimation,
      muchDelayAnimation,
      transfor,
      fadeAnimation;
  AnimationController animationController;

  var uService;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);

    animation = Tween(begin: 0.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));

    transfor = BorderRadiusTween(
            begin: BorderRadius.circular(125.0),
            end: BorderRadius.circular(0.0))
        .animate(
            CurvedAnimation(parent: animationController, curve: Curves.ease));
    fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(animationController);
    animationController.forward();
    new Timer(new Duration(seconds: 2), () {
      // Navigator.of(context).pushNamedAndRemoveUntil(AppRoute.loginScreen, (Route<dynamic> route) => false);
      if (uService.user == null) {
        print('Login');
        Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoute.loginScreen, (Route<dynamic> route) => false);
      } else {
        print('Main');
        Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoute.mainScreen, (Route<dynamic> route) => false);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    uService = Provider.of<UserService>(context);

    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return Scaffold(
            body: new Container(
              decoration: new BoxDecoration(color: primaryColor),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Flexible(
                    flex: 1,
                    child: new Center(
                      child: FadeTransition(
                          opacity: fadeAnimation,
                          child: Image.asset(
                            "assets/image/logo.png",
                            height: 100.0,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
