import 'package:firebase/auth_provider/crud_provider.dart';
import 'package:firebase/common/snack_show.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../model/post.dart';

class DetailPage extends StatelessWidget {
  final Post post;
  final types.User user;
  DetailPage(this.post, this.user);
  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: [
      Image.network(post.imageUrl),
      Padding(
        padding: const EdgeInsets.all(9.0),
        child: Consumer(builder: (context, ref, child) {
          return Column(
            children: [
              TextFormField(
                controller: commentController,
                onFieldSubmitted: (val) {
                  if (val.isEmpty) {
                    SnackShow.showFailure(context, 'comment cant empty');
                  } else {
                    print(val);
                    ref.read(crudProvider.notifier).addComment(
                        comment: Comment(
                            username: user.firstName!,
                            comment: val.trim(),
                            image: user.imageUrl!),
                        postId: post.postId);
                    print(user.firstName);
                  }
                  commentController.clear();
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Add comment',
                ),
              ),
            ],
          );
        }),
      ),
    ]));
  }
}
