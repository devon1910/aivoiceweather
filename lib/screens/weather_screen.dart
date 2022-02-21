import 'package:aivoiceweather/utils/converters.dart';
import 'package:alan_voice/alan_voice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aivoiceweather/main.dart';
import 'package:aivoiceweather/bloc/weather_event.dart';
import 'package:aivoiceweather/bloc/weather_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aivoiceweather/widgets/weather_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';


import '../bloc/weather_bloc.dart';

enum OptionsMenu { changeCity, settings,about }

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key key, @required String user})
      : _user = user,
        super(key: key);

  final String _user;

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen>
    with TickerProviderStateMixin {
  WeatherBloc _weatherBloc;
  String _cityName = 'ogun';
  Animation<double> _fadeAnimation;
  AnimationController _fadeController;
  String userr;

  @override
  void initState() {
    super.initState();
    setupAlan();
    userr= widget._user;
    _weatherBloc = BlocProvider.of<WeatherBloc>(context);

    _fetchWeatherWithLocation().catchError((error) {
      _fetchWeatherWithCity();
    });

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
  }

  //SETTING UP ALAN VOICE
  setupAlan() {
//    print("BANANAS lol");
    AlanVoice.addButton(
        "a73cb6878f4c7a8a309e3d3209076b812e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT);
    AlanVoice.callbacks.add((command) => _handleCommand(command.data));
  }

  _handleCommand(Map<String, dynamic> response) async {
    debugPrint("New response: $response");
    switch (response["command"]) {
      case "get_weatherInfo":
        dynamic weatherData = response["details"];
        String ctyName = weatherData["name"];
        _weatherBloc.add(FetchWeather(cityName: ctyName));
        break;
      case "settings":
        Navigator.of(context).pushNamed("/settings");
        break;
      case "home":
        Navigator.pop(context);
        break;
      case "about":
        Navigator.pop(context);
        break;
      case "change_theme":
        dynamic value=response["val"];
        if(value == "White" || value == "light"){
          print("Light");
          AppStateContainer.of(context).updateTheme(1);
        }else if(value=="dark" || value == "black"){
          print("dark");
          AppStateContainer.of(context).updateTheme(0);
        }
        else{
          print("Select a recognized unit");
        }
        break;
      case "change_unit":
        dynamic value=response["val"];
        if(value == "Celsius"){
          print("celsius");
          AppStateContainer.of(context)
              .updateTemperatureUnit(TemperatureUnit.celsius);
        }
        else if(value == "Fahrenheit"){
          print("fah");
          AppStateContainer.of(context)
              .updateTemperatureUnit(TemperatureUnit.fahrenheit);
        }
        else if(value=="Kelvin"){
          print("Kelvin");
          AppStateContainer.of(context)
              .updateTemperatureUnit(TemperatureUnit.kelvin);
        }
        else{
          print("Select a recognized unit");
        }
        break;
      default:
        print("No available weather data for your city");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData appTheme = AppStateContainer.of(context).theme;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: appTheme.primaryColor,
          elevation: 0,
          title: Row(

            children: <Widget>[
              Text(
                'Hi, $userr😀',
                style: TextStyle(
                  color: appTheme.accentColor,
                  fontSize: 11,
                ),
              ),
              SizedBox(width: 25.0),
              Text(
                DateFormat('EEEE, d MMMM yyyy').format(DateTime.now()),
                style: TextStyle(
                  color: appTheme.accentColor,
                  fontSize: 10,
                ),
              )
            ],
          ),
          actions: <Widget>[
            PopupMenuButton<OptionsMenu>(
                child: Icon(
                  Icons.more_vert,
                  color: appTheme.accentColor,
                ),
                onSelected: this._onOptionMenuItemSelected,
                itemBuilder: (context) => <PopupMenuEntry<OptionsMenu>>[
                      PopupMenuItem<OptionsMenu>(
                        value: OptionsMenu.changeCity,
                        child: Text("change city"),
                      ),
                      PopupMenuItem<OptionsMenu>(
                        value: OptionsMenu.settings,
                        child: Text("settings"),
                      ),
                       PopupMenuItem<OptionsMenu>(
                        value: OptionsMenu.about,
                        child: Text("about"),
                  ),
                ])
          ],
        ),
        backgroundColor: Colors.white,
        body: Material(
          child: Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(color: appTheme.primaryColor),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: BlocBuilder<WeatherBloc, WeatherState>(
                  builder: (_, WeatherState weatherState) {
                _fadeController.reset();
                _fadeController.forward();

                if (weatherState is WeatherLoaded) {
                  this._cityName = weatherState.weather.cityName;
                  return WeatherWidget(
                    weather: weatherState.weather,
                  );
                } else if (weatherState is WeatherError ||
                    weatherState is WeatherEmpty) {
                  String errorText = 'There was an error fetching weather data';
                  if (weatherState is WeatherError) {
                    if (weatherState.errorCode == 404) {
                      errorText =
                          'We have trouble fetching weather for $_cityName';
                    }
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.error_outline,
                        color: Colors.redAccent,
                        size: 24,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        errorText,
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          primary: appTheme.accentColor,
                          elevation: 1,
                        ),
                        child: Text("Try Again"),
                        onPressed: _fetchWeatherWithCity,
                      )
                    ],
                  );
                } else if (weatherState is WeatherLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: appTheme.primaryColor,
                    ),
                  );
                }
                return Container(
                  child: Text('No city set'),
                );
              }),
            ),
          ),
        ));
  }

  void _showCityChangeDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          ThemeData appTheme = AppStateContainer.of(context).theme;

          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text('Change city', style: TextStyle(color: Colors.black)),
            actions: <Widget>[
              TextButton(
                child: Text('ok'),
                style: TextButton.styleFrom(
                  primary: appTheme.accentColor,
                  elevation: 1,
                ),
                onPressed: () {
                  _fetchWeatherWithCity();
                  Navigator.of(context).pop();
                },
              ),
            ],
            content: TextField(
              autofocus: true,
              onChanged: (text) {
                _cityName = text;
              },
              decoration: InputDecoration(
                  hintText: 'Name of your city',
                  hintStyle: TextStyle(color: Colors.black),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      _fetchWeatherWithLocation().catchError((error) {
                        _fetchWeatherWithCity();
                      });
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.my_location,
                      color: Colors.black,
                      size: 16,
                    ),
                  )),
              style: TextStyle(color: Colors.black),
              cursorColor: Colors.black,
            ),
          );
        });
  }

  _onOptionMenuItemSelected(OptionsMenu item) {
    switch (item) {
      case OptionsMenu.changeCity:
        this._showCityChangeDialog();
        break;
      case OptionsMenu.settings:
        Navigator.of(context).pushNamed("/settings");
        break;
      case OptionsMenu.about:
        Navigator.of(context).pushNamed("/about");
        break;
    }
  }

  _fetchWeatherWithCity() {
    _weatherBloc.add(FetchWeather(cityName: _cityName));
  }

  _fetchWeatherWithLocation() async {
    var permissionResult = await Permission.locationWhenInUse.status;

    switch (permissionResult) {
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
        print('location permission denied');
        _showLocationDeniedDialog();
        break;

      case PermissionStatus.denied:
        await Permission.locationWhenInUse.request();
        _fetchWeatherWithLocation();
        break;

      case PermissionStatus.limited:
      case PermissionStatus.granted:
        print('getting location');
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low,
            timeLimit: Duration(seconds: 2));

        print(position.toString());

        _weatherBloc.add(FetchWeather(
          longitude: position.longitude,
          latitude: position.latitude,
        ));
        break;
    }
  }

  void _showLocationDeniedDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          ThemeData appTheme = AppStateContainer.of(context).theme;

          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text('Location is disabled :(',
                style: TextStyle(color: Colors.black)),
            actions: <Widget>[
              TextButton(
                child: Text('Enable!'),
                style: TextButton.styleFrom(
                  primary: appTheme.accentColor,
                  elevation: 1,
                ),
                onPressed: () {
                  openAppSettings();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
