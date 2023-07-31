import 'dart:async';

import 'package:firebase/services/auth_service.dart';
import 'package:firebase/view/auth_page.dart';
import 'package:firebase/view/home_page.dart';
import 'package:firebase/status_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    token();
    // TODO: implement initState
    super.initState();
  }

  Future<void> token() async {
    final token = await FirebaseMessaging.instance.getToken();
    print('Tokem is $token');
  }

  Widget build(BuildContext context) {
    return GetMaterialApp(
      //theme:ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  StatusPage(),
    );
  }
}

// class counter extends StatelessWidget {
//   counter({Key? key}) : super(key: key);
//   int num= 0+1;
//   final numberStream = StreamController<int>();
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<int>(
//           stream: numberStream.stream,
//           builder: (context, snapshot) {
//             print(snapshot.data);
//             return Center(
//               child: Text(
//                 snapshot.data.toString(),
//                 style: TextStyle(fontSize: 40),
//               ),
//             );
//           }),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           numberStream.sink.add(num++);
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
