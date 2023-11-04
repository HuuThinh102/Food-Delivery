import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/models/menus.dart';
import 'package:sellers_app/widgets/error_dialog.dart';
import 'package:sellers_app/widgets/progress_bar.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;

class ItemsUploadScreen extends StatefulWidget {
  final Menus? model;
  const ItemsUploadScreen({super.key, this.model});

  @override
  State<ItemsUploadScreen> createState() => _ItemsUploadScreenState();
}

class _ItemsUploadScreenState extends State<ItemsUploadScreen> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  bool uploading = false;
  String uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();

  //TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleInfoController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  defaultScreen() {
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
        title: const Text(
          'Add New Item',
          style: TextStyle(
              fontSize: 30, fontFamily: 'Lobster', color: Colors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Container(
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.shop_2,
                color: Colors.white,
                size: 200,
              ),
              ElevatedButton(
                onPressed: () {
                  takeImage(context);
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.cyan),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                child: const Text(
                  'Add New Item',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
      context: mContext,
      builder: (context) {
        return SimpleDialog(
          title: const Text(
            'Menu Image',
            style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
          ),
          children: [
            SimpleDialogOption(
              onPressed: captureImageWithCamera,
              child: const Text(
                'Capture with Camera',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            SimpleDialogOption(
              onPressed: selectFromGallery,
              child: const Text(
                'Select from Gallery',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  captureImageWithCamera() async {
    Navigator.pop(context);

    imageXFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }

  selectFromGallery() async {
    Navigator.pop(context);

    imageXFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 720,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }

  itemUploadFormScreen() {
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
        title: const Text(
          'Uploading New Item',
          style: TextStyle(
              fontSize: 24, fontFamily: 'Lobster', color: Colors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              clearMenuUploadForm();
            }),
        // actions: [
        //   IconButton(
        //     onPressed: uploading ? null : () => validateUploadForm(),
        //     icon: const Icon(
        //       Icons.add,
        //       size: 28,
        //     ),
        //   ),
        // ],
      ),
      body: ListView(
        children: [
          uploading == true ? linearProgress() : const Text(''),
          SizedBox(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(
                        File(imageXFile!.path),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // const Divider(
          //   color: Colors.amber,
          //   thickness: 2,
          // ),
          // ListTile(
          //   leading: const Icon(
          //     Icons.perm_device_information,
          //     color: Colors.cyan,
          //   ),
          //   title: SizedBox(
          //     width: 250,
          //     child: TextField(
          //       style: const TextStyle(color: Colors.black),
          //       controller: shortInfoController,
          //       decoration: const InputDecoration(
          //         hintText: 'Info',
          //         hintStyle: TextStyle(color: Colors.grey),
          //         border: InputBorder.none,
          //       ),
          //     ),
          //   ),
          // ),
          const Divider(
            color: Colors.amber,
            thickness: 2,
          ),
          ListTile(
            leading: const Icon(
              Icons.title,
              color: Colors.cyan,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: titleInfoController,
                decoration: const InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.amber,
            thickness: 2,
          ),
          ListTile(
            leading: const Icon(
              Icons.description,
              color: Colors.cyan,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Description',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.amber,
            thickness: 2,
          ),
          ListTile(
            leading: const Icon(
              Icons.price_change_outlined,
              color: Colors.cyan,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
                controller: priceController,
                decoration: const InputDecoration(
                  hintText: 'Price',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.amber,
            thickness: 2,
          ),
          UnconstrainedBox(
            child: Container(
              margin: const EdgeInsets.only(top: 15),
              height: 50,
              width: 100,
              child: ElevatedButton(
                onPressed: uploading ? null : () => validateUploadForm(),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.cyan),
                ),
                child: const Text(
                  'Add',
                  style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'Bebas',
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  clearMenuUploadForm() {
    setState(() {
      //shortInfoController.clear();
      titleInfoController.clear();
      priceController.clear();
      descriptionController.clear();
      imageXFile = null;
    });
  }

  validateUploadForm() async {
    if (imageXFile != null) {
      if ( //shortInfoController.text.isNotEmpty &&
          titleInfoController.text.isNotEmpty &&
              descriptionController.text.isNotEmpty &&
              priceController.text.isNotEmpty) {
        setState(() {
          uploading = true;
        });

        //upload image
        String downloadUrl = await uploadImage(File(imageXFile!.path));
        //save info to firebase
        saveInfo(downloadUrl);
      } else {
        showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
                message: 'Please write title and info for Menu.');
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(message: 'Please pick an image for Menu.');
        },
      );
    }
  }

  uploadImage(mImageFile) async {
    storageRef.Reference reference =
        storageRef.FirebaseStorage.instance.ref().child('items');

    storageRef.UploadTask uploadTask =
        reference.child('$uniqueIdName.jpg').putFile(mImageFile);
    storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }

  saveInfo(String downloadUrl) {
    final ref = FirebaseFirestore.instance
        .collection('sellers')
        .doc(sharedPreferences!.getString('uid'))
        .collection('menus')
        .doc(widget.model!.menuID)
        .collection('items');

    ref.doc(uniqueIdName).set({
      'itemID': uniqueIdName,
      'menuID': widget.model!.menuID,
      'sellerUID': sharedPreferences!.getString('uid'),
      'sellerName': sharedPreferences!.getString('name'),
      //'shortInfo': shortInfoController.text.toString(),
      'longDescription': descriptionController.text.toString(),
      'price': int.parse(priceController.text),
      'title': titleInfoController.text.toString(),
      'publishedDate': DateTime.now(),
      'status': 'available',
      'thumbnailUrl': downloadUrl,
    }).then((value) {
      final itemsRef = FirebaseFirestore.instance.collection('items');

      itemsRef.doc(uniqueIdName).set({
        'itemID': uniqueIdName,
        'menuID': widget.model!.menuID,
        'sellerUID': sharedPreferences!.getString('uid'),
        'sellerName': sharedPreferences!.getString('name'),
        //'shortInfo': shortInfoController.text.toString(),
        'longDescription': descriptionController.text.toString(),
        'price': int.parse(priceController.text),
        'title': titleInfoController.text.toString(),
        'publishedDate': DateTime.now(),
        'status': 'available',
        'thumbnailUrl': downloadUrl,
      });
    }).then((value) {
      clearMenuUploadForm();

      setState(() {
        uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
        uploading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return imageXFile == null ? defaultScreen() : itemUploadFormScreen();
  }
}
