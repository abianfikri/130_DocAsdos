import 'package:final_exam_project/controller/auth_controller.dart';
import 'package:final_exam_project/model/user_model.dart';
import 'package:final_exam_project/view/halaman_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HalamanRegister extends StatefulWidget {
  const HalamanRegister({super.key});

  @override
  State<HalamanRegister> createState() => _HalamanRegisterState();
}

class _HalamanRegisterState extends State<HalamanRegister> {
  final formkey = GlobalKey<FormState>();
  final authctr = AuthController();

  String? username;
  String? email;
  String? password;
  String? role;
  bool eyeToogle = true;
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
                Container(
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: FloatingActionButton(
                          child: Icon(Icons.arrow_back),
                          backgroundColor: Colors.deepOrange,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HalamanLogin()));
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/image/logo.jpeg'),
                      radius: 60,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Register',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    width: 350,
                    child: TextFormField(
                      autofocus: true,
                      autocorrect: false,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          labelText: "Username",
                          hintText: "Enter your username",
                          prefixIcon: Icon(Icons.person)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter your username";
                        }
                      },
                      onChanged: (value) {
                        username = value;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    width: 350,
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "Enter your email",
                          prefixIcon: Icon(Icons.email)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter your email";
                        } else if (!value.contains("@") ||
                            !value.contains(".")) {
                          return "Please enter a valid email address";
                        }
                      },
                      onChanged: (value) {
                        email = value;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    width: 350,
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: eyeToogle,
                      decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Enter your password",
                          prefixIcon: Icon(Icons.lock),
                          suffix: InkWell(
                            onTap: () {
                              setState(() {
                                eyeToogle = !eyeToogle;
                              });
                            },
                            child: Icon(eyeToogle
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
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    width: 350,
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: "Role",
                          hintText: "Enter your Role",
                          prefixIcon: Icon(Icons.ad_units)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your role";
                        }
                      },
                      onChanged: (value) {
                        role = value;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: InkWell(
                    onTap: () async {
                      if (formkey.currentState!.validate()) {
                        UserModel? registeredUser =
                            await authctr.registeremailPassword(
                                email!, password!, username!, role!);

                        if (registeredUser != null) {
                          // Registration successful
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Registration Successful'),
                                content: const Text(
                                    'You have been successfully registered.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HalamanLogin()));
                                      print(registeredUser.username);
                                      // Navigate to the next screen or perform any desired action
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          // Registration failed
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Registration Failed'),
                                content: const Text(
                                    'An error occurred during registration.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HalamanRegister()));
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
                        'Register',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
