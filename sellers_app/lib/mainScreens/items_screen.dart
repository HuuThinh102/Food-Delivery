import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/models/items.dart';
import 'package:sellers_app/models/menus.dart';
import 'package:sellers_app/uploadScreens/items_upload_screen.dart';
import 'package:sellers_app/widgets/items_design.dart';
import 'package:sellers_app/widgets/my_drawer.dart';
import 'package:sellers_app/widgets/progress_bar.dart';
import 'package:sellers_app/widgets/text_widget_header.dart';

class ItemsScreen extends StatefulWidget {
  final Menus? model;
  const ItemsScreen({super.key, this.model});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: const MyDrawer(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
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
        ),
        title: Text(
          sharedPreferences!.getString('name')!,
          style: const TextStyle(
              fontSize: 30, fontFamily: 'Lobster', color: Colors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => ItemsUploadScreen(model: widget.model)),
              );
            },
            icon: const Icon(
              Icons.library_add,
              color: Colors.cyan,
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: TextWidgetHeader(
              // ignore: prefer_interpolation_to_compose_strings
              title: 'My ' + widget.model!.menuTitle.toString() + "'s Items",
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('sellers')
                .doc(sharedPreferences!.getString('uid'))
                .collection('menus')
                .doc(widget.model!.menuID)
                .collection('items')
                .orderBy('publishedDate', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    )
                  : SliverAlignedGrid.count(
                      itemBuilder: (context, index) {
                        Items model = Items.fromJson(
                          snapshot.data!.docs[index].data()!
                              as Map<String, dynamic>,
                        );
                        return ItemsDesignWidget(
                          model: model,
                          context: context,
                        );
                      },
                      itemCount: snapshot.data!.docs.length,
                      crossAxisCount: 1,
                    );
            },
          ),
        ],
      ),
    );
  }
}
