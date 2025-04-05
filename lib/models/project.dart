import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  final String id; // Firestore document ID
  final String title;
  final String description;
  final List<String> technologies;
  final String imageUrl;
  final String? githubUrl;
  final String? liveUrl;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.technologies,
    required this.imageUrl,
    this.githubUrl,
    this.liveUrl,
  });

  // Factory constructor to create a Project from a Firestore DocumentSnapshot
  factory Project.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) {
      throw StateError('Missing data for Project ${snapshot.id}');
    }

    // Basic validation/type checking
    final title = data['title'] as String?;
    final description = data['description'] as String?;
    final technologies = (data['technologies'] as List<dynamic>?)
        ?.map((tech) => tech as String)
        .toList();
    final imageUrl = data['imageUrl'] as String?;
    final githubUrl = data['githubUrl'] as String?; // Optional
    final liveUrl = data['liveUrl'] as String?; // Optional

    if (title == null ||
        description == null ||
        technologies == null ||
        imageUrl == null) {
      throw StateError('Missing required fields for Project ${snapshot.id}');
    }

    return Project(
      id: snapshot.id, // Use the document ID
      title: title,
      description: description,
      technologies: technologies,
      imageUrl: imageUrl,
      githubUrl: githubUrl,
      liveUrl: liveUrl,
    );
  }

  // Method to convert Project instance to a Map for Firestore
  // Note: We don't include 'id' here as it's the document ID.
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'technologies':
          technologies.isEmpty ? ['No technologies specified'] : technologies,
      'imageUrl':
          imageUrl.isEmpty ? 'https://via.placeholder.com/300x200' : imageUrl,
      'githubUrl': githubUrl?.isEmpty ?? true ? null : githubUrl,
      'liveUrl': liveUrl?.isEmpty ?? true ? null : liveUrl,
      // Consider adding timestamps if needed (e.g., 'createdAt', 'updatedAt')
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
