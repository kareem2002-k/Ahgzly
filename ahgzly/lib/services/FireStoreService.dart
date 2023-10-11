// ignore: file_names
import 'package:ahgzly/models/Court.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  // Get courts depending on court type
  Future<List<Court>> getCourts(String courtType) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('courts')
        .where('courtType', isEqualTo: courtType)
        .get();

    // Create a list of Court objects with document ID
    final List<Court> courts = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return Court(
        id: data['id'],
        name: data['name'],
        location: data['location'],
        courtType: data['courtType'],
        map: data['map'],
      );
    }).toList();

    if (kDebugMode) {
      print(snapshot.docs[0].data());
    }

    return courts;
  }
}
