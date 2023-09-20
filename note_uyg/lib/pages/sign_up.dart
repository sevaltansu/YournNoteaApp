import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final firebaseAuth = FirebaseAuth.instance;
  late String email = "";
  late String password = "";
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Icon(
                  Icons.app_registration,
                  size: 150,
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Hoşgeldin! Notlarını Görmek İçin Giriş yap.",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
                SizedBox(
                  height: 50,
                ),
                emailCont(),
                SizedBox(
                  height: 10,
                ),
                passwordCont(),
                SizedBox(
                  height: 15,
                ),
                signUpButton(),
                Center(
                    child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/loginPage");
                        },
                        child: Text(
                          'Giriş Sayfasına Geri Dön',
                          style: TextStyle(color: Colors.black),
                        ))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextButton signUpButton() {
    return TextButton(
        onPressed: signIn,
        child: Container(
          padding: EdgeInsets.all(25),
          margin: EdgeInsets.symmetric(horizontal: 50),
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              "Hesap OLuştur",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }

  void signIn() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      try {
        var userResult = await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        formKey.currentState!.reset();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Hesabınız Oluşturuldu,Giriş Sayfasına Yönlendiriliyorsunuz"),
          ),
        );
        Navigator.pushReplacementNamed(context, "/loginPage");
      } catch (e) {
        print(e.toString());
      }
    } else {}
  }

  Padding passwordCont() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            filled: true,
            hintText: "Şifre",
            hintStyle: TextStyle(color: Colors.grey.shade500),
            fillColor: Colors.grey.shade200,
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return "Bilgileri Eksiksiz Doldurun";
            } else {}
          },
          onSaved: (value) {
            password = value!;
          }),
    );
  }

  Padding emailCont() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        obscureText: false,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          filled: true,
          hintText: "Kullanıcı Adı",
          hintStyle: TextStyle(color: Colors.grey.shade500),
          fillColor: Colors.grey.shade200,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return "Bilgileri Eksiksiz Doldurun";
          } else {}
        },
        onSaved: (value) {
          email = value!;
        },
      ),
    );
  }
}
