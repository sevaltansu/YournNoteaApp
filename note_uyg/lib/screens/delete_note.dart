import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DeleteNote extends StatefulWidget {
  final String noteId;
  const DeleteNote({Key? key, required this.noteId}) : super(key: key);

  @override
  State<DeleteNote> createState() => _DeleteNoteState();
}

class _DeleteNoteState extends State<DeleteNote> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(
        "Notu Sil",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black87, fontSize: 16),
      ),
      content: SizedBox(
        child: Form(
          child: Column(
            children: [
              Text(
                "Bu notu silmek istediğine emin misin?",
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
              deleteNote(widget.noteId);

              Navigator.of(context, rootNavigator: true).pop();
            },
            style: ElevatedButton.styleFrom(primary: Colors.grey[900]),
            child: Text('Sil'))
      ],
    );
  }

  Future<void> deleteNote(String noteId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userUid = user.uid;

      // Kullanıcının notlar koleksiyonuna erişin
      final userNotesCollection = FirebaseFirestore.instance
          .collection('users') // Ana koleksiyon: users
          .doc(userUid) // Belirli kullanıcının dokümanı
          .collection('notes'); // Alt koleksiyon: notes

      // Notu belirtilen kimlikle silin
      await userNotesCollection
          .doc(noteId)
          .delete()
          .then((_) => Fluttertoast.showToast(
              msg: "Notun Silindi!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              backgroundColor: Colors.grey.shade500,
              fontSize: 14))
          .catchError(() => Fluttertoast.showToast(
              msg: "HATA!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.SNACKBAR,
              backgroundColor: Colors.white,
              fontSize: 14));
    }
  }
}
