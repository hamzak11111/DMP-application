import 'package:dmp_app/pages/login/login_page.dart';
import 'package:dmp_app/pages/signup/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:dmp_app/flutter_flow/flutter_flow_theme.dart'; // Import your FlutterFlow theme

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.2), // Start from slightly below the original position
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward(); // Start the animation
  }

  @override
  void dispose() {
    _animationController
        .dispose(); // Dispose the controller when the widget is removed from the widget tree
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
            child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(flex: 2),
                Text(
                  'Welcome To MediScan',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).title1.override(
                        fontFamily: 'Poppins',
                        color: FlutterFlowTheme.of(context).primaryText,
                      ),
                ),
                Spacer(),
                // Adjust the size of the image container as needed
                Expanded(
                  flex: 8,
                  child: Image.asset(
                    'assets/images/Medical Report Prescription Logo.png', // Replace with your image asset path
                    fit: BoxFit.contain,
                  ),
                ),
                Spacer(),
                Text(
                  textAlign: TextAlign.center,
                  'Get started with your journey',
                  style: FlutterFlowTheme.of(context).subtitle2.override(
                        fontFamily: 'Poppins',
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                ),
                Spacer(flex: 2),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 50), // Add padding to the sides
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LoginPage())); // Use your login route
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          FlutterFlowTheme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Rounded corners
                      ),
                    ),
                    child: Text('Login'),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 50), // Add padding to the sides
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Signup())); // Use your signup route
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          FlutterFlowTheme.of(context).secondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Rounded corners
                      ),
                    ),
                    child: Text('Signup'),
                  ),
                ),
                Spacer(flex: 3),
              ],
            ),
          ),
        )));
  }
}
