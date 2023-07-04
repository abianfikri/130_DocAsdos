import 'package:final_exam_project/component/gradiant_text.dart';
import 'package:final_exam_project/controller/auth_controller.dart';
import 'package:final_exam_project/main_page.dart';
import 'package:final_exam_project/model/user_model.dart';
import 'package:final_exam_project/view/halaman_register.dart';
import 'package:flutter/material.dart';

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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF8A2387),
                Color(0xFFE94057),
                Color(0xFFF27121),
              ],
            ),
          ),

          // Form Login
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 80,
                ),

                // Logo Gambar
                CircleAvatar(
                  backgroundImage: AssetImage('assets/image/logo.jpeg'),
                  radius: 40,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'DocAsdos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 480,
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      GradientText(
                        'Hello',
                        style: TextStyle(
                          fontSize: 35,
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
                        'Please Login to Your Account',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      // TextFormField Email
                      Container(
                        width: 280,
                        child: TextFormField(
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: "Enter your email",
                            suffixIcon: Icon(
                              Icons.email,
                              size: 19,
                            ),
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
                        height: 20,
                      ),

                      // TextFormFielPassword
                      Container(
                        width: 280,
                        child: TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: eyeToggle,
                          decoration: InputDecoration(
                              labelText: "Password",
                              hintText: "Enter your password",
                              suffix: InkWell(
                                onTap: () {
                                  setState(() {
                                    eyeToggle = !eyeToggle;
                                  });
                                },
                                child: Icon(
                                  eyeToggle
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  size: 19,
                                ),
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
                        height: 40,
                      ),

                      // Button Submit
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
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        // Action Login Cek
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
                                      title:
                                          const Text('Login Admin Successful'),
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
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      Row(
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
