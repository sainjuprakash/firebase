import 'dart:io';
import 'package:firebase/auth_provider/auth_provider.dart';
import 'package:firebase/auth_provider/common_provider.dart';
import 'package:firebase/common/snack_show.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthPage extends ConsumerWidget {
  final mailController = TextEditingController();
  final passController = TextEditingController();
  final nameController = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, ref) {
    ref.listen(authProvider, (previous, next) {
      // print('previous');
      // print(previous);
      // print(next);
      if (next.isError) {
        SnackShow.showFailure(context, next.errText);
      } else if (next.isSuccess) {
       SnackShow.showSuccess(context, 'Login success');

      }
    });
    final isLogin = ref.watch(loginProvider);
    final auth = ref.watch(authProvider);
    final image = ref.watch(imageProvider);

    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: NetworkImage(
            'https://images.unsplash.com/photo-1487700160041-babef9c3cb55?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=852&q=80'),
        fit: BoxFit.cover,
      )),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      // color: Colors.blueGrey,
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://media.istockphoto.com/id/1426070859/photo/human-resources-and-management-concept-employees-must-complete-the-online-survey-form-answer.jpg?s=1024x1024&w=is&k=20&c=K2Upglp9yIxs4l6OHf40u7KiApl28H92WiOxu8EbZJ0=')),
                    ),
                  ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  Center(
                    child: Text(
                      isLogin ? 'User Login' : 'User Register',
                      style: const TextStyle(
                          fontSize: 30,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (!isLogin)
                    TextFormField(
                      controller: nameController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'please provide your name';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), hintText: 'Your Name'),
                    ),
                  const SizedBox(
                    height: 20,
                  ),

                  TextFormField(
                    controller: mailController,
                    validator: (val) {
                      bool emailValid = RegExp(
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                          .hasMatch(val!);
                      if (val!.isEmpty) {
                        return 'please provide your email';
                      } else if (!emailValid) {
                        return 'please provide validate email';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Your email'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: passController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'please provide your password';
                      }
                      return null;
                    },
                    //textAlign: TextAlign.center,
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Your password'),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  const Text(
                    "must have atleast 5 character.",
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (!isLogin)
                    InkWell(
                      onTap: () {
                        ref.read(imageProvider.notifier).pickImage(false);
                      },
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: image == null
                            ? const Center(
                                child: Text('Please Select an image',
                                    style: TextStyle(color: Colors.black)))
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
                        // print(mailController.text.trim());
                        // print(passController.text.trim());
                        if (isLogin) {
                          ref.read(authProvider.notifier).userLogin(
                              email: mailController.text.trim(),
                              password: passController.text.trim());
                        } else {
                          if (image == null) {
                            SnackShow.showFailure(context, 'No image selected');
                          } else {
                            ref.read(authProvider.notifier).userRegister(
                                email: mailController.text.trim(),
                                password: passController.text.trim(),
                                username: nameController.text.trim(),
                                image: image);
                          }
                        }
                      }
                    },
                    child: auth.isLoad
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: Colors.white,
                          ))
                        : Text(
                            isLogin ? 'Login' : 'Sign-up',
                          ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          isLogin
                              ? 'Don\'n have an account?'
                              : 'Already have an account?',
                          style: TextStyle(color: Colors.black)),
                      TextButton(
                          onPressed: () {
                            ref.read(loginProvider.notifier).toggle();
                          },
                          child: Text(isLogin ? 'signup' : 'login',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20)))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
