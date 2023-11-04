import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistantMethods/address_changer.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/mainScreens/save_address_screen.dart';
import 'package:users_app/models/address.dart';
import 'package:users_app/widgets/address_design.dart';
import 'package:users_app/widgets/progress_bar.dart';
import 'package:users_app/widgets/simple_app_bar.dart';

class AddressScreen extends StatefulWidget {
  final double? totalAmount;
  final String? sellerUID;
  const AddressScreen({super.key, this.totalAmount, this.sellerUID});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: 'iFood',
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => SaveAddressScreen()));
        },
        label: const Text(
          'Add New Address',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.cyan,
        icon: const Icon(
          Icons.add_location,
          color: Colors.white,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Select Address:',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),
          Consumer<AddressChanger>(builder: (context, address, c) {
            return Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(sharedPreferences!.getString("uid"))
                    .collection("userAddress")
                    .snapshots(),
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? Center(
                          child: circularProgress(),
                        )
                      : snapshot.data!.docs.isEmpty
                          ? Container()
                          : ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return AddressDesign(
                                  currentIndex: address.count,
                                  value: index,
                                  addressID: snapshot.data!.docs[index].id,
                                  totalAmount: widget.totalAmount,
                                  sellerUID: widget.sellerUID,
                                  model: Address.fromJson(
                                      snapshot.data!.docs[index].data()!
                                          as Map<String, dynamic>),
                                );
                              },
                            );
                },
              ),
            );
          })
        ],
      ),
    );
  }
}
