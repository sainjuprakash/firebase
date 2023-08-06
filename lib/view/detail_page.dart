import 'package:firebase/auth_provider/crud_provider.dart';
import 'package:firebase/common/snack_show.dart';
import 'package:firebase/services/crud_service.dart';
import 'package:firebase/view/user_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../model/post.dart';

class DetailPage extends StatelessWidget {
  final Post post;
  final types.User user;
  DetailPage(this.post, this.user);
  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(9.0),
      child: Consumer(builder: (context, ref, child) {
        final allPost = ref.watch(postStream);
        return SafeArea(
          child: Column(
            children: [
              Image.network(post.imageUrl),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: commentController,
                onFieldSubmitted: (val) async {
                  if (val.isEmpty) {
                    SnackShow.showFailure(context, 'comment cant empty');
                  } else {
                    print(val);
                    await ref.read(crudProvider.notifier).addComment(
                        comment: Comment(
                            username: user.firstName!,
                            comment: val.trim(),
                            image: user.imageUrl!),
                        postId: post.postId);
                    print(user.firstName);
                  }
                  commentController.clear();
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Add comment',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('All Comments',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      fontSize: 15)),
              Expanded(
                  child: allPost.when(
                      data: (data) {
                        final thisPost = data.firstWhere(
                            (element) => element.postId == post.postId);
                        return ListView.builder(
                            itemCount: thisPost.comments.length,
                            itemBuilder: (context, index) {
                              final comment = thisPost.comments[index];
                              return ListTile(
                                leading: InkWell(
                                  onTap: (){

                                  },
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(comment.image),
                                  ),
                                ),
                                title: Text(comment.username),
                                subtitle: Text(comment.comment),
                              );
                            });
                      },
                      error: (err, stack) => Text('$err'),
                      loading: () => CircularProgressIndicator()))
            ],
          ),
        );
      }),
    ));
  }
}
