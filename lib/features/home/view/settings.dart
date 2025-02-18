import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_app/features/authentication/view/widgets/custom_text.dart';

class Settingsss extends StatefulWidget {
  @override
  State<Settingsss> createState() => _SettingsssState();
}

class _SettingsssState extends State<Settingsss> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _name;
  String? _email;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserProfileview(); // Call the method to fetch user data
  }

  Future<void> _fetchUserProfileview() async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userData =
            await _firestore.collection("Users").doc(user.uid).get();

        if (userData.exists) {
          setState(() {
            _name = userData['name'];
            _email = userData['email'];
          });
        } else {
          print("User does not exist");
        }
      } else {
        print("No user is currently signed in");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: CustomText(
            text: 'Settings',
            size: 24,
            color: Colors.black,
            weight: FontWeight.bold,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            child: Icon(
                              Icons.person,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _name ?? '',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                _email ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Icon(Icons.edit)
                        ],
                      ),
                      SizedBox(height: 24),
                      ListTile(
                        leading: const Icon(Icons.notifications),
                        title: const Text('Notifications'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.brightness_low_rounded),
                        title: const Text('General'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.account_circle),
                        title: const Text('Account'),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.info),
                        title: const Text('About'),
                        onTap: () {},
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
