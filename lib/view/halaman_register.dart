import 'package:final_exam_project/component/gradiant_text.dart';
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

  String role = 'Asisten';
  bool eyeToogle = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0XFF8A2387),
                Color(0xFFE94057),
                Color(0xFFF27121),
              ],
            ),
          ),

          // Form Register
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                // Button kembali ke login
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: () {
                          // Back To Login
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: 5,
                ),

                // Logo Gambar
                CircleAvatar(
                  backgroundImage: AssetImage('assets/image/logo.jpeg'),
                  radius: 40,
                ),
                SizedBox(
                  height: 5,
                ),

                Text(
                  'DocAsdos',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),

                SizedBox(
                  height: 25,
                ),

                // Container TextFormField Register
                Container(
                  height: 490,
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      GradientText(
                        'SignUp',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Color(0XFF8A2387),
                            Color(0xFFE94057),
                            Color(0xFFF27121),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Create Your Account for Login',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      //  TexFormField Username
                      Container(
                        width: 280,
                        child: TextFormField(
                          autocorrect: false,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: "Username",
                            hintText: "Enter your username",
                            suffixIcon: Icon(
                              Icons.person,
                            ),
                          ),
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

                      SizedBox(
                        height: 10,
                      ),

                      // TexFormField Email
                      Container(
                        width: 280,
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelText: "Email",
                              hintText: "Enter your email",
                              suffixIcon: Icon(Icons.email)),
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

                      SizedBox(
                        height: 10,
                      ),

                      // TextFormField Password
                      Container(
                        width: 280,
                        child: TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: eyeToogle,
                          decoration: InputDecoration(
                              labelText: "Password",
                              hintText: "Enter your password",
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

                      SizedBox(
                        height: 35,
                      ),

                      // Button Register
                      GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          width: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFF8A2387),
                                Color(0xFFE94057),
                                Color(0xFFF27121),
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              'Register',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        onTap: () async {
                          if (formkey.currentState!.validate()) {
                            UserModel? registeredUser =
                                await authctr.registeremailPassword(
                                    email!, password!, username!, role);

                            if (registeredUser != null) {
                              // Registration successful
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title:
                                        const Text('Registration Successful'),
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
                      ),

                      SizedBox(
                        height: 5,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have Account? ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
