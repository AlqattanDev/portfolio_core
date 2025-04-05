import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class BlogPost {
  final String id; // Firestore document ID
  final String title;
  final String markdownContent;
  final Timestamp createdAt; // Use Firestore Timestamp
  final Timestamp updatedAt; // Use Firestore Timestamp
  final String? authorId; // Optional: Link to author (Firebase User UID)

  BlogPost({
    required this.id,
    required this.title,
    required this.markdownContent,
    required this.createdAt,
    required this.updatedAt,
    this.authorId,
  });

  // Factory constructor to create a BlogPost from a Firestore DocumentSnapshot
  factory BlogPost.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) {
      throw StateError('Missing data for BlogPost ${snapshot.id}');
    }

    // Basic validation/type checking
    final title = data['title'] as String?;
    final markdownContent = data['markdownContent'] as String?;
    final createdAt = data['createdAt'] as Timestamp?;
    final updatedAt = data['updatedAt'] as Timestamp?;
    final authorId = data['authorId'] as String?;

    if (title == null ||
        markdownContent == null ||
        createdAt == null ||
        updatedAt == null) {
      throw StateError('Missing required fields for BlogPost ${snapshot.id}');
    }

    return BlogPost(
      id: snapshot.id, // Use the document ID
      title: title,
      markdownContent: markdownContent,
      createdAt: createdAt,
      updatedAt: updatedAt,
      authorId: authorId,
    );
  }

  // Method to convert BlogPost instance to a Map for Firestore
  // Note: We don't include 'id' here as it's the document ID.
  Map<String, dynamic> toFirestore() {
    final data = {
      'title': title.isEmpty ? 'Untitled Post' : title,
      'markdownContent':
          markdownContent.isEmpty ? 'No content yet...' : markdownContent,
      'updatedAt': FieldValue.serverTimestamp(),
      'authorId': authorId?.isEmpty ?? true ? null : authorId,
    };

    // Don't override createdAt for existing documents
    // This preserves the original timestamp
    if (createdAt == Timestamp(0, 0)) {
      data['createdAt'] = FieldValue.serverTimestamp();
    }

    return data;
  }

  // Deprecated methods removed. Use fromFirestore and toFirestore.
}
