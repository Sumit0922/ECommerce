import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_hub/Ui/Sign_in.dart';

class LoginPage extends StatefulWidget {
  final String username;
  final String password;

  const LoginPage({Key? key, required this.username, required this.password})
      : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _loginIdController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool passToggle = true;
  bool _showSuccessNotification = false;

  Future<bool> authenticateUser(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');
    String? storedPassword = prefs.getString('password');

    return username == storedUsername && password == storedPassword;
  }

  void _showSuccessMessage() {
    setState(() {
      _showSuccessNotification = true;
    });
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _showSuccessNotification = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE5B2CA),
      body: SingleChildScrollView(
        child: Padding(
          padding:
          EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
          child: Column(
            children: [
              if (_showSuccessNotification)
                Container(
                  color: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.white,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Login Successful',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              Text(
                'WELCOME',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 29),
              ),

              Text('to shopping Hub',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,fontStyle: FontStyle.italic),),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 20,
              ),
              Image.network(
                "https://cdni.iconscout.com/illustration/premium/thumb/lady-entrepreneur-2647389-2194324.png",
                width: 200,
                height: 300,
                fit: BoxFit.contain,
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _loginIdController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Email",
                            hintText: "Enter Email Address",
                            prefixIcon: Icon(Icons.person_rounded),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty ||
                                !RegExp(r'^[\w-\,]+@([\w-]+\.)+[\w]{2,4}')
                                    .hasMatch(value!)) {
                              return "Enter Valid Email";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: passToggle,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            labelText: "Password",
                            hintText: "Enter Password",
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(),
                            suffix: InkWell(
                              onTap: () {
                                setState(() {
                                  passToggle = !passToggle;
                                });
                              },
                              child: Icon(passToggle
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Password";
                            }
                            if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white10,
                            minimumSize: Size(180, 45),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              String username = _loginIdController.text;
                              String password = _passwordController.text;
                              bool isAuthenticated =
                              await authenticateUser(username, password);

                              if (isAuthenticated) {
                                _showSuccessMessage();
                                await Future.delayed(Duration(seconds: 1));

                                _loginIdController.clear();
                                _passwordController.clear();


                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Error'),
                                      content: Text('Invalid credentials.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                          },
                          child: Text("Submit"),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Don\'t have an account? Sign up',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
