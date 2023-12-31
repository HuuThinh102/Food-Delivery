import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:riders_app/assistantMethods/get_current_location.dart';
import 'package:riders_app/authentication/auth_screen.dart';
import 'package:riders_app/global/global.dart';
import 'package:riders_app/mainScreens/earnings_screent.dart';
import 'package:riders_app/mainScreens/history_screen.dart';
import 'package:riders_app/mainScreens/new_orders_screen.dart';
import 'package:riders_app/mainScreens/not_yet_delivered_screen.dart';
import 'package:riders_app/mainScreens/parcel_in_progress_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Card makeDashboardItem(String title, IconData iconData, int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Container(
        decoration: index == 0 || index == 3 || index == 4
            ? const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.cyan,
                    //Colors.amber,
                    Color.fromARGB(255, 103, 227, 243),
                  ],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              )
            : const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.cyan,
                    //Colors.amber,
                    Color.fromARGB(255, 103, 227, 243),
                  ],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
        child: InkWell(
          onTap: () {
            if (index == 0) {
              //new available order
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const NewOrdersScreen()));
            }
            if (index == 1) {
              //parcels in progress
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => const ParcelInProgressScreen()));
            }
            if (index == 2) {
              //not yet delivered
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => const NotYetDeliveredScreen()));
            }
            if (index == 3) {
              //history
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const HistoryScreen()));
            }
            if (index == 4) {
              //total earning
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const EarningsScreen()));
            }
            if (index == 5) {
              //logout
              firebaseAuth.signOut().then(
                (value) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => const AuthScreen()));
                },
              );
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: [
              const SizedBox(height: 50),
              Center(
                child: Icon(
                  iconData,
                  size: 40,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    UserLocation? uLocation = UserLocation();
    uLocation.getCurrentLocation();
    getPerParcelDeliveryAmount();
    getRiderPreviousEarnings();
  }

  getRiderPreviousEarnings() {
    FirebaseFirestore.instance
        .collection('riders')
        .doc(sharedPreferences!.getString('uid'))
        .get()
        .then((snap) {
      previousRiderEarnings = snap.data()!['earnings'].toString();
    });
  }

  getPerParcelDeliveryAmount() {
    FirebaseFirestore.instance
        .collection('perDelivery')
        .doc('nam')
        .get()
        .then((snap) {
      perParcelDeliveryAmount = snap.data()!['amount'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.cyan,
                Color.fromARGB(255, 103, 227, 243),
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text(
          'Welcome ${sharedPreferences!.getString('name')!}',
          style: const TextStyle(
              fontSize: 30,
              color: Colors.black,
              fontFamily: 'Signatra',
              fontWeight: FontWeight.bold,
              letterSpacing: 2),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 1),
          child: GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(2),
            children: [
              makeDashboardItem('New Available Orders', Icons.assessment, 0),
              makeDashboardItem(
                  'Parcels in Progress', Icons.airport_shuttle, 1),
              makeDashboardItem('Not Yet Delivered', Icons.location_history, 2),
              makeDashboardItem('History', Icons.done_all, 3),
              makeDashboardItem('Total Earnings', Icons.monetization_on, 4),
              makeDashboardItem('Logout', Icons.logout, 5),
            ],
          ),
        ),
      ),
    );
  }
}
