import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';



final singleStream= StreamProvider.autoDispose((ref) =>AuthService.getSingleUser());
class AuthService {
  static final auth = FirebaseAuth.instance;
  static final userDb=FirebaseFirestore.instance.collection('users');

  static Future<Either<String, bool>> userLogin(
      {required String email, required String password}) async {
    try {
      final response = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return right(true);
    } on FirebaseAuthException catch (err) {
      return Left(err.message.toString());
     }
      // on FirebaseException catch (err) {
    //   return Left(err.message.toString());
    // }
  }

  static Future<Either<String, bool>> userRegister(
      {required String email,
      required String password,
      required String username,
      required XFile image}) async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      final ref = FirebaseStorage.instance.ref().child('userImage/${image.name}');
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();

      final response = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await FirebaseChatCore.instance.createUserInFirestore(
        types.User(
            firstName: username,
            id: response.user!.uid, // UID from Firebase Authentication
            imageUrl: url,
            metadata: {
              'email': email,
              'token': token,
            }),
      );

      return right(true);
    } on FirebaseAuthException catch (err) {
      return Left(err.message.toString());
    } on FirebaseException catch (err) {
      return Left(err.message.toString());
    }
  }


  static Future<Either<String, bool>> userLogOut() async {
    try {
      final response = await auth.signOut();
      return right(true);
    } on FirebaseAuthException catch (err) {
      return Left(err.message.toString());
    }
  }

  static Stream<types.User> getSingleUser(){
    return userDb.doc(auth.currentUser!.uid).snapshots().map((event){
final json= event.data() as Map<String,dynamic>;
return types.User(
  id: event.id,
  firstName: json['firstName'],
  imageUrl: json['imageUrl'],
  metadata: {
    'email': json['metadata']['email'],
    'token':json['metadata']['token'],
  }

);
    });
  }
}
