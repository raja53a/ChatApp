import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pingme/helper/helperFunctions.dart';
import 'package:pingme/services/auth.dart';
import 'package:pingme/services/database.dart';
import 'package:pingme/views/chatRoomsScreen.dart';
import 'package:pingme/widgets/widgets.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formkey = GlobalKey<FormState>();

  bool isLoading = false;
  bool _passwordObscured = true;
  _togglePasswordStatus() {
    setState(() {
      _passwordObscured = !_passwordObscured;
    });
  }

  QuerySnapshot snapshotUserInfo;

  signIn() async {
    if (formkey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      await authMethods
          .signInWithEmailAndPassword(
        emailTextEditingController.text,
        passwordTextEditingController.text,
      )
          .then((val) async {
        if (val != null) {
          QuerySnapshot snapshotUserInfo = await DatabaseMethods()
              .getUserByUserEmail(emailTextEditingController.text);
          HelperFunctions.saveUserLoggedInPreferences(true);
          HelperFunctions.saveUserNamePreferences(
            snapshotUserInfo.docs[0].data()["name"],
          );
          HelperFunctions.saveUserEmailPreferences(
            snapshotUserInfo.docs[0].data()["email"],
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChatRoom(),
            ),
          );
        } else {
          setState(() {
            isLoading = false;
            //show snackbar;
          });
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
              child: Center(
                child: CircularProgressIndicator(),
              ),
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
                      SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: formkey,
                        child: Column(
                          children: [
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
                          signIn();
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
                            "Sign In",
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
                          "Sign In with Google",
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
                            "Don't have account?",
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
                                " Register Now",
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
