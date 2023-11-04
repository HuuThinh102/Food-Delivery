import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/mainScreens/home_screen.dart';
import 'package:sellers_app/models/items.dart';
//import 'package:sellers_app/splashScreen.dart/splash_screen.dart';
import 'package:sellers_app/widgets/simple_app_bar.dart';

class ItemDetailsScreen extends StatefulWidget {
  final Items? model;
  const ItemDetailsScreen({super.key, this.model});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  TextEditingController counterTextEditingController = TextEditingController();

  deleteItem(String itemID) {
    FirebaseFirestore.instance
        .collection('sellers')
        .doc(sharedPreferences!.getString('uid'))
        .collection('menus')
        .doc(widget.model!.menuID!)
        .collection('items')
        .doc(itemID)
        .delete()
        .then((value) {
      FirebaseFirestore.instance.collection('items').doc(itemID).delete();
      Navigator.push(
          context, MaterialPageRoute(builder: (c) => const HomeScreen()));
      Fluttertoast.showToast(msg: 'Item Deleted Successfully.');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: sharedPreferences!.getString('name')),
      body: ListView(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            widget.model!.thumbnailUrl.toString(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.model!.title.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.model!.longDescription.toString(),
              textAlign: TextAlign.justify,
              style:
                  const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '\$ ${widget.model!.price}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: InkWell(
              onTap: () {
                deleteItem(widget.model!.itemID!);
              },
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
                width: MediaQuery.of(context).size.width - 13,
                height: 50,
                child: const Center(
                  child: Text(
                    'Delete this Item',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
