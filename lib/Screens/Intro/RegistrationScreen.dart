import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Firebase/Auth.dart';
import 'package:twitter_clone/Widget/RoundedButton.dart';
import 'package:twitter_clone/main.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formkey = GlobalKey<FormState>();
  late String _name;
  late String _email;
  late String _password;
  bool _isObscure = true;
  FirebaseMessaging fcm = FirebaseMessaging.instance;
  String? fcmToken;

  @override
  void initState() async {
    super.initState();

    fcmToken = await FirebaseMessaging.instance.getToken();
    print('fcmToken: $fcmToken');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.5,
        title: Text(
          'Registration',
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
                      labelText: 'Name',
                      icon: Icon(Icons.person),
                    ),
                    onChanged: (value) {
                      _name = value;
                    },
                    validator: (String? input) {
                      if (input!.isEmpty) {
                        return 'Enter your Name';
                      }
                      return null;
                    }),
                SizedBox(height: 30),
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
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    icon: Icon(Icons.vpn_key),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
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
                  btnText: 'Create account',
                  onBtnPressed: () async {
                    _formkey.currentState!.save();
                    if (_formkey.currentState!.validate()) {
                      bool isValid = await Auth().signUp(
                        name: _name,
                        email: _email,
                        password: _password,
                        fcmToken: fcmToken,
                      );
                      if (isValid) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyApp(),
                          ),
                        );
                      } else {
                        print('Registration problem');
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
