import 'package:flutter/material.dart';
import 'package:aivoiceweather/res/custom_colors.dart';
import 'package:aivoiceweather/utils/authentication.dart';
import 'package:aivoiceweather/widgets/google_sign_in_button.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(),

              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Flexible(
                      flex: 1,
                      child: Image.asset(
                        'assets/Snipbaby-removebg-preview.png',
                        height: 160,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'ClimApp',
                      style: GoogleFonts.poppins(
                      textStyle:TextStyle(
                      color: CustomColors.firebaseGrey,
                        fontSize: 40,
                      )
                      ),
                    ),
//                    Text(
//                      'Authentication',
//                      style: TextStyle(
//                        color: CustomColors.firebaseGrey,
//                        fontSize: 40,
//                      ),
//                    ),
                  ],
                ),
              ),

              FutureBuilder(
                future: Authentication.initializeFirebase(context: context),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error initializing Firebase');
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return GoogleSignInButton();
                  }
                  return CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      CustomColors.firebaseOrange,
                    ),
                  );
                },
              ),
              SizedBox(
                  height: 60.0
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No google account?', style: GoogleFonts.poppins(
                      textStyle:TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      )
                  ),),
                  SizedBox(
                    width: 50.0
                  ),
                  GestureDetector(
                    child: Text("Sign Up",
                      style: GoogleFonts.poppins(
                          textStyle:TextStyle(
                            color: CustomColors.firebaseGrey,
                            fontSize: 20,
                            fontWeight: FontWeight.w600
                          )
                      ),),
                    onTap: (){
                    //  Navigator.pushNamed(context, "register");
                      Navigator.of(context).pushNamed("/signUp");
                    },
                  )
                ],
              ),
              SizedBox(
                  height: 20.0
              ),
            ],
          ),
        ),
      ),
    );
  }
}