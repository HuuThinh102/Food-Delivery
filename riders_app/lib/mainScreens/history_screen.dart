import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:riders_app/assistantMethods/assistant_methods.dart';
import 'package:riders_app/global/global.dart';
import 'package:riders_app/mainScreens/home_screen.dart';
import 'package:riders_app/widgets/order_cart.dart';
import 'package:riders_app/widgets/progress_bar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => const HomeScreen()));
                },
                icon: const Icon(Icons.arrow_back),
                style: const ButtonStyle(
                    iconColor: MaterialStatePropertyAll(Colors.white)),
              );
            },
          ),
          title: const Text(
            'History',
            style: TextStyle(
                fontSize: 45, fontFamily: 'Signatra', color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .where('riderUID', isEqualTo: sharedPreferences!.getString('uid'))
              .orderBy('orderTime', descending: true) //
              .where('status', isEqualTo: 'ended')
              .snapshots(),
          builder: (c, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data!.docs.length > 10
                        ? 10
                        : snapshot.data!.docs.length,
                    itemBuilder: (c, index) {
                      return FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('items')
                              .where('itemID',
                                  whereIn: separateOrderItemIDs((snapshot
                                          .data!.docs[index]
                                          .data()!
                                      as Map<String, dynamic>)["productIDs"]))
                              .orderBy('publishedDate', descending: true)
                              .get(),
                          builder: (c, snap) {
                            return snap.hasData
                                ? OrderCart(
                                    itemCount: snap.data!.docs.length,
                                    data: snap.data!.docs,
                                    orderID: snapshot.data!.docs[index].id,
                                    seperateQuantitiesList:
                                        separateOrderItemQuantities(
                                            (snapshot.data!.docs[index].data()!
                                                    as Map<String, dynamic>)[
                                                'productIDs']),
                                  )
                                : Center(
                                    child: circularProgress(),
                                  );
                          });
                    },
                  )
                : Center(
                    child: circularProgress(),
                  );
          },
        ),
      ),
    );
  }
}
