import 'dart:io';
import 'package:firebase/auth_provider/auth_provider.dart';
import 'package:firebase/auth_provider/common_provider.dart';
import 'package:firebase/auth_provider/crud_provider.dart';
import 'package:firebase/common/snack_show.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CreatePost extends ConsumerWidget {
  final titleController = TextEditingController();
  final detailController = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, ref) {
    ref.listen(crudProvider, (previous, next) {
      // print('previous');
      // print(previous);
      // print(next);
      if (next.isError) {
        SnackShow.showFailure(context, next.errText);
      } else if (next.isSuccess) {
        SnackShow.showSuccess(context, 'post created successfully');
        Get.back();
      }
    });
    final crud = ref.watch(crudProvider);
    final image = ref.watch(imageProvider);

    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: titleController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'please provide title';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Title'),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: detailController,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'please provide details';
                    }
                    return null;
                  },
                  //textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Detail'),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    ref.read(imageProvider.notifier).pickImage(false);
                  },
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: image == null
                        ? const Center(
                            child: Text('Select image',
                                style: TextStyle(color: Colors.grey)))
                        : Image.file(File(image.path)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 7)),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    _form.currentState!.save(); //form validation
                    if (_form.currentState!.validate()) {
                      if (image == null) {
                        SnackShow.showFailure(context, 'No image selected');
                      } else {
                        ref.read(crudProvider.notifier).addPost(
                            title: titleController.text.trim(),
                            detail: detailController.text.trim(),
                            userID: FirebaseAuth.instance.currentUser!.uid,
                            image: image);
                      }
                    }
                  },
                  child: crud.isLoad
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: Colors.white,
                        ))
                      : Text('Add post'),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
