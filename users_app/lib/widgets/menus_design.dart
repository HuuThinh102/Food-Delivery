import 'package:flutter/material.dart';
import 'package:users_app/mainScreens/items_screen.dart';
import 'package:users_app/models/menus.dart';

class MenusDesignWidget extends StatefulWidget {
  Menus? model;
  BuildContext? context;

  MenusDesignWidget({super.key, this.context, this.model});

  @override
  State<MenusDesignWidget> createState() => _MenusDesignWidgetState();
}

class _MenusDesignWidgetState extends State<MenusDesignWidget> {
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
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
              Image.network(
                widget.model!.thumbnailUrl!,
                height: 210,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 1),
              Text(
                widget.model!.menuTitle!,
                style: const TextStyle(
                    color: Colors.cyan, fontSize: 20, fontFamily: 'Train'),
              ),
              // Text(
              //   widget.model!.menuInfo!,
              //   style: const TextStyle(
              //       color: Colors.grey, fontSize: 12, fontFamily: 'Train'),
              // ),
              const SizedBox(height: 10),
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
