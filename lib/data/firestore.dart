// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:play_store/model/notes_model.dart';
import 'package:uuid/uuid.dart';

class Firestore_Datasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> CreateUser(String mailcontroller) async {
    try {
      await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .set({"id": _auth.currentUser!.uid, "email": mailcontroller});
      return true;
    } catch (e) {
      return true;
    }
  }

  Future<bool> AddNote(String subtitle, String title, int image) async {
    try {
      var uuid = const Uuid().v4();
      DateTime now = DateTime.now();
      DateTime istTime = now.toUtc().add(const Duration(hours: 5, minutes: 30));

      // Format the IST time
      String formattedISTTime = DateFormat('dd-MM-2023').format(istTime);

      await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .set({
        'id': uuid,
        'subtitle': subtitle,
        'isDon': false,
        'image': image,
        'time': formattedISTTime.toString(),
        'title': title,
      });
      return true;
    } catch (e) {
      print('Error adding note: $e');
      return false;
    }
  }


  List getNotes(AsyncSnapshot snapshot) {
    try {
      final notesList = snapshot.data!.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Note(
          data['id'],
          data['subtitle'],
          data['time'].toString(),
          data['image'],
          data['title'],
          data['isDon'],
        );
      }).toList();
      return notesList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Stream<QuerySnapshot> stream(bool isDone) {
    return _firestore
        .collection('Users')
        .doc(_auth.currentUser!.uid)
        .collection('notes').where('isDon', isEqualTo: isDone)
        .snapshots();
  }

  Future<bool> isdone(String uuid, bool isDon) async{
    try{
      await _firestore.collection('Users').doc(_auth.currentUser!.uid).collection('notes').doc(uuid).update({
        'isDon': isDon,
      });
      return true;
    }
    catch(e){
      print(e);
      return false;
    }
  }

  Future<void> UpdateNote(String id, int image, String title, String subtitle) async {
    try {
      DateTime now = DateTime.now();
      DateTime istTime = now.toUtc().add(const Duration(hours: 5, minutes: 30));

      // Format the IST time
      String formattedISTTime = DateFormat('dd-MM-2023').format(istTime);

      await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(id)
          .update({
        'image': image,
        'title': title,
        'subtitle': subtitle,
        'time': formattedISTTime,
      });
    } catch (e) {
      print(e);
    }
  }


  Future<bool> delete_note(String uuid) async{
    try{
      await _firestore.collection('Users').doc(_auth.currentUser!.uid).collection('notes').doc(uuid).delete();
      return true;
    }
    catch (e) {
      print(e);
      return true;
    }
  }

}
