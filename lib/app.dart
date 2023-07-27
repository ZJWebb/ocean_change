import 'package:flutter/material.dart';
import 'package:ocean_change/screens/create_account_screen.dart';
import 'package:ocean_change/screens/landing_screen.dart';
import 'package:ocean_change/screens/login_screen.dart';
import 'screens/view_report_screen.dart';
import 'screens/create_report_screen.dart';
import 'screens/map_screen.dart';
import 'screens/location_picker_screen.dart';

class App extends StatelessWidget {
  static final routes = {
    LandingScreen.routeName: (context) => const LandingScreen(),
    LoginScreen.routeName: (context) => const LoginScreen(),
    CreateAccountScreen.routeName: (context) => const CreateAccountScreen(),
    MapScreen.routeName: (context) => const MapScreen(),
    CreateReportScreen.routeName: (context) => const CreateReportScreen(),
    ViewReportScreen.routeName: (context) => const ViewReportScreen(),
    LocationPickerScreen.routeName: (context) => const LocationPickerScreen(),
  };

  const App({super.key});

  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ocean Change',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: App.routes,
    );
  }
}
