import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/mainScreens/home_screen.dart';
import 'package:users_app/widgets/custom_text_field.dart';
import 'package:users_app/widgets/error_dialog.dart';
import 'package:users_app/widgets/loading_dialog.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  String sellerImageUrl = '';

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageXFile;
    });
  }

  Future<void> formValidation() async {
    if (imageXFile == null) {
      showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(message: 'Please select an image.');
        },
      );
    } else {
      if (passwordController.text == confirmPasswordController.text) {
        if (confirmPasswordController.text.isNotEmpty &&
            emailController.text.isNotEmpty &&
            nameController.text.isNotEmpty) {
          showDialog(
            context: context,
            builder: (c) {
              return LoadingDialog(message: 'Registering Account');
            },
          );
          String fileName = DateTime.now().millisecondsSinceEpoch.toString();
          fStorage.Reference reference = fStorage.FirebaseStorage.instance
              .ref()
              .child('users')
              .child(fileName);
          fStorage.UploadTask uploadTask =
              reference.putFile(File(imageXFile!.path));
          fStorage.TaskSnapshot taskSnapshot =
              await uploadTask.whenComplete(() {});
          await taskSnapshot.ref.getDownloadURL().then((url) {
            sellerImageUrl = url;
            //save info to firestore
            authenticateSellerAndSignUp();
          });
        } else {
          showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                  message:
                      'Please write the complete required info for Registration.');
            },
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(message: 'Password do not match.');
          },
        );
      }
    }
  }

  Future saveDataToFirestore(User currentUser) async {
    FirebaseFirestore.instance.collection('users').doc(currentUser.uid).set({
      'uid': currentUser.uid,
      'email': currentUser.email,
      'name': nameController.text.trim(),
      'photoUrl': sellerImageUrl,
      'status': 'approved',
      'userCart': ['garbageValue'],
    });

    //save data locally
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString('uid', currentUser.uid);
    await sharedPreferences!.setString('email', currentUser.email.toString());
    await sharedPreferences!.setString('name', nameController.text.trim());
    await sharedPreferences!.setString('photoUrl', sellerImageUrl);
    await sharedPreferences!.setStringList('userCart', ['garbageValue']);
  }

  void authenticateSellerAndSignUp() async {
    User? currentUser;

    await firebaseAuth
        .createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(message: error.message.toString());
        },
      );
    });

    if (currentUser != null) {
      saveDataToFirestore(currentUser!).then((value) {
        Navigator.pop(context);
        //send user to homepage
        Route newRoute = MaterialPageRoute(builder: (c) => const HomeScreen());
        Navigator.pushReplacement(context, newRoute);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              _getImage();
            },
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: MediaQuery.of(context).size.width * 0.2,
              backgroundImage:
                  imageXFile == null ? null : FileImage(File(imageXFile!.path)),
              child: imageXFile == null
                  ? Icon(
                      Icons.add_photo_alternate,
                      size: MediaQuery.of(context).size.width * 0.2,
                      color: Colors.grey,
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 10),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  data: Icons.person,
                  controller: nameController,
                  hintText: 'Name',
                  isObsecre: false,
                ),
                CustomTextField(
                  data: Icons.email,
                  controller: emailController,
                  hintText: 'Email',
                  isObsecre: false,
                ),
                CustomTextField(
                  data: Icons.lock,
                  controller: passwordController,
                  hintText: 'Password',
                  isObsecre: true,
                ),
                CustomTextField(
                  data: Icons.lock,
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  isObsecre: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              formValidation();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 29, 124, 72),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
            ),
            child: const Text(
              'Sign Up',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
