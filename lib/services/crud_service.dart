import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase/model/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final postStream = StreamProvider((ref) => CrudService.getPost());

class CrudService {
  static final postDb = FirebaseFirestore.instance
      .collection('posts'); //database ma folder banako

  static Stream<List<Post>> getPost() {
    //users haru dekhauna
    return postDb.snapshots().map((event) {
      //yah bata firebase ko  document as a list pass garxa
      return event.docs.map((e) {
        //e bata main data auxa list ko form ma
        final json = e.data();
        print("getPost json");
        print(json);
        return Post(
            title: json['title'],
            detail: json['detail'],
            postId: e.id,
            userId: json['userID'],
            imageId: json['imageId'],
            imageUrl: json['imageUrl'],
            like: Like.fromJson(json['like']),
            comments: (json['comments'] as List)
                .map((e) => Comment.fromJson(e))
                .toList());
      }).toList();
    });
  }

  static Future<Either<String, bool>> addPost(
      {required String title,
      required String detail,
      required String userID,
      required XFile image}) async {
    try {
      final ref =
          FirebaseStorage.instance.ref().child('postImage/${image.name}');
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();

      final response = await postDb.add({
        'title': title,
        'detail': detail,
        'userID': userID,
        'imageUrl': url,
        'imageId': image.name,
        'like': {'likes': 0, 'usernames': []},
        'comments': [],
      });

      return right(true);
    } on FirebaseException catch (err) {
      return Left(err.message.toString());
    }
  }

  static Future<Either<String, bool>> deletePost(
      {required String postId, required String imageId}) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('postImage/$imageId');
      await ref.delete();
      final response = await postDb.doc(postId).delete();

      return right(true);
    } on FirebaseException catch (err) {
      return Left(err.message.toString());
    }
  }

  static Future<Either<String, bool>> updatePost(
      {required String title,
      required String detail,
      required String postId,
      XFile? image,
      String? imageId}) async {
    try {
      if (image == null) {
        await postDb.doc(postId).update({'title': title, 'detail': detail});
      } else {
        final ref = FirebaseStorage.instance.ref().child('postImage/$imageId');
        await ref.delete();
        final ref1 =
            FirebaseStorage.instance.ref().child('postImage/${image.name}');
        await ref1.putFile(File(image.path));
        final url = await ref1.getDownloadURL();
        final response = await postDb.doc(postId).update({
          'title': title,
          'detail': detail,
          'imageUrl': url,
          'imageId': image.name,
        });
      }

      return right(true);
    } on FirebaseException catch (err) {
      return Left(err.message.toString());
    }
  }

  static Future<Either<String, bool>> likePost(
      {required String username,
      required String postId,
      required int like}) async {
    try {
      await postDb.doc(postId).update({
        'like': {
          'likes': like + 1,
          'usernames': FieldValue.arrayUnion(
              [username]) //purano username ko array ma naya add garna
        },
      });
      return right(true);
    } on FirebaseException catch (err) {
      return Left(err.message.toString());
    }
  }

  static Future<Either<String, bool>> addComment({
    required Comment comment,
    required String postId,
  }) async {
    try {
      await postDb.doc(postId).update({
        'comments': FieldValue.arrayUnion(
            [comment.toMap()]) //purano username ko array ma naya add garna
      });
      return right(true);
    } on FirebaseException catch (err) {
      return Left(err.message.toString());
    }
  }
}
