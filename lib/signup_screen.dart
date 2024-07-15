import 'dart:io';
import 'package:chatapp/auth_provider.dart';
import 'package:chatapp/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  File? _image;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<String> _uploadImage(File image) async {
    final ref = _storage
        .ref()
        .child('user_images')
        .child('${_auth.currentUser!.uid}.jpg');
    await ref.putFile(image);
    return await ref.getDownloadURL();
  }

  Future<void> _signUp() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      final imageUrl = await _uploadImage(_image!);
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': _nameController.text,
        'email': _emailController.text,
        'imageUrl': imageUrl
      });

      Fluttertoast.showToast(msg: "Sign Up Success");

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Criar Conta"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(),
                  ),
                  child: _image == null
                      ? Center(
                          child: Icon(
                            Icons.camera_alt_rounded,
                            size: 50,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.file(_image!, fit: BoxFit.cover),
                        ),
                ),
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "Nome",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Digite o seu nome";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Digite o seu E-mail";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: "Senha",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Digite sua Senha";
                  }
                  return null;
                },
              ),
              SizedBox(height: 50),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                height: 55,
                child: ElevatedButton(
                  onPressed: _signUp,
                  child: Text("Criar Conta"),
                ),
              ),
              SizedBox(height: 20),
              Text("OU"),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text(
                  "Entrar",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
