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
  //final GlobalKey _formkey = GlobalKey();
  late String _name;
  late String _email;
  late String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TwitterColor,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Registration',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'Name',
              ),
              onChanged: (value) {
                _name = value;
              },
            ),
            SizedBox(height: 30),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Email',
              ),
              onChanged: (value) {
                _email = value;
              },
              keyboardType: TextInputType.emailAddress,
              // validator: (String? value) {
              //   if (value!.isEmpty) {
              //     return 'Enter Email';
              //   }
              //   return null;
              // },
            ),
            SizedBox(height: 30),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
              ),
              onChanged: (value) {
                _password = value;
              },
              keyboardType: TextInputType.visiblePassword,
              // validator: (String? value) {
              //   if (value!.isEmpty) {
              //     return 'Enter Password';
              //   }
              //   return null;
              // },
            ),
            SizedBox(
              height: 40,
            ),
            RoundedButton(
              btnText: 'Create account',
              onBtnPressed: () async {
                bool isValid = await Auth().signUp(
                  name: _name,
                  email: _email,
                  password: _password,
                );
                if (isValid) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );
                } else {
                  print('Registration problem');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
