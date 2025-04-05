import 'package:cloud_firestore/cloud_firestore.dart';

class Skill {
  // Consider adding an 'id' field if Skills will be stored as top-level documents
  // final String id;
  final String name;
  final double level; // 0.0 to 1.0

  Skill({
    required this.name,
    required this.level,
    // required this.id, // Uncomment if using top-level documents
  });

  // Factory constructor to create a Skill from a Firestore DocumentSnapshot
  // Assumes Skill data is stored within another document or as a top-level doc
  factory Skill.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) {
      throw StateError('Missing data for Skill ${snapshot.id}');
    }

    final name = data['name'] as String?;
    final level = (data['level'] as num?)?.toDouble(); // Handle int or double

    if (name == null || level == null) {
      throw StateError('Missing required fields for Skill ${snapshot.id}');
    }
    if (level < 0.0 || level > 1.0) {
      throw StateError(
          'Skill level must be between 0.0 and 1.0 for ${snapshot.id}');
    }

    return Skill(
      // id: snapshot.id, // Use if storing as top-level documents
      name: name,
      level: level,
    );
  }

  // Factory constructor to create a Skill from a Map (e.g., from a List field in Firestore)
  factory Skill.fromMap(Map<String, dynamic> map) {
    final name = map['name'] as String?;
    final level = (map['level'] as num?)?.toDouble(); // Handle int or double

    if (name == null || level == null) {
      throw StateError('Missing required fields for Skill in map');
    }
    if (level < 0.0 || level > 1.0) {
      throw StateError('Skill level must be between 0.0 and 1.0');
    }

    return Skill(
      name: name,
      level: level,
    );
  }

  // Method to convert Skill instance to a Map for Firestore
  // Note: We don't include 'id' here assuming it might be part of a list/subcollection
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'level': level,
    };
  }
}
