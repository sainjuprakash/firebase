import 'dart:io';
import 'package:firebase/auth_provider/common_provider.dart';
import 'package:firebase/auth_provider/crud_provider.dart';
import 'package:firebase/common/snack_show.dart';
import 'package:firebase/model/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class UpdatePage extends ConsumerStatefulWidget {
  final Post post;
  UpdatePage(this.post);
  @override
  ConsumerState<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends ConsumerState<UpdatePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    titleController.text = widget.post.title;
    detailController.text = widget.post.detail;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(crudProvider, (previous, next) {
      // print('previous');
      // print(previous);
      // print(next);
      if (next.isError) {
        SnackShow.showFailure(context, next.errText);
      } else if (next.isSuccess) {
        SnackShow.showSuccess(context, 'Post updated successfully');
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
                        ? Image.network(widget.post.imageUrl)
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
                        ref.watch(crudProvider.notifier).updatePost(
                            title: titleController.text.trim(),
                            detail: detailController.text.trim(),
                            postId: widget.post.postId);
                      } else {
                        ref.watch(crudProvider.notifier).updatePost(
                            title: titleController.text.trim(),
                            detail: detailController.text.trim(),
                            postId: widget.post.postId,
                            image: image,
                            imageId: widget.post.imageId);
                      }
                    }
                  },
                  child: crud.isLoad
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: Colors.white,
                        ))
                      : Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
