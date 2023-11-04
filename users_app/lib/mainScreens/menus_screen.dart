import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:users_app/assistantMethods/assistant_methods.dart';
import 'package:users_app/models/menus.dart';
import 'package:users_app/models/sellers.dart';
import 'package:users_app/splashScreen.dart/splash_screen.dart';
import 'package:users_app/widgets/menus_design.dart';
import 'package:users_app/widgets/progress_bar.dart';
import 'package:users_app/widgets/text_widget_header.dart';

class MenusScreen extends StatefulWidget {
  final Sellers? model;
  const MenusScreen({super.key, this.model});

  @override
  State<MenusScreen> createState() => _MenusScreenState();
}

class _MenusScreenState extends State<MenusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        leading: IconButton(
          onPressed: () {
            clearCartNow(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (c) => const MySplashScreen()));
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'iFood',
          style: TextStyle(
              fontSize: 45, fontFamily: 'Signatra', color: Colors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: TextWidgetHeader(
              title: '${widget.model!.sellerName} Menus',
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('sellers')
                .doc(widget.model!.sellerUID)
                .collection('menus')
                .orderBy('publishedDate',
                    descending: true) //new item with render on the top
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
                        Menus model = Menus.fromJson(
                          snapshot.data!.docs[index].data()!
                              as Map<String, dynamic>,
                        );
                        return MenusDesignWidget(
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
