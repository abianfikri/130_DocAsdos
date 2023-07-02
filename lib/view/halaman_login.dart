import 'package:final_exam_project/controller/auth_controller.dart';
import 'package:final_exam_project/main_page.dart';
import 'package:final_exam_project/model/user_model.dart';
import 'package:final_exam_project/view/admin/home_admin.dart';
import 'package:final_exam_project/view/asisten/home_asisten.dart';
import 'package:final_exam_project/view/halaman_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final authctr = AuthController();

  String? email;
  String? password;

  bool eyeToggle = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade800,
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
                      "DocAsdos App",
                      style: TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "This app for Documentation Assistence",
                      style: TextStyle(
                          color: Colors.grey[200],
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 407,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: Column(children: [
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        width: 350,
                        child: TextFormField(
                          autofocus: true,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: 'Username/Email',
                            hintText: "Enter your username/email",
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            bool valid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value!);
                            if (value == null || value.isEmpty) {
                              return "Please enter username or email";
                            }
                          },
                          onChanged: (value) {
                            email = value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        width: 350,
                        height: 80,
                        child: TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: eyeToggle,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your password";
                            } else if (value.length < 6) {
                              return "Please enter your password until 6 charachter or more";
                            }
                          },
                          onChanged: (value) {
                            password = value;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: InkWell(
                          onTap: () async {
                            if (formkey.currentState!.validate()) {
                              try {
                                UserModel? signUser = await authctr
                                    .signEmailandPassword(email!, password!);

                                if (signUser != null &&
                                    signUser.role == "Admin") {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                            'Login Admin Successful'),
                                        content: const Text(
                                            'You have been successfully Loginned.'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MainPage(),
                                                ),
                                              );
                                              print(signUser.email);
                                              // Navigate to the next screen or perform any desired action
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else if (signUser!.role == "Asisten") {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                            'Login Asisten Successful'),
                                        content: const Text(
                                            'You have been successfully Loginned.'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MainPage()),
                                                  ((route) => false));
                                              print(signUser.email);
                                              // Navigate to the next screen or perform any desired action
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  // Login failed
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Login Failed'),
                                        content: const Text(
                                            'An error occurred during Login.'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          HalamanLogin()));
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              } catch (e) {
                                // Login gagal
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Login Failed'),
                                      content: const Text(
                                          'Invalid email or password.'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HalamanLogin()),
                                            );
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            }
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
                              ),
                            ),
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
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                HalamanRegister()));
                                  },
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(color: Colors.deepOrange),
                                  ))
                            ],
                          ),
                        ),
                      )
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
