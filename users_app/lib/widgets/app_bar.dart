import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistantMethods/cart_item_counter.dart';
import 'package:users_app/mainScreens/cart_screen.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final PreferredSizeWidget? bottom;
  final String? sellerUID;
  const MyAppBar({super.key, this.bottom, this.sellerUID});

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
          Navigator.pop(context);
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
      actions: [
        Stack(
          children: [
            IconButton(
              onPressed: () {
                //send user to cart screen
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) =>
                            CartScreen(sellerUID: widget.sellerUID)));
              },
              icon: const Icon(
                Icons.shopping_cart,
                color: Colors.cyan,
              ),
            ),
            Positioned(
              child: Stack(
                children: [
                  const Icon(
                    Icons.brightness_1,
                    size: 20.0,
                    color: Colors.green,
                  ),
                  Positioned(
                    top: 3,
                    right: 4,
                    child: Center(
                      child: Consumer<CartItemCounter>(
                        builder: (context, counter, c) {
                          return Text(counter.count.toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
