import 'package:firebase/auth_provider/auth_provider.dart';
import 'package:firebase/auth_provider/crud_provider.dart';
import 'package:firebase/common/snack_show.dart';
import 'package:firebase/services/crud_service.dart';
import 'package:firebase/view/create_post.dart';
import 'package:firebase/view/detail_page.dart';
import 'package:firebase/view/update_page.dart';
import 'package:firebase/view/user_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../services/auth_service.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

final usersStream =
    StreamProvider.autoDispose((ref) => FirebaseChatCore.instance.users());

class HomePage extends ConsumerWidget {
  // const HomePage({Key? key}) : super(key: key);
  late types.User user;

  @override
  Widget build(BuildContext context, ref) {
    // final authData=FirebaseAuth.instance.currentUser;
    // print(authData!.email);
    final authData = FirebaseAuth.instance.currentUser;
    final userData = ref.watch(usersStream);
    final singleData = ref.watch(singleStream);
    final postData = ref.watch(postStream);
    return SafeArea(
      child: Scaffold(
          drawer: Drawer(
              child: singleData.when(
                  data: (data) {
                    user = data;
                    return ListView(
                      children: [
                        const Center(
                            child: Text(
                          'User Details',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        )),
                        DrawerHeader(
                            child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(data.imageUrl!),
                        )),
                        ListTile(
                          onTap: () {
                            // Navigator.of(context)
                            //     .pop(); //tap garda drawer hatauna ko lage
                            // Get.to(() => CreatePost());
                          },
                          leading: const Icon(Icons.verified_user),
                          title: Text(data.firstName!),
                        ),
                        ListTile(
                          onTap: () {
                            // Navigator.of(context)
                            //     .pop(); //tap garda drawer hatauna ko lage
                            // Get.to(() => CreatePost());
                          },
                          leading: Icon(Icons.email),
                          title: Text(data.metadata!['email']),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.of(context)
                                .pop(); //tap garda drawer hatauna ko lage
                            Get.to(() => CreatePost());
                          },
                          leading: Icon(Icons.add_a_photo_outlined),
                          title: Text('Add Post'),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.of(context).pop();
                            ref.read(authProvider.notifier).userLogOut();
                          },
                          leading: Icon(Icons.exit_to_app),
                          title: const Text(
                            'LogOut',
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    );
                  },
                  error: (err, stack) => Text('$err'),
                  loading: () => CircularProgressIndicator())),
          appBar: AppBar(
            backgroundColor: Colors.grey,
            title: const Text('social app'),
          ),
          body: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 220),
                child: Text(
                  'Available Friends:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                height: 100,
                //color: Colors.white,
                child: userData.when(
                    data: (data) {
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            // info printing for debug purpose
                            print("User info of $index: ${data[index].id}");
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 5),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(()=>UserPage(data[index]));
                                      print(data[index].id);
                                    },
                                    child: CircleAvatar(
                                      radius: 35,
                                      backgroundImage:
                                          NetworkImage(data[index].imageUrl!),
                                    ),
                                  ),
                                ),
                                Text(
                                  data[index].firstName!,
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            );
                          });
                    },
                    error: (err, stack) => Center(child: Text('$err')),
                    loading: () => const CircularProgressIndicator()),
                // color: Colors.red,
              ),
              Container(
                height: 1,
                color: Colors.grey,
              ),
              SizedBox(height: 5),
              Expanded(
                child: postData.when(
                  data: (data) {
                    print("got data");
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        // print(data[index]);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Title:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19),
                                ),
                                Expanded(child: Text(data[index].title)),
                                if (authData?.uid == data[index].userId)
                                  IconButton(
                                      onPressed: () {
                                        Get.defaultDialog(
                                            title: "Update",
                                            content: Text('Edit Post'),
                                            actions: [
                                              IconButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    Get.defaultDialog(
                                                        title: 'Are you sure?',
                                                        content: Text(
                                                            'Delete the post'),
                                                        actions: [
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                ref.read(crudProvider.notifier).deletePost(
                                                                    postId: data[
                                                                            index]
                                                                        .postId,
                                                                    imageId: data[
                                                                            index]
                                                                        .imageId);
                                                              },
                                                              child:
                                                                  Text('Yes')),
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child:
                                                                  Text('No')),
                                                        ]);
                                                  },
                                                  icon: Icon(Icons.delete)),
                                              IconButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    Get.to(() => UpdatePage(
                                                        data[index]));
                                                  },
                                                  icon: Icon(Icons.edit)),
                                            ]);
                                      },
                                      icon: Icon(Icons.more_horiz_outlined))
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              onTap: (){
                                Get.to(()=> DetailPage(data[index],user));
                              },
                              child: Container(
                                  width: double.infinity,
                                  child: Image.network(data[index].imageUrl)),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'About:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Text(data[index].detail),
                                ),
                                Row(
                                  children: [
                                    if (authData?.uid != data[index].userId)
                                      IconButton(
                                        onPressed: () {
                                          if (data[index]
                                              .like
                                              .username
                                              .contains(user.firstName)) {
                                            SnackShow.showFailure(context,
                                                'Already liked the post');
                                          } else {
                                            ref
                                                .read(crudProvider.notifier)
                                                .likePost(
                                                    username: user.firstName!,
                                                    postId: data[index].postId,
                                                    like:
                                                        data[index].like.likes);
                                          }
                                        },
                                        icon: Icon(
                                          Icons.thumb_up_alt_sharp,
                                        ),
                                      ),
                                    if (data[index].like.likes >= 0)
                                      Text(data[index].like.likes.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 19)),
                                  ],
                                )
                              ],
                            ),
                          ],
                        );
                      },
                      itemCount: data.length,
                    );
                  },
                  error: (err, stack) {
                    print("got error : $err \n $stack");
                    return Center(child: Text('$err'));
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
