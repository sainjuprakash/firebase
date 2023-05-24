import 'package:firebase/auth_provider/common_provider.dart';
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
    final isLogin = ref.watch(loginProvider);
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // const SizedBox(
                //   height: 20,
                // ),
                Center(
                  child: Text(
                    isLogin ? 'User Login' : 'User Register',
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (!isLogin)
                TextFormField(
                  controller: nameController,
                  validator: (val){
                    if(val!.isEmpty){
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
                    validator: (val){
                      bool emailValid = RegExp(
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(val!);
                      if(val!.isEmpty){
                        return 'please provide your email';
                      }else if(!emailValid){
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
                  validator: (val){
                    if(val!.isEmpty){
                      return 'please provide your password';
                    }else if(val.length>15 || val.length <5){
                      return 'password must be between 5-15 characters';
                    }else if(val.length>=5 && !val.contains(RegExp(r'\W')) && RegExp(r'\d+\w*\d+').hasMatch(val))
                    {
                      return " \n\t$val is Valid Password";
                    }
                    else
                    {
                      return "\n\t$val is Invalid Password";

                    }
                    return null;
                  },
                  //textAlign: TextAlign.center,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Your password'),
                ),
                const SizedBox(height: 2,),
                const Text("must have atleast 5 character with two digits.",style: TextStyle(color: Colors.grey),),
                const SizedBox(
                  height: 20,
                ),
                if (!isLogin)
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.white)),
                    child: const Center(child: Text('Please Select an image')),
                  ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    _form.currentState!.save();                   //form validation
                    if(_form.currentState!.validate()){
                       print(mailController.text.trim());
                       print(passController.text.trim());
                    }
                  },
                  child: Text(isLogin ? 'Login' : 'Sign-up'),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(isLogin
                        ? 'Don\'n have an account?'
                        : 'Already have an account?'),
                    TextButton(
                        onPressed: () {
                          ref.read(loginProvider.notifier).toggle();
                        },
                        child: Text(isLogin ? 'signup' : 'login'))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
