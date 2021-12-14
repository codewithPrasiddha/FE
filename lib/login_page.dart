import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static String id = 'login_page';
  static var usernameController = TextEditingController();
  static var passwordController = TextEditingController();
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF94F3E4),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 28, horizontal: 43),
                  child: Container(
                    height: 350,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/vhc.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                const Text(
                  'Enter your login credentials.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'SourceSansPro',
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 43, top: 17, right: 43),
                  child: Text(
                    'Username',
                    style: TextStyle(
                      color: Color(0xFF1F1F1F),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SourceSansPro',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 43),
                  child: TextFormField(
                    controller: LoginPage.usernameController,
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF333F44),
                          width: 3,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF333F44),
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 43, top: 22, right: 43),
                  child: Text(
                    'Password',
                    style: TextStyle(
                      color: Color(0xFF1F1F1F),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SourceSansPro',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 43),
                  child: TextFormField(
                    obscureText: true,
                    controller: LoginPage.passwordController,
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF333F44),
                          width: 3,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF333F44),
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF149CB2),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          )),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF333F44),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text("Login")),
                const SizedBox(height: 20),
                TextButton(
                    onPressed: () {},
                    child: const Text(
                      "New User? Create Account",
                      style: TextStyle(
                        color: Color(0xFF333F44),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}