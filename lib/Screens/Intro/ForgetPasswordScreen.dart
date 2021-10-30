import 'package:flutter/material.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Firebase/Auth.dart';
import 'package:twitter_clone/Screens/Intro/WelcomeScreen.dart';
import 'package:twitter_clone/Widget/RoundedButton.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formkey = GlobalKey<FormState>();
  late String _email;
  @override
  Widget build(BuildContext context) {
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
                      _email = value;
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
                        String result =
                            await Auth().sendPasswordResetEmail(email: _email);
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
