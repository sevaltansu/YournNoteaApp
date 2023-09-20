import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LogOutDialog extends StatefulWidget {
  const LogOutDialog({Key? key}) : super(key: key);

  @override
  State<LogOutDialog> createState() => _LogOutDialogState();
}

class _LogOutDialogState extends State<LogOutDialog> {
  final FirebaseAuth firebaseAuth =
      FirebaseAuth.instance; // firebaseAuth tanımı eklenmiş
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(
        "Çıkış Yap",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black87, fontSize: 16),
      ),
      content: SizedBox(
        child: Form(
          child: Column(
            children: [
              Text(
                "Çıkış yapmak istediğine emin misin?",
                style: TextStyle(color: Colors.black87, fontSize: 14),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          style: ElevatedButton.styleFrom(primary: Colors.grey),
          child: Text("Vazgeç"),
        ),
        ElevatedButton(
            onPressed: () {
              signOut();

              Navigator.of(context, rootNavigator: true).pop();
            },
            style: ElevatedButton.styleFrom(primary: Colors.grey[900]),
            child: Text('Çıkış Yap'))
      ],
    );
  }

  void signOut() async {
    try {
      await firebaseAuth.signOut();
      Fluttertoast.showToast(
        msg: "Çıkış yapıldı",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.pushReplacementNamed(context,
          "/loginPage"); // Çıkış yaptıktan sonra giriş sayfasına yönlendirin
    } catch (e) {
      print(e.toString());
    }
  }
}
