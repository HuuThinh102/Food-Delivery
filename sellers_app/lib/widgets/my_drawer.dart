import 'package:flutter/material.dart';
import 'package:sellers_app/authentication/auth_screen.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/mainScreens/earnings_screent.dart';
import 'package:sellers_app/mainScreens/history_screen.dart';
import 'package:sellers_app/mainScreens/home_screen.dart';
import 'package:sellers_app/mainScreens/new_orders_screen.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          //avatar circular
          Container(
            padding: const EdgeInsets.only(top: 25, bottom: 10),
            child: Column(
              children: [
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(80)),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: SizedBox(
                      height: 160,
                      width: 160,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            sharedPreferences!.getString('photoUrl')!),
                      ),
                    ),
                  ),
                ),
                // UserAccountsDrawerHeader(
                //   currentAccountPicture: CircleAvatar(
                //     backgroundImage:
                //         NetworkImage(sharedPreferences!.getString('photoUrl')!),
                //   ),
                //   accountName: Text(
                //     sharedPreferences!.getString('name')!,
                //     style: const TextStyle(fontSize: 24.0),
                //   ),
                //   accountEmail: Text(sharedPreferences!.getString('email')!),
                //   decoration: const BoxDecoration(
                //     color: Colors.black87,
                //   ),

                const SizedBox(height: 10),
                Text(
                  sharedPreferences!.getString('name')!,
                  style: const TextStyle(
                      color: Colors.black, fontSize: 20, fontFamily: 'Kiwi'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          //body
          Container(
            padding: const EdgeInsets.only(top: 1.0),
            child: Column(
              children: [
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.home,
                    color: Colors.black54,
                    size: 24,
                  ),
                  title: const Text(
                    'Home',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => const HomeScreen()));
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.monetization_on,
                    color: Colors.black54,
                  ),
                  title: const Text(
                    'My earning',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => const EarningsScreen()));
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.reorder,
                    color: Colors.black54,
                  ),
                  title: const Text(
                    'New order',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => const NewOrdersScreen()));
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.local_shipping,
                    color: Colors.black54,
                  ),
                  title: const Text(
                    'History - Orders',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => const HistoryScreen()));
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.exit_to_app,
                    color: Colors.black54,
                  ),
                  title: const Text(
                    'Sign out',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    firebaseAuth.signOut().then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => const AuthScreen()));
                    });
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
