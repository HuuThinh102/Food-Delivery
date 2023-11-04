import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:users_app/authentication/login.dart';
import 'package:users_app/authentication/register.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          }
        },
      );

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('No Connection'),
          content: const Text('Please check your internet connectivity'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() => isAlertSet = false);
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected && isAlertSet == false) {
                  showDialogBox();
                  setState(() => isAlertSet = true);
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  // Colors.cyan,
                  // Colors.amber,

                  Color.fromARGB(255, 248, 244, 214),
                  Color.fromARGB(255, 188, 245, 255),
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          title: const Text(
            'iFood',
            style: TextStyle(
              fontSize: 60,
              color: Color.fromARGB(255, 58, 140, 235),
              fontFamily: 'Train',
              letterSpacing: 6,
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: Color.fromARGB(255, 17, 35, 255),
            tabs: [
              Tab(
                text: 'Login',
                icon: Icon(
                  Icons.lock,
                ),
              ),
              Tab(
                text: "Register",
                icon: Icon(
                  Icons.person,
                ),
              ),
            ],
            indicatorColor: Color.fromARGB(97, 45, 81, 243),
            indicatorWeight: 6,
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              // Colors.amber,
              // Colors.cyan,

              Color.fromARGB(255, 188, 245, 255),
              Color.fromARGB(255, 248, 244, 214),
            ],
          )),
          child: const TabBarView(
            children: [
              LoginScreen(),
              RegisterScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
