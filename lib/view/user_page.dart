import 'package:firebase/auth_provider/room_provider.dart';
import 'package:firebase/services/crud_service.dart';
import 'package:firebase/view/chat_page.dart';
import 'package:firebase/view/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
class UserPage extends ConsumerWidget {
final types.User _user;


UserPage(this._user);


  @override
  Widget build(BuildContext context,ref) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(_user.imageUrl!),
                        radius: 40,
                      ),
                      SizedBox(width: 10,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text(_user.firstName!,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                        Text(_user.metadata!['email'],style: TextStyle(fontWeight: FontWeight.bold),),
                        ElevatedButton(onPressed: ()async{
                          final response= await ref.watch(roomProvider).createRoom(_user);
                          if (response!= null){
                            //Get.to(()=> ChatPage(response, _user));
                          }
                        }, child: Text('Start Chat')),
                      ],),
                    ],
                  ),

                  SizedBox(height: 15,),
                  Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 15,),
                  Expanded(child: Consumer(builder: (context,ref,child){
                    final allPost=ref.watch(postStream);
                    return allPost.when(
                        data: (data){
                          final userPost= data.where((element) => element.userId==_user.id).toList();
                          return GridView.builder(
                            itemCount: userPost.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                childAspectRatio: 1,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8
                              ),
                              itemBuilder: (context,index){
                              return InkWell(
                                onTap: (){
                                  Get.to(()=> DetailPage(userPost[index], _user));
                                },
                                  child: Image.network(userPost[index].imageUrl));
                              }
                          );
                        },
                        error: (err,stack){return Center(child: Text('$err'));},
                        loading: ()=> CircularProgressIndicator()
                    );
                  })),
                ],
              ),
            ),));
  }
}
