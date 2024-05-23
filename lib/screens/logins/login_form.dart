
import 'package:flutter/material.dart';

import '../../Signup/signup_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();
  bool _isLoading = false;
  late SharedPreferences logindata;
  late bool newUser;

  @override
  void initState() {
    super.initState();
    check_if_already_login();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: InputDecoration(
              hintText: "Your email",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: _pass,
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),

          _isLoading
              ? CircularProgressIndicator()
              : Hero(
            tag: "login_btn",
            child: Container(
              height:40.0,
              width: 210.0,
              margin: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 40.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(100,10),
                  elevation: 10,
                   backgroundColor: Colors.blue,
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontStyle: FontStyle.normal),
                ),
              onPressed: (){},
                child: Text(
                  "Login".toUpperCase(),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return RegistrationScreen();//SignUpScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
 void  check_if_already_login() async {
    logindata = await SharedPreferences.getInstance();
    print("ccc vs zanu2"+logindata.getBool('login').toString());
    newUser = (logindata.getBool('login')??true);
    print(newUser);

    if(newUser==false){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    }
  }
  @override
  void dispose(){
_email.dispose();
_pass.dispose();
super.dispose();
  }
}