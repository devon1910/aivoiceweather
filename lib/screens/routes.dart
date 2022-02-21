import 'package:aivoiceweather/screens/registeration_screen.dart';
import 'package:aivoiceweather/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:aivoiceweather/screens/settings_screen.dart';
import 'package:aivoiceweather/screens/weather_screen.dart';

import 'about.dart';

class Routes {

  static final mainRoute = <String, WidgetBuilder>{
    '/home': (context) => WeatherScreen(),
    '/settings': (context) => SettingsScreen(),
    '/signIn' : (context) => SignInScreen(),
    '/signUp' : (context) => RegistrationScreen(),
    '/about'  : (context) => AboutScreen()
  };
}
