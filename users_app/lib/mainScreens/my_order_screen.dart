import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:users_app/assistantMethods/assistant_methods.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/widgets/order_cart.dart';
import 'package:users_app/widgets/progress_bar.dart';
import 'package:users_app/widgets/simple_app_bar.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SimpleAppBar(
          title: 'My Orders',
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(sharedPreferences!.getString('uid'))
              .collection('orders')
              .where('status', isEqualTo: 'normal')
              .orderBy('orderTime', descending: true)
              .snapshots(),
          builder: (c, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (c, index) {
                      return FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('items')
                              .where('itemID',
                                  whereIn: separateOrderItemIDs((snapshot
                                          .data!.docs[index]
                                          .data()!
                                      as Map<String, dynamic>)["productIDs"]))
                              .where('orderBy',
                                  whereIn: (snapshot.data!.docs[index].data()!
                                      as Map<String, dynamic>)['uid'])
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
