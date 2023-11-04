import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/widgets/error_dialog.dart';
import 'package:sellers_app/widgets/progress_bar.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;

class MenusUploadScreen extends StatefulWidget {
  const MenusUploadScreen({super.key});

  @override
  State<MenusUploadScreen> createState() => _MenusUploadScreenState();
}

class _MenusUploadScreenState extends State<MenusUploadScreen> {
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  bool uploading = false;
  String uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();

  //TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleInfoController = TextEditingController();

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
          'Add New Menu',
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
                  'Add New Menu',
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

  menuUploadFormScreen() {
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
          'Uploading New Menu',
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
          // const ListTile(
          //   leading: Icon(
          //     Icons.perm_device_information,
          //     color: Colors.cyan,
          //   ),
          //   title: SizedBox(
          //     width: 250,
          //     child: TextField(
          //       style: TextStyle(color: Colors.black),
          //       //controller: shortInfoController,
          //       decoration: InputDecoration(
          //         hintText: 'Menu info',
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
                  hintText: 'Menu title',
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
      imageXFile = null;
    });
  }

  validateUploadForm() async {
    if (imageXFile != null) {
      if ( //shortInfoController.text.isNotEmpty &&
          titleInfoController.text.isNotEmpty) {
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
        storageRef.FirebaseStorage.instance.ref().child('menus');

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
        .collection('menus');
    ref.doc(uniqueIdName).set({
      'menuID': uniqueIdName,
      'sellerUID': sharedPreferences!.getString('uid'),
      //'menuInfo': shortInfoController.text.toString(),
      'menuTitle': titleInfoController.text.toString(),
      'publishedDate': DateTime.now(),
      'status': 'available',
      'thumbnailUrl': downloadUrl,
    });

    clearMenuUploadForm();

    setState(() {
      uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
      uploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return imageXFile == null ? defaultScreen() : menuUploadFormScreen();
  }
}
