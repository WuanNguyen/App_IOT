import 'package:appiot/main_screen.dart';
import 'package:appiot/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:appiot/auth/firebase_auth_service.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController tk = TextEditingController();
  TextEditingController mk = TextEditingController();
   bool _isSigning = false;
  bool showPassword = false;
  //tai khoan : admin123@gmail.com
  //matkhau : 12345@a

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  @override
  void dispose() {
    tk.dispose();
    mk.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/img_bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            alignment: AlignmentDirectional.center,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 5),
                              child: Image.asset(
                                "assets/img/icon_home.jpg",
                                width: 100,
                                height: 100,
                              ),
                            ),
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(padding: EdgeInsets.only(bottom: 30)),
                            Text(
                              "SMART HOME",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: FractionallySizedBox(
                      widthFactor: 0.65,
                      child: SizedBox(
                        height: 40,
                        child: TextFormField(
                          controller: tk,
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2, color: Colors.grey),
                            ),
                            hintText: "Tài khoản",
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.zero,
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(Icons.person),
                            ),
                          ),
                          textAlignVertical: TextAlignVertical.center,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: FractionallySizedBox(
                      widthFactor: 0.65,
                      child: SizedBox(
                        height: 40,
                        child: TextFormField(
                          controller: mk,
                          obscureText: !showPassword,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromRGBO(255, 255, 255, 1),
                            enabledBorder:const  OutlineInputBorder(
                              borderSide: BorderSide(width: 2, color: Colors.grey),
                            ),
                            hintText: "Mật khẩu",
                            border: const OutlineInputBorder(),
                            contentPadding: EdgeInsets.zero,
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(Icons.lock),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                            ),
                          ),
                          textAlignVertical: TextAlignVertical.center,
                        ),
                      ),
                    ),
                  ),
                  
                  Padding(
                    
                    padding: EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                        _signIn();
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            Colors.grey.withOpacity(0.8)),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: BorderSide(width: 2, color: Colors.grey),
                          ),
                        ),
                        minimumSize: MaterialStateProperty.all<Size>(
                          Size(
                            MediaQuery.of(context).size.width * 0.65,
                            40,
                          ),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          "Đăng nhập",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(
                          Colors.grey.withOpacity(0.8)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(width: 2, color: Colors.grey),
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(
                        Size(
                          MediaQuery.of(context).size.width * 0.65,
                          40,
                        ),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        "Đăng ký",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

void _signIn() async {
  setState(() {
    _isSigning = true;
  });

  String email = tk.text;
  String password = mk.text;

  // Kiểm tra tính hợp lệ của tài khoản và mật khẩu
  if (email.isEmpty || password.isEmpty) {
    showSnackBar(context, 'Vui lòng nhập tài khoản và mật khẩu.');
    setState(() {
      _isSigning = false;
    });
    return;
  }

  // Thực hiện đăng nhập với Firebase
  User? user = await _auth.signInWithEmailAndPassword(email, password);
  setState(() {
    _isSigning = false;
  });

  if (user != null) {
    _auth.setUserName(email);
    print("User is successfully signed in");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MainScreen(),
      ),
    );
  } else {
    print("Đăng nhập thất bại: Tài khoản hoặc mật khẩu không chính xác.");
    showSnackBar(context, 'Tài khoản hoặc mật khẩu không chính xác.');
  }
}
}
