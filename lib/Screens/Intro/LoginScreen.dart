import 'package:flutter/material.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Firebase/Auth.dart';
import 'package:twitter_clone/Widget/RoundedButton.dart';
import 'package:twitter_clone/main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  late String _email;
  late String _password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.5,
        title: Text(
          'Login',
          style: TextStyle(
            color: TwitterColor,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              children: [
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
                SizedBox(height: 30),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    icon: Icon(Icons.vpn_key),
                  ),
                  onChanged: (value) {
                    _password = value;
                  },
                  keyboardType: TextInputType.visiblePassword,
                  validator: (String? input) {
                    if (input!.isEmpty) {
                      return 'Enter Password';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 40,
                ),
                RoundedButton(
                  btnText: 'Login',
                  onBtnPressed: () async {
                    _formkey.currentState!.save();
                    if (_formkey.currentState!.validate()) {
                      bool isValid = await Auth().login(
                        email: _email,
                        password: _password,
                      );
                      if (isValid) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyApp(),
                          ),
                        );
                      } else {
                        print('Login problem');
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
