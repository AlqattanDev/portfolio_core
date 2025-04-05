import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfo {
  final String? id;
  final String name;
  final String title;
  final String bio;
  final String profilePictureUrl;
  final String contactEmail;
  final String? linkedinUrl;
  final String? githubUrl;

  UserInfo({
    this.id,
    required this.name,
    required this.title,
    required this.bio,
    required this.profilePictureUrl,
    required this.contactEmail,
    this.linkedinUrl,
    this.githubUrl,
  });

  factory UserInfo.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserInfo(
      id: doc.id,
      name: data['name'] ?? '',
      title: data['title'] ?? '',
      bio: data['bio'] ?? '',
      profilePictureUrl: data['profilePictureUrl'] ?? '',
      contactEmail: data['contactEmail'] ?? '',
      linkedinUrl: data['linkedinUrl'],
      githubUrl: data['githubUrl'],
    );
  }

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      bio: json['bio'] ?? '',
      profilePictureUrl: json['profilePictureUrl'] ?? '',
      contactEmail: json['contactEmail'] ?? '',
      linkedinUrl: json['linkedinUrl'],
      githubUrl: json['githubUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name.isEmpty ? 'Your Name' : name,
      'title': title.isEmpty ? 'Web Developer' : title,
      'bio': bio.isEmpty ? 'Enter your bio here...' : bio,
      'profilePictureUrl': profilePictureUrl.isEmpty
          ? 'https://via.placeholder.com/150'
          : profilePictureUrl,
      'contactEmail':
          contactEmail.isEmpty ? 'your.email@example.com' : contactEmail,
      'linkedinUrl': linkedinUrl?.isEmpty ?? true ? null : linkedinUrl,
      'githubUrl': githubUrl?.isEmpty ?? true ? null : githubUrl,
    };
  }
}
