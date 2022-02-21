import 'package:flutter/material.dart';

import '../main.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = AppStateContainer.of(context).theme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appTheme.primaryColor,
        title: Text("About"),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 15),
        color: appTheme.primaryColor,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  "About ClimApp",
                  style: TextStyle(
                    color: appTheme.accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0
            ),
            Expanded(
              child: Text(
                "ClimApp is a hands-free fully fledged mobile application\n"
                    "Get weather information for any city in the world e.g\n"
                    "\"hey Alan, Give me the full weather report in Lagos\"\n"
                    "You can also update the theme as well as Temperature units of ClimApp e.g\n"
                    "\"hey Alan, update app theme to white.",
                style: TextStyle(
                    color: appTheme.accentColor,
                fontWeight: FontWeight.w500),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
