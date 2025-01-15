// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> registerUser(String name, String email, String password) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
      
      await createUser(credential.user!.uid, name, email);
      return credential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> signInUser(String name, String email, String password) async {
    try {
      UserCredential credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      final id = credential.user!.uid;
      print(id);
      print(name);
      
      await db.collection('users').doc(id).get()
        .then(
          (DocumentSnapshot doc) {
            final data = doc.data() as Map<String, dynamic>;
            print(data);
            print(data['name']);
            if(data['name'] != name){
              throw Exception('User name does not match');
            }
          },
          onError: (e) => print("Error getting document: $e"),
        );
      
      return credential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createUser(String uid, String user, String email) async {
    await db.collection("users").doc(uid).set({
      'name': user,
      'mail': email,
      'wilaya': '',
      'phone': '',
    });
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = 
          await auth.signInWithCredential(credential);
      
      final User? user = userCredential.user;
      
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        await createUser(
          user!.uid,
          user.displayName ?? 'User',
          user.email ?? '',
        );
      }

      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkUserExists(String uid) async {
    try {
    
      DocumentSnapshot doc = await db.collection('users').doc(uid).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }
}