import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HalamanLogin extends StatefulWidget {
  const HalamanLogin({super.key});

  @override
  State<HalamanLogin> createState() => _HalamanLoginState();
}

class _HalamanLoginState extends State<HalamanLogin> {
  final formkey = GlobalKey<FormState>();

  bool eyeToggle = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(30),
                    child: Image.asset(
                      'assets/image/logo.jpeg',
                      width: 300,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Lets's get Started",
                      style: TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Welcome to DocAsdos",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "This app for Documentation Assistence",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(30),
                    child: Container(
                      width: 350,
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Username/Email',
                            hintText: "Enter your username/email",
                            prefixIcon: Icon(Icons.person)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Container(
                      width: 350,
                      child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: eyeToggle,
                        decoration: InputDecoration(
                            labelText: "Password",
                            hintText: "Enter your password",
                            prefixIcon: Icon(Icons.lock),
                            suffix: InkWell(
                              onTap: () {
                                setState(() {
                                  eyeToggle = !eyeToggle;
                                });
                              },
                              child: Icon(eyeToggle
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: InkWell(
                      onTap: () {
                        if (formkey.currentState!.validate()) {}
                      },
                      child: Container(
                        width: 300,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                            child: Text(
                          'Sign In',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(2),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(color: Colors.grey),
                          ),
                          TextButton(
                              onPressed: () {},
                              child: Text(
                                "Sign Up",
                                style: TextStyle(color: Colors.deepOrange),
                              ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
