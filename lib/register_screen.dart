import 'package:appiot/login_screen.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController tk = TextEditingController();
  TextEditingController mk = TextEditingController();
  TextEditingController mk2 = TextEditingController();
  bool showPassword = false;
   bool showPassword1 = false;
  RegExp regex = RegExp(r'[!@?#]');
  

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                              padding: EdgeInsets.only(top: 30),
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
                            Text(
                              "ĐĂNG KÝ",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
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
                    padding: EdgeInsets.all(5),
                    child: FractionallySizedBox(
                      widthFactor: 0.65,
                      child: SizedBox(
                        height: 40,
                        child: TextFormField(
                          controller: mk2,
                          obscureText: !showPassword1,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromRGBO(255, 255, 255, 1),
                            enabledBorder:const  OutlineInputBorder(
                              borderSide: BorderSide(width: 2, color: Colors.grey),
                            ),
                            hintText: "Nhập lại mật khẩu",
                            border: const OutlineInputBorder(),
                            contentPadding: EdgeInsets.zero,
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(Icons.lock),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                showPassword1
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  showPassword1 = !showPassword1;
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
                        setState(() {
                          if (_formKey.currentState?.validate() ?? false) {
                            if (tk.text == tk.text) {
                              if (mk.text.compareTo(mk2.text) == 0) {
                                if (mk.text.trim().length > 5) {
                                  if (regex.hasMatch(mk.text.trim())) {
                                    showSnackBar(context, 'Thiết lập thành công');
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterScreen(),
                                      ),
                                    );
                                  } else {
                                    showSnackBar(
                                      context,
                                      "Mật khẩu phải có tối thiểu 1 ký tự đặc biệt",
                                    );
                                  }
                                } else {
                                  showSnackBar(
                                    context,
                                    "Mật khẩu phải có tối thiểu 6 ký tự",
                                  );
                                }
                              } else {
                                showSnackBar(
                                  context,
                                  "Mật khẩu nhập lại không trùng khớp",
                                );
                              }
                            } else {
                              showSnackBar(context, 'Tài khoản không tồn tại');
                            }
                          }
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                          Colors.grey.withOpacity(0.8),
                        ),
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
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(
                        Colors.grey.withOpacity(0.8),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(width: 1, color: Colors.grey),
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
                        "Trở về trang đăng nhập",
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
}
