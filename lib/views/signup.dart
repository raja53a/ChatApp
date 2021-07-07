import 'package:flutter/material.dart';
import 'package:pingme/helper/helperFunctions.dart';
import 'package:pingme/services/auth.dart';
import 'package:pingme/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:pingme/views/chatRoomsScreen.dart';
import 'package:pingme/services/database.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  bool isLoading = false;
  bool _passwordObscured = true;
  _togglePasswordStatus() {
    setState(() {
      _passwordObscured = !_passwordObscured;
    });
  }

  final formkey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  signMeUp() async {
    if (formkey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      await authMethods
          .signUpWithEmailAndPassword(
        emailTextEditingController.text,
        passwordTextEditingController.text,
      )
          .then((val) {
        if (val != null) {
          Map<String, String> userInfoMap = {
            "name": userNameTextEditingController.text,
            "email": emailTextEditingController.text,
          };
          databaseMethods.uploadUserInfo(userInfoMap);
          HelperFunctions.saveUserLoggedInPreferences(true);
          HelperFunctions.saveUserEmailPreferences(
            emailTextEditingController.text,
          );
          HelperFunctions.saveUserNamePreferences(
            userNameTextEditingController.text,
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChatRoom(),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 120,
                      ),
                      Container(
                        height: 100,
                        child: Image.asset(
                          'assets/images/icons8.png',
                        ),
                      ),
                      Form(
                        key: formkey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (val) {
                                if (val.isEmpty) {
                                  return "Username Can't be Empty";
                                } else {
                                  return val.length < 4
                                      ? "Username can't be less than 4 character"
                                      : null;
                                }
                              },
                              controller: userNameTextEditingController,
                              decoration: InputDecoration(
                                hintText: "Username",
                                suffixIcon: Icon(
                                  Icons.account_circle,
                                  size: 18.0,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              validator: (val) {
                                if (val.isEmpty) {
                                  return "Please enter your email";
                                } else {
                                  return RegExp(
                                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                          .hasMatch(val)
                                      ? null
                                      : "Please provide a valid email";
                                }
                              },
                              controller: emailTextEditingController,
                              decoration: InputDecoration(
                                hintText: "Email",
                                suffixIcon: Icon(
                                  Icons.email,
                                  size: 18.0,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              obscureText: _passwordObscured,
                              validator: (val) {
                                if (val.isEmpty) {
                                  return "Please enter your password";
                                } else {
                                  return val.length > 6
                                      ? null
                                      : "Password can't be less than 6 character";
                                }
                              },
                              controller: passwordTextEditingController,
                              decoration: InputDecoration(
                                hintText: "Password",
                                suffixIcon: IconButton(
                                  onPressed: _togglePasswordStatus,
                                  icon: Icon(
                                    _passwordObscured
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    size: 18.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          signMeUp();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xff007EF4),
                                const Color(0xff2A75BC),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(45.0),
                          ),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: Colors.blueAccent,
                          ),
                          borderRadius: BorderRadius.circular(45.0),
                        ),
                        child: Text(
                          "Sign Up with Google",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have account?",
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                " Sign In",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 150,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
