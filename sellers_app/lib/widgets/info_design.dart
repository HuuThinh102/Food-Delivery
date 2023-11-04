import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/mainScreens/items_screen.dart';
import 'package:sellers_app/models/menus.dart';

class InfoDesignWidget extends StatefulWidget {
  Menus? model;
  BuildContext? context;

  InfoDesignWidget({super.key, this.context, this.model});

  @override
  State<InfoDesignWidget> createState() => _InfoDesignWidgetState();
}

class _InfoDesignWidgetState extends State<InfoDesignWidget> {
  deleteMenus(String menuID) {
    FirebaseFirestore.instance
        .collection('sellers')
        .doc(sharedPreferences!.getString('uid'))
        .collection('menus')
        .doc(menuID)
        .delete();
    Fluttertoast.showToast(msg: 'Menu Delete Successfully.');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => ItemsScreen(model: widget.model)));
      },
      splashColor: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          height: 280,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Image.network(
                widget.model!.thumbnailUrl!,
                height: 210,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.model!.menuTitle!,
                    style: const TextStyle(
                        color: Colors.cyan, fontSize: 20, fontFamily: 'Train'),
                  ),
                  IconButton(
                    onPressed: () {
                      deleteMenus(widget.model!.menuID!);
                    },
                    icon: const Icon(Icons.delete_sweep),
                    color: Colors.pinkAccent,
                  ),
                ],
              ),
              // Text(
              //   widget.model!.menuInfo!,
              //   style: const TextStyle(
              //       color: Colors.grey, fontSize: 12, fontFamily: 'Train'),
              // ),
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
