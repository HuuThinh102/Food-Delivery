import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistantMethods/address_changer.dart';
import 'package:users_app/mainScreens/payment_screent.dart';
import 'package:users_app/mainScreens/placed_order_screen.dart';
import 'package:users_app/models/address.dart';

class AddressDesign extends StatefulWidget {
  final Address? model;
  final int? currentIndex;
  final int? value;
  final String? addressID;
  final double? totalAmount;
  final String? sellerUID;
  final String? paymentMethod;

  const AddressDesign({
    super.key,
    this.model,
    this.currentIndex,
    this.value,
    this.addressID,
    this.totalAmount,
    this.sellerUID,
    this.paymentMethod,
  });

  @override
  State<AddressDesign> createState() => _AddressDesignState();
}

class _AddressDesignState extends State<AddressDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //select this address
        Provider.of<AddressChanger>(context, listen: false)
            .displayResult(widget.value);
      },
      child: Card(
        color: Colors.cyan.withOpacity(0.4),
        child: Column(
          children: [
            //address info
            Row(
              children: [
                Radio(
                  groupValue: widget.currentIndex!,
                  value: widget.value!,
                  activeColor: Colors.amber,
                  onChanged: (val) {
                    //provider
                    Provider.of<AddressChanger>(context, listen: false)
                        .displayResult(val);
                    //print(val);
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Table(
                        children: [
                          TableRow(
                            children: [
                              const Text(
                                "Name: ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(widget.model!.name.toString()),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Text(
                                "Phone Number: ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(widget.model!.phoneNumber.toString()),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Text(
                                "Flat Number: ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(widget.model!.flatNumber.toString()),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Text(
                                "City: ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(widget.model!.city.toString()),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Text(
                                "State: ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(widget.model!.state.toString()),
                            ],
                          ),
                          TableRow(
                            children: [
                              const Text(
                                "Full Address: ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(widget.model!.fullAddress.toString()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            //button
            widget.value == Provider.of<AddressChanger>(context).count
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (c) => PlacedOrderScreen(
                      //       addressID: widget.addressID,
                      //       totalAmount: widget.totalAmount,
                      //       sellerUID: widget.sellerUID,
                      //     ),
                      //   ),
                      // );
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => PaymentScreen(
                                    addressID: widget.addressID,
                                    totalAmount: widget.totalAmount,
                                    sellerUID: widget.sellerUID,
                                    paymentMethod: widget.paymentMethod,
                                  )));
                    },
                    child: const Text(
                      "Proceed",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : Container(),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
