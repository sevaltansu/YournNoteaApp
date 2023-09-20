import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddNote extends StatelessWidget {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade900,
        appBar: AppBar(
          title: Text("NOTUNU EKLE"),
          backgroundColor: Colors.transparent,
          actions: [
            TextButton(
              onPressed: () async {
                await saveNote();
                Navigator.pop(context);
              },
              child: Icon(
                Icons.save,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: title,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 15),
                    hintText: "Başlık",
                  ),
                ),
              ),
              SizedBox(
                height: 13,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: content,
                      maxLines: null,
                      expands: true,
                      decoration: InputDecoration(
                          hintText: "Notun",
                          contentPadding: EdgeInsets.only(left: 8)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 13,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveNote() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userUid = user.uid;

        // Kullanıcının notlar koleksiyonunu oluşturun
        final userNotesCollection = FirebaseFirestore.instance
            .collection('users') // Ana koleksiyon: users
            .doc(userUid) // Belirli kullanıcının dokümanı
            .collection('notes'); // Alt koleksiyon: notes

        // Notun verileri
        final noteData = {
          'title': title.text, // Başlık
          'content': content.text, // İçerik
        };

        // Notu eklemek için kullanıcı notlar koleksiyonu
        await userNotesCollection.add(noteData);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
