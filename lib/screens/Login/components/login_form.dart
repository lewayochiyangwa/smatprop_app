import 'package:flutter/material.dart';
import '../../../constants/global_constants.dart';
import '../../BottomNav.dart';
import '../../Signup/signup_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'already_have_an_account_acheck.dart';
import 'login_response.dart';

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
                onPressed: () async {
                  print("tirikupinda here on mobile7");
                  setState(() {
                    _isLoading = true;
                    print("set state");
                  });

                  var url = Uri.parse('http://'+ip_address2+':8081/api/v1/auth/authenticate');
                  var headers = {'Content-Type': 'application/json'};
                  var body = json.encode({
                    'email': _email.text,
                    'password': _pass.text,
                  });
                  try{
                  var response = await http.post(url, headers: headers, body: body);
                  ////////////////////////////


                  print("test response");
                  print(response.body);
                  print(response.statusCode);

                  final Map<String, dynamic> responseData = jsonDecode(response.body);
                  final LoginResponse loginResponse = LoginResponse.fromJson(responseData);
                  print("you must redirect now");
                  print("get the login response status"+loginResponse.status);

                    if (loginResponse.code==200) {
                      print("you must redirect now");

                      print(loginResponse.status);
                      print(loginResponse.code);
                      print(loginResponse.message);
                      print(loginResponse.data.email);
                      print(loginResponse.data.accessToken);
                      print(loginResponse.data.refreshToken);

                      //print("yes smart t"+loginResponse.data[1]);
                      logindata.setBool("login", false);
                      logindata.setString("email",loginResponse.data.email);
                      logindata.setInt("userId",loginResponse.data.userId);
                      logindata.setString("role",loginResponse.data.role);
                      logindata.setString("token",loginResponse.data.accessToken);
                      logindata.setString("refreshToken",loginResponse.data.refreshToken);
                      logindata.setString("function_log_control","granted");

                      if(loginResponse.data.accessToken=="Not Activated"){
                        setState(() {
                          _isLoading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('This Acc is Not Activated'),
                            duration: Duration(seconds: 4),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.red, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );

                      }else{
                        ////////////////////////////
                        var url = Uri.parse(ip_address3+'api/v1/auth/profilepic');
                        var headers = {'Content-Type': 'application/json'};
                        var body = json.encode({
                       //   'email':loginResponse.data.email
                          'userId':loginResponse.data.userId

                        });
                        try {
                          var response = await http.post(url, headers: headers, body: body);
                          print("test response for prolink");
                          print(response.body);
                          setState(() {
                            print(ngrok+"/houses/"+response.body);
                            print("=========Tiri Mu set==========");
                            logindata.setString("proLink",ngrok+"/houses/"+response.body);
                            print("=========Tabuda Mu set==========");


                          });

                        } catch (error) {
                          print(error);
                        }

                        ////////////////////////////
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNavigationExample(),
                          ),
                        );
                      }


                    } else if(loginResponse.status=="404"){

                      setState(() {
                        _isLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Login credentials Failed. User Or Password is Wrong'),
                          duration: Duration(seconds: 4),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.red, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }
                  }catch(e){
                    print("tatombopinda mu error here"+e.toString());
                    setState(() {
                      _isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        duration: Duration(seconds: 4),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }

                },
                child: Text(
                  "Login".toUpperCase(),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Padding(
            padding: const EdgeInsets.only(left: 60.0),
            child: Row(
              children: [
                Text("Have an account?"),
                SizedBox(width:10,),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SignUpScreen();
                        },
                      ),
                    );
                  },
                  child: Text(
                    "Sign Up",
                    style: const TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
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
     /* Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );*/
    }
  }
  @override
  void dispose(){
_email.dispose();
_pass.dispose();
super.dispose();
  }
}