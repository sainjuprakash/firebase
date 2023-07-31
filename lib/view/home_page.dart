import 'package:firebase/auth_provider/auth_provider.dart';
import 'package:firebase/services/crud_service.dart';
import 'package:firebase/view/create_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../services/auth_service.dart';

final usersStream =
    StreamProvider.autoDispose((ref) => FirebaseChatCore.instance.users());

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    // final authData=FirebaseAuth.instance.currentUser;
    // print(authData!.email);
    final userData = ref.watch(usersStream);
    final singleData = ref.watch(singleStream);
    return SafeArea(
      child: Scaffold(
          drawer: Drawer(
              child: singleData.when(
                  data: (data) {
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
                height: 170,
                //color: Colors.white,
                child: userData.when(
                    data: (data) {
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            // info printing for debug purpose
                            print("User info of $index: ${data[index].id}");
                            /*return PostWidget(
                              postData: postList[index],
                              onMenuTa:() {
                                //show Menu
                              },
                              onDeteleTap:
                              () {
                                deletePost(imageId: postList[index].imageId, postId: POstList[index].postId)
                              }

                            );*/
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 5),
                                  child: InkWell(
                                    onTap: () {
                                      print(data[index].id);

                            },
                                    child: CircleAvatar(
                                      radius: 40,
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
              // Expanded(child: column(error: (err, stack) => Center(child: Text('$err')),
              //   children: [
              //     ListView.builder(
              //         scrollDirectionz:
              //         itemBuilder: itemBuilder)
              //   ],
              // )),
            ],
          )),
    );
  }
}
