import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_app/features/authentication/model/register_modal.dart';
import 'package:todo_list_app/features/authentication/view/pages/login.dart';

class UserRegisterProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> registerUser(userRegisterModel userrg, BuildContext context) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: userrg.email!,
      password: userrg.password!,
    );

      // Store User Data in Firestore
      await _firestore.collection("Users").doc(userCredential.user!.uid).set({
        "name": userrg.name,
        "password": userrg.password,
        "email": userrg.email,
        "conformpassword": userrg.conformpassword,
        "uid": userCredential.user!.uid
      });
  print('Navigating to Login Page');
      // Navigate to Login Page
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration Successful", style: TextStyle(fontSize: 18))),
      );
    } on FirebaseAuthException catch (e) {
      _errorMessage = e.message;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Auth Error: ${e.message}", style: const TextStyle(fontSize: 18))),
      );
    }  finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
