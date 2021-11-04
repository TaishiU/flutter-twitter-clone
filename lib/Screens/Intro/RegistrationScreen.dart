import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:twitter_clone/Constants/Constants.dart';
import 'package:twitter_clone/Provider/AuthProvider.dart';
import 'package:twitter_clone/Service/AuthService.dart';
import 'package:twitter_clone/Widget/RoundedButton.dart';
import 'package:twitter_clone/main.dart';

class RegistrationScreen extends HookWidget {
  RegistrationScreen({Key? key}) : super(key: key);

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _name = useProvider(nameProvider).state;
    final _email = useProvider(emailProvider).state;
    final _password = useProvider(passwordProvider).state;
    final _isObscure = useProvider(isObscureProvider);
    final AuthService _authService = AuthService();

    /*初期化処理が非同期だから、登録ボタンを押したときに_fcmTokenがnullのまま*/
    String? _fcmToken;

    void getFcmToken() async {
      print('ゼロ状態fcmToken: $_fcmToken');
      _fcmToken = await FirebaseMessaging.instance.getToken();
      print('初期fcmToken: $_fcmToken');
    }

    useEffect(() {
      getFcmToken();
    }, []);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.5,
        leading: BackButton(color: Colors.black),
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
                      context.read(nameProvider).state = value;
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
                  height: 40,
                ),
                RoundedButton(
                  btnText: 'Create account',
                  onBtnPressed: () async {
                    _formkey.currentState!.save();
                    if (_formkey.currentState!.validate()) {
                      bool isValid = await _authService.signUp(
                        name: _name,
                        email: _email,
                        password: _password,
                        fcmToken: _fcmToken,
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
