import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../global/common/toast.dart';

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Update user's email in Firebase Auth
  Future<void> updateEmail(String newEmail) async {
    try {
      await _auth.currentUser?.updateEmail(newEmail);
      showToast(message: 'Email updated successfully.');
    } on FirebaseAuthException catch (e) {
      showToast(message: 'Error updating email: ${e.message}');
    }
  }

  // Update user's display name in Firebase Auth
  Future<void> updateUserName(String newUserName) async {
    try {
      await _auth.currentUser?.updateDisplayName(newUserName);
      showToast(message: 'Username updated successfully.');
    } on FirebaseAuthException catch (e) {
      showToast(message: 'Error updating username: ${e.message}');
    }
  }

  // Update user details in Firestore (profile name, etc.)
  Future<void> updateUserProfile(String userId, String name, String email) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'name': name,
        'email': email,
      });
      showToast(message: 'Profile updated successfully.');
    } catch (e) {
      showToast(message: 'Error updating profile: ${e.toString()}');
    }
  }

  // Upload profile picture to Firebase Storage
  Future<String?> uploadProfilePicture(String userId, String imagePath) async {
    try {
      // Create a reference to the Firebase Storage path
      var storageRef = FirebaseStorage.instance.ref().child('profile_pictures/$userId.jpg');

      // Upload the image to Firebase Storage
      var uploadTask = storageRef.putFile(File(imagePath));
      var snapshot = await uploadTask.whenComplete(() => {});

      // Get the URL of the uploaded image
      var downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      showToast(message: 'Error uploading profile picture: ${e.toString()}');
      return null;
    }

  }

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(message: 'The email address is already in use.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(message: 'Invalid email or password.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }
    }
    return null;
  }
}
