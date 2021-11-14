import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Provider/AuthProvider.dart';
import 'package:twitter_clone/Screens/Intro/ForgetPasswordScreen.dart';
import 'package:twitter_clone/Service/AuthService.dart';
import 'package:twitter_clone/Widget/RoundedButton.dart';
import 'package:twitter_clone/main.dart';

class LoginScreen extends HookWidget {
  LoginScreen({Key? key}) : super(key: key);

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _email = useProvider(emailProvider).state;
    final _password = useProvider(passwordProvider).state;
    final _isObscure = useProvider(isObscureProvider);
    final AuthService _authService = AuthService();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.5,
        leading: BackButton(color: Colors.black),
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
                        context
                            .read(isObscureProvider.notifier)
                            .update(!_isObscure);
                      },
                    ),
                  ),
                  onChanged: (value) {
                    context.read(passwordProvider).state = value;
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
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgetPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 16,
                          color: TwitterColor,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                RoundedButton(
                  btnText: 'Login',
                  onBtnPressed: () async {
                    _formkey.currentState!.save();
                    if (_formkey.currentState!.validate()) {
                      bool isValid = await _authService.login(
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
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: Text('Please log in again.'),
                              actions: [
                                TextButton(
                                  child: Text(
                                    'OK',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.red,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    primary: Colors.black,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
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
