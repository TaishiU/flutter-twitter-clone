import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Provider/Provider.dart';
import 'package:twitter_clone/Screens/Intro/WelcomeScreen.dart';
import 'package:twitter_clone/Service/AuthService.dart';
import 'package:twitter_clone/Widget/RoundedButton.dart';

class ForgetPasswordScreen extends HookWidget {
  ForgetPasswordScreen({Key? key}) : super(key: key);

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _email = useProvider(emailProvider).state;
    final AuthService _authService = AuthService();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.5,
        leading: BackButton(color: Colors.black),
        title: Text(
          'Forgot Password',
          style: TextStyle(
            color: TwitterColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Text(
                    'Please enter your Email address \nto reset password.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      icon: Icon(Icons.email_outlined),
                    ),
                    onChanged: (value) {
                      context.read(emailProvider).state = value;
                    },
                    keyboardType: TextInputType.emailAddress,
                    validator: (String? input) {
                      if (input!.isEmpty) {
                        return 'Enter your Email';
                      }
                      if (input.isNotEmpty && !input.contains('@')) {
                        return 'You need to check \'@\' mark';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  RoundedButton(
                    btnText: 'Send Email',
                    onBtnPressed: () async {
                      _formkey.currentState!.save();
                      if (_formkey.currentState!.validate()) {
                        String result = await _authService
                            .sendPasswordResetEmail(email: _email);
                        if (result == 'success') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WelcomeScreen(),
                            ),
                          );
                        } else if (result == 'ERROR_INVALID_EMAIL') {
                          final snackBar = SnackBar(
                            content: Text('Invalid Email'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else if (result == 'ERROR_USER_NOT_FOUND') {
                          final snackBar = SnackBar(
                            content: Text('Email address is not registered'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          final snackBar = SnackBar(
                            content: Text('Failed to send email'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
