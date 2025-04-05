import 'package:cloud_firestore/cloud_firestore.dart';

class Skill {
  // Consider adding an 'id' field if Skills will be stored as top-level documents
  final String id;
  final String name;
  final int level; // 0 to 100

  Skill({
    required this.id,
    required this.name,
    required this.level,
  });

  // Factory constructor to create a Skill from a Firestore DocumentSnapshot
  // Assumes Skill data is stored within another document or as a top-level doc
  factory Skill.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) {
      throw StateError('Missing data for Skill ${snapshot.id}');
    }

    final name = data['name'] as String?;
    final levelData = data['level'] as num?; // Can be int or double

    if (name == null || levelData == null) {
      throw StateError('Missing required fields for Skill ${snapshot.id}');
    }

    int level;
    if (levelData is double) {
      // Assume existing data is double 0.0-1.0, convert to int 0-100
      level = (levelData * 100).round();
    } else if (levelData is int) {
      // Assume new or migrated data is int 0-100
      level = levelData;
    } else {
      throw StateError(
          'Invalid type for Skill level for ${snapshot.id}: ${levelData.runtimeType}');
    }

    if (level < 0 || level > 100) {
      throw StateError(
          'Skill level must be between 0 and 100 for ${snapshot.id}, found: $level');
    }

    return Skill(
      id: snapshot.id,
      name: name,
      level: level,
    );
  }

  // Factory constructor to create a Skill from a Map (e.g., from a List field in Firestore)
  factory Skill.fromMap(Map<String, dynamic> map) {
    final name = map['name'] as String?;
    final levelData = map['level'] as num?; // Can be int or double

    if (name == null || levelData == null) {
      throw StateError('Missing required fields for Skill in map');
    }

    int level;
    if (levelData is double) {
      // Assume existing data is double 0.0-1.0, convert to int 0-100
      level = (levelData * 100).round();
    } else if (levelData is int) {
      // Assume new or migrated data is int 0-100
      level = levelData;
    } else {
      throw StateError(
          'Invalid type for Skill level in map: ${levelData.runtimeType}');
    }

    if (level < 0 || level > 100) {
      throw StateError('Skill level must be between 0 and 100, found: $level');
    }

    return Skill(
      id: map['id'],
      name: name,
      level: level,
    );
  }

  // Method to convert Skill instance to a Map for Firestore
  // Note: We don't include 'id' here assuming it might be part of a list/subcollection
  Map<String, dynamic> toFirestore() {
    return {
      'name': name.isEmpty ? 'Unnamed Skill' : name,
      'level': level < 0 || level > 100
          ? 50
          : level, // Constrain level between 0-100
    };
  }
}
