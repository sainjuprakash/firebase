import 'package:firebase/view/auth_page.dart';
import 'package:firebase/view/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStream =
    StreamProvider((ref) => FirebaseAuth.instance.authStateChanges());

class StatusPage extends StatelessWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
        Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
      final authData = ref.watch(authStream);
      return authData.when(
          data: (data) {
            if (data == null) {
              return AuthPage();
            } else {
              return HomePage();
            }
          },
          error: (err, stack) => Text('$err'),
          loading: () => const Center(child: CircularProgressIndicator()));
    }));
  }
}
