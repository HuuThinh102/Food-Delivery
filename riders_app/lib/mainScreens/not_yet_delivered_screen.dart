import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:riders_app/assistantMethods/assistant_methods.dart';
import 'package:riders_app/global/global.dart';
import 'package:riders_app/widgets/order_cart.dart';
import 'package:riders_app/widgets/progress_bar.dart';
import 'package:riders_app/widgets/simple_app_bar.dart';

class NotYetDeliveredScreen extends StatefulWidget {
  const NotYetDeliveredScreen({super.key});

  @override
  State<NotYetDeliveredScreen> createState() => _NotYetDeliveredScreenState();
}

class _NotYetDeliveredScreenState extends State<NotYetDeliveredScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SimpleAppBar(
          title: 'To be Deliver',
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .where('riderUID', isEqualTo: sharedPreferences!.getString('uid'))
              .where('status', isEqualTo: 'delivering')
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
