import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:dmp_app/data/Doctor.dart';
import 'package:dmp_app/data/Patient.dart';
import 'package:dmp_app/pages/doctor_home_page/dr_home_page_widget.dart';
import 'package:dmp_app/pages/home_page/home_page_widget.dart';
import 'package:dmp_app/pages/welcome_page.dart';
import 'package:dmp_app/urls.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import 'flutter_flow/nav/nav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();

  await FlutterFlowTheme.initialize();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  bool _isAlreadyLoggedIn = false;
  String userEmail = '';
  String userPassword = '';
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  @override
  void initState() {
    super.initState();
    _appStateNotifier = AppStateNotifier.instance;
    checkLoginState();
  }

  void checkLoginState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userEmail = prefs.getString('userEmail') ?? '';
    userPassword = prefs.getString('userPassword') ?? '';

    if (userEmail != '' && userPassword != '') {
      setState(() {
        _isAlreadyLoggedIn = true;
      });
      login();
    }
  }

  void setLocale(String language) {
    setState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  void login() async {
    var res;
    try {
      res = await Dio().post(LOGIN_URL,
          data: {"email": userEmail, "password": userPassword});
    } catch (e) {
      _showLoginFailureDialog();
    }

    if (res.data['success']) {
      print('logged on successfully');
      var rest;
      var rolee;
      var token = res.data['token'];
      Dio dio = new Dio();
      dio.options.headers["authorization"] = "Bearer $token";

      try {
        rest = await dio.get(Profile_URL);
      } catch (e) {
        _showLoginFailureDialog();
      }

      if (rest.data['success']) {
        rolee = rest.data['profile']['role'];
        print(rest.data['profile']);

        // Initialize nextPage with a default value, such as an empty Container
        Widget nextPage = Container();

        if (rolee.toString() == "Doctor") {
          Doctor doctor = Doctor.fromJson(rest.data);
          nextPage = DrHomePageWidget(
            token: res.data['token'],
            decryptPass: userPassword,
            doctorProfile: doctor,
            password: userPassword,
          );
        } else if (rolee.toString() == "Patient") {
          Patient patient = Patient.fromJson(rest.data);
          nextPage = HomePageWidget(
            token: res.data['token'],
            patientProfile: patient,
            password: userPassword,
            decryptPass: userPassword,
          );
        }

        setState(() {
          _isAlreadyLoggedIn = false; // Reset the flag
        });

        // Navigate to the next page
        if (nextPage is! Container) {
          navigatorKey.currentState?.pushReplacement(
              MaterialPageRoute(builder: (context) => nextPage));
        }
      } else {
        print(res.data['msg']);
        setState(() {
          _isAlreadyLoggedIn = false; // Reset the flag on error
        });
        _showLoginFailureDialog();
      }
    } else {
      setState(() {
        _isAlreadyLoggedIn = false; // Reset the flag on login failure
      });
      _showLoginFailureDialog();
    }
  }

  void _showLoginFailureDialog() {
    showDialog(
        context: navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Login Failed"),
            content: Text("Please check your credentials and try again."),
            actions: <Widget>[
              ElevatedButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss the dialog
                  navigatorKey.currentState!.pushReplacement(
                      MaterialPageRoute(builder: (context) => WelcomePage()));
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    if (_isAlreadyLoggedIn) {
      return MaterialApp(
        navigatorKey: navigatorKey,
        theme: ThemeData(brightness: Brightness.light),
        darkTheme: ThemeData(brightness: Brightness.dark),
        themeMode: _themeMode,
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(), // The progress indicator
                SizedBox(height: 20), // Space between indicator and text
                Text('Logging in...',
                    style: TextStyle(fontSize: 16)) // Your message
              ],
            ),
          ),
        ),
      );
    } else {
      return MaterialApp(
        navigatorKey: navigatorKey,
        title: 'DMP APP',
        theme: ThemeData(brightness: Brightness.light),
        darkTheme: ThemeData(brightness: Brightness.dark),
        themeMode: _themeMode,
        home: WelcomePage(), // Set LoginPage as the main page
        localizationsDelegates: [
          FFLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en', '')],
      );
    }
  }
}
