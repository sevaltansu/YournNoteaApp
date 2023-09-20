import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                  Icons.lock,
                  size: 100,
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
                signInButton(),
                SizedBox(
                  height: 8,
                ),
                signUpButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextButton signUpButton() {
    return TextButton(
        onPressed: () {
          Navigator.pushNamed(context, "/signUp");
        },
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

  TextButton signInButton() {
    return TextButton(
        onPressed: signIn,
        child: Container(
          padding: EdgeInsets.all(25),
          margin: EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              "Giriş Yap",
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
        final userResult = await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        final userCollection = FirebaseFirestore.instance.collection('users');
        final userUid = userResult.user!.uid;
        final userDocument = userCollection.doc(userUid);

        await userDocument.set({
          'email': email, // Örnek olarak e-posta bilgisini saklayabilirsiniz
        });
        final userNotesCollection = userDocument.collection('notes');

        Navigator.pushReplacementNamed(context, "/homePage");
        print(userResult.user!.email);
      } catch (e) {
        print(e.toString());
      }
    }
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
