import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smatprop/widgets/LoadingModal.dart';
import '../../../constants/global_constants.dart';
import '../../../widgets/SuccessModal.dart';
import '../../Login/components/already_have_an_account_acheck.dart';
import '../../Login/components/login_response.dart';
import '../../Login/login_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool _isLoading = false;
  late SharedPreferences logindata;
  TextEditingController _email = TextEditingController();
  TextEditingController _firstname = TextEditingController();
  TextEditingController _lastname = TextEditingController();
  TextEditingController _pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: _firstname,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: InputDecoration(
              hintText: "Your First Name",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          TextFormField(
            controller: _lastname,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: InputDecoration(
              hintText: "Your Last Name",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
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
          const SizedBox(height: defaultPadding / 2),
          ElevatedButton(
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
             LoadingModal.showLoadingModal(context);
                print("tirikupinda here on mobile7");
                print(_firstname.text);
                print(_lastname.text);
                print(_email.text);
                print(_pass.text);
                setState(() {
                  _isLoading = true;
                  print("set state");
                });

                var url = Uri.parse('http://'+ip_address2+':8081/api/v1/auth/register');
                var headers = {'Content-Type': 'application/json'};
                var body = json.encode({
                  'firstname': _firstname.text,
                  'lastname': _lastname.text,
                  'email': _email.text,
                  'password': _pass.text,
                  'role': 'USERZ'
                });
                try{
                  var response = await http.post(url, headers: headers, body: body);
                  ////////////////////////////
                  Navigator.of(context).pop();
                  _firstname.clear();
                  _lastname.clear();
                  _email.clear();
                  _pass.clear();
                  SuccessModal.showSuccessModal(context, "You have successfully registered. Please login to continue");

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
                    logindata.setString("token",loginResponse.data.accessToken);
                    logindata.setString("refreshToken",loginResponse.data.refreshToken);
                    logindata.setString("function_log_control","granted");

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
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
               /*   ScaffoldMessenger.of(context).showSnackBar(
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
                  );*/
                }

              },
            child: Text("Sign Up".toUpperCase()),
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
                        return LoginScreen();
                      },
                    ),
                  );
                },
                child: Text(
                  "Sign In",
                  style: const TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        /*  AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ;
                  },
                ),
              );
            },
          ),*/
        ],
      ),
    );
  }
}