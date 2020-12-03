import 'package:parkspace/provider_setup.dart';
import 'package:provider/provider.dart';

import 'app_router.dart';
import 'package:flutter/material.dart';
import 'theme/style.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'ParkSpace',
        theme: appTheme,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRoute.generateRoute,
        initialRoute: AppRoute.splashScreen,
      ),
    );
  }
}