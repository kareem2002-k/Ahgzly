// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';

class Court {
  String id; // Document ID
  String name;
  String location;
  String courtType;
  GeoPoint map;

  Court({
    required this.id, // Include ID in the constructor
    required this.name,
    required this.location,
    required this.courtType,
    required this.map,
  });
}
