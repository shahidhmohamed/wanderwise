import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../firebase_auth_implementation/firebase_auth_services.dart';
import '../../../global/common/toast.dart';

class UpdateUserProfile extends StatefulWidget {
  const UpdateUserProfile({Key? key}) : super(key: key);

  @override
  State<UpdateUserProfile> createState() => _UpdateUserProfileState();
}

class _UpdateUserProfileState extends State<UpdateUserProfile> {
  late TextEditingController _userNameController;
  late TextEditingController _emailController;
  File? _image;
  FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  String? _userId;
  String? _currentUserName;
  String? _currentEmail;

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController();
    _emailController = TextEditingController();

    // Fetch current user details (Name, Email) from Firebase Auth and Firestore
    _userId = FirebaseAuth.instance.currentUser?.uid;
    if (_userId != null) {
      _loadUserDetails();
    }
  }

  void _loadUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userNameController.text = user.displayName ?? '';
      _emailController.text = user.email ?? '';

      // Fetch additional user details from Firestore if needed
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userSnapshot.exists) {
        setState(() {
          _currentUserName = userSnapshot['name'];
          _currentEmail = userSnapshot['email'];
        });
      }
    }
  }

  // Update user profile details
  Future<void> _saveChanges() async {
    String newUserName = _userNameController.text;
    String newEmail = _emailController.text;

    if (newUserName.isEmpty || newEmail.isEmpty) {
      showToast(message: "Please enter both username and email.");
      return;
    }

    if (newEmail != _currentEmail) {
      await _firebaseAuthService.updateEmail(newEmail);
    }

    if (newUserName != _currentUserName) {
      await _firebaseAuthService.updateUserName(newUserName);
    }

    if (_image != null) {
      // Upload new profile picture
      String? imageUrl = await _firebaseAuthService.uploadProfilePicture(_userId!, _image!.path);
      if (imageUrl != null) {
        // Update Firestore with the new profile picture URL
        await FirebaseFirestore.instance.collection('users').doc(_userId).update({
          'profile_picture': imageUrl,
        });
      }
    }

    // Update Firestore user details (email and name)
    await _firebaseAuthService.updateUserProfile(_userId!, newUserName, newEmail);
    Navigator.pop(context);  // Go back after saving
  }

  // Pick an image for the profile picture
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color(0xFF1A1A2E),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : NetworkImage(
                        FirebaseAuth.instance.currentUser?.photoURL ??
                            'https://www.w3schools.com/w3images/avatar2.png') as ImageProvider,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Option to pick a new profile picture
              Center(
                child: TextButton(
                  onPressed: _pickImage,
                  child: const Text(
                    'Change Profile Picture',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Edit User Name',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: _userNameController,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    hintText: 'Enter User Name',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Edit Email',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter Email',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 36),
              Center(
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
