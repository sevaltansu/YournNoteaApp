import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:note_uyg/screens/add_note.dart';
import 'package:note_uyg/utils/colors.dart';
import 'package:note_uyg/screens/edit_note.dart';
import 'package:note_uyg/screens/log_out.dart';

import '../screens/delete_note.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Random _random = Random();
  final FirebaseAuth firebaseAuth =
      FirebaseAuth.instance; // firebaseAuth tanımı eklenmiş

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "YourNotes",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 25),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LogOutDialog()),
                );
                print("tıklandı");
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
            )
          ],
        ),
        backgroundColor: Colors.grey.shade900,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("text");
          Navigator.push(context, MaterialPageRoute(builder: (_) => AddNote()));
        },
        backgroundColor: Colors.blueGrey,
        child: Icon(
          CupertinoIcons.pencil,
          size: 40,
        ),
        mini: false,
        elevation: 9.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.0)),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: getNotesStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); //yükleme süreci
            }
            if (snapshot.hasError) {
              return Text("Hata: ${snapshot.error}");
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  "Henüz hiç not eklenmemiş",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            // Firestore'dan gelen notları burada listeleyebilirsiniz.
            final notes = snapshot.data!.docs;

            return ListView.builder(
                itemCount: notes.length,
                itemBuilder: (_, index) {
                  final noteData = notes[index].data() as Map<String, dynamic>;
                  final title = noteData['title'] ?? '';
                  final content = noteData['content'] ?? '';

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => EditNote(
                                  noteId: notes[index].id ?? '',
                                  initialTitle: title,
                                  initialContent: content,
                                )),
                      ).then((result) {
                        if (result != null) {
                          // Geri dönüş değeri mevcutsa, ana sayfada verileri güncelle
                          setState(() {
                            title.text = result["title"];
                            content.text = result["content"];
                          });
                        }
                      });
                    },
                    child: Card(
                      color: getRandomColor(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        title: Text(
                          title,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              height: 1.5),
                        ),
                        subtitle: Text(
                          content,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                              height: 1.5),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DeleteNote(
                                  noteId: notes[index].id,
                                ),
                              ),
                            );
                            print("silindi");
                          },
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }

  Stream<QuerySnapshot> getNotesStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userUid = user.uid;
      final userNotesCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .collection('notes');
      return userNotesCollection.snapshots();
    }
    return Stream.empty();
  }
}
