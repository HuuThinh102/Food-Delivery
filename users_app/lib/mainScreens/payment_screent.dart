import 'package:flutter/material.dart';
import 'package:users_app/mainScreens/placed_order_screen.dart';
import 'package:users_app/widgets/simple_app_bar.dart';

class PaymentScreen extends StatefulWidget {
  String? addressID;
  double? totalAmount;
  String? sellerUID;
  String? paymentMethod;
  PaymentScreen(
      {super.key,
      this.addressID,
      this.totalAmount,
      this.sellerUID,
      this.paymentMethod});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? payment;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: SimpleAppBar(
          title: 'iFood',
        ),
        body: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Choose your Payment Method:',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
            ListTile(
              title: const Text('Cash on Delivery'),
              leading: Radio(
                value: 'Cash on Delivery',
                groupValue: payment,
                onChanged: (value) {
                  setState(() {
                    payment = value;
                    widget.paymentMethod = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Momo'),
              trailing: Image.asset(
                'images/momoicon.png',
                width: 70,
              ),
              leading: Radio(
                value: 'Momo',
                groupValue: payment,
                onChanged: (value) {
                  setState(() {
                    payment = value;
                    widget.paymentMethod = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('ZaloPay'),
              trailing: Image.asset(
                'images/zalopayicon.png',
              ),
              leading: Radio(
                value: 'ZaloPay',
                groupValue: payment,
                onChanged: (value) {
                  setState(() {
                    payment = value;
                    widget.paymentMethod = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => PlacedOrderScreen(
                              addressID: widget.addressID,
                              totalAmount: widget.totalAmount,
                              sellerUID: widget.sellerUID,
                              paymentMethod: widget.paymentMethod,
                            )));
              },
              child: const Text(
                "Pay",
                style: TextStyle(
                    color: Colors.white, fontSize: 20, fontFamily: 'Acme'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
