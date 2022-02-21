import 'package:aivoiceweather/bloc/weather_bloc.dart';
import 'package:aivoiceweather/widgets/rounded_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aivoiceweather/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:aivoiceweather/screens/weather_screen.dart';


class RegistrationScreen extends StatefulWidget {
  static String id='reg';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth=FirebaseAuth.instance;
  String password;
  String email;
  bool showSpinner=false;
  WeatherBloc _weatherBloc;
//  void initState() {
//    super.initState();
//    _weatherBloc = BlocProvider.of<WeatherBloc>(context);
//  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
     // backgroundColor: Colors.black,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('assets/Snipbaby-removebg-preview.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                //  cursorColor: Colors.white,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))
                  ),
                  labelText: 'Email address',
                  prefixIcon: Icon(Icons.email,color: Colors.orange,),),
                //textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.left,

                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email=value;
                    //Do something with the user input.
                  },
//                  decoration:  KTextFieldEmailDecoration.copyWith(hintText: 'Enter email address'),
                 ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))
                  ),
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.security,color: Colors.orange,),),
                //textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.left,
                  obscureText: true,

                  onChanged: (value) {
                    password=value;
                    //Do something with the user input.
                  },
                 // decoration:  KTextFieldPasswordDecoration.copyWith(hintText: 'Enter password')
                 ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(text: 'Sign Up',
                color: Colors.orange,
                onPress:  () async{
                  setState(() {
                    showSpinner=true;
                  });
                  print(email);
                  print(password);
                  try {
                    final newUser= await _auth.createUserWithEmailAndPassword(email: email, password: password);
                    if (newUser != null) {
//                      Navigator.of(context).push(
//                          MaterialPageRoute<WeatherScreen>(
//                              builder: (_) => BlocProvider.value(
//                                value: BlocProvider.of<WeatherBloc>(context),
//                                child: WeatherScreen(user: null),
//                              )
//
//                          )
//                      );
                      Navigator.of(context).pushNamed("/settings");
                    }
                    setState(() {
                      showSpinner=false;
                    });
                  }catch(e){
                    print(e);
                  }
                },)
            ],
          ),
        ),
      ),
    );
  }
}
