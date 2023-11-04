import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/assistantMethods/assistant_methods.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/mainScreens/home_screen.dart';

class PlacedOrderScreen extends StatefulWidget {
  String? addressID;
  double? totalAmount;
  String? sellerUID;
  String? paymentMethod;
  PlacedOrderScreen(
      {super.key,
      this.addressID,
      this.totalAmount,
      this.sellerUID,
      this.paymentMethod});

  @override
  State<PlacedOrderScreen> createState() => _PlacedOrderScreenState();
}

class _PlacedOrderScreenState extends State<PlacedOrderScreen> {
  String orderId = DateTime.now().millisecondsSinceEpoch.toString();

  addOrderDetails() {
    writeOrderDetailsForUser({
      'addressID': widget.addressID,
      'totalAmount': widget.totalAmount,
      'orderBy': sharedPreferences!.getString('uid'),
      'productIDs': sharedPreferences!.getStringList('userCart'),
      'paymentDetails': widget.paymentMethod,
      'orderTime': orderId,
      'isSuccess': true,
      'sellerUID': widget.sellerUID,
      'riderUID': '',
      'status': 'normal',
      'orderId': orderId,
    });
    writeOrderDetailsForSeller({
      'addressID': widget.addressID,
      'totalAmount': widget.totalAmount,
      'orderBy': sharedPreferences!.getString('uid'),
      'productIDs': sharedPreferences!.getStringList('userCart'),
      'paymentDetails': widget.paymentMethod,
      'orderTime': orderId,
      'isSuccess': true,
      'sellerUID': widget.sellerUID,
      'riderUID': '',
      'status': 'normal',
      'orderId': orderId,
    }).whenComplete(() {
      clearCartNow(context);
      setState(() {
        orderId = '';
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const HomeScreen()));
        Fluttertoast.showToast(
            msg: 'Congratulation, Order has been placed successfully.');
      });
    });
  }

  Future writeOrderDetailsForUser(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(sharedPreferences!.getString('uid'))
        .collection('orders')
        .doc(orderId)
        .set(data);
  }

  Future writeOrderDetailsForSeller(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .set(data);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.cyan,
              Colors.amber,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/delivery.jpg'),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
              ),
              onPressed: () {
                addOrderDetails();
              },
              child: const Text(
                "Place Order",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
