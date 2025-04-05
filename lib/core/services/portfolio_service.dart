import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio_core/models/project.dart';
import 'package:portfolio_core/models/skill.dart';
import 'package:portfolio_core/models/user_info.dart';

class PortfolioService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _userInfoDocId =
      'main'; // Assuming a single document for user info

  // --- UserInfo Methods ---
  // Project and Skill methods removed as data is now loaded from JSON

  // Fetches user info from the 'userInfo' collection
  // Assumes a single document with a fixed ID (_userInfoDocId)
  Future<UserInfo?> getUserInfo() async {
    // Changed return type and name
    try {
      final doc =
          await _firestore.collection('userInfo').doc(_userInfoDocId).get();
      if (doc.exists) {
        return UserInfo.fromFirestore(doc); // Use UserInfo model
      } else {
        print('User info document ($_userInfoDocId) not found.');
        // Create a default user info document if not found
        await ensureUserInfoDefaults();
        // Try to fetch it again
        final newDoc =
            await _firestore.collection('userInfo').doc(_userInfoDocId).get();
        if (newDoc.exists) {
          return UserInfo.fromFirestore(newDoc);
        }
        return null;
      }
    } catch (e) {
      print('Error fetching user info: $e');
      return null; // Return null on error
    }
  }

  // Updates the user info document
  // Creates the document if it doesn't exist (upsert)
  Future<void> updateUserInfo(UserInfo userInfo) async {
    try {
      // Use set with merge: true to create or update
      await _firestore
          .collection('userInfo')
          .doc(_userInfoDocId)
          .set(userInfo.toJson(), SetOptions(merge: true));
    } catch (e) {
      print('Error updating user info: $e');
    }
  }

  // --- Default Value Methods ---

  // Ensures that all collections have documents with default values
  // Removed ensureProjectsDefaults and ensureSkillsDefaults
  Future<void> ensureDefaultValues() async {
    await ensureUserInfoDefaults();
    // await ensureProjectsDefaults(); // Removed
    // await ensureSkillsDefaults(); // Removed
  }

  // Ensures UserInfo has default values if it doesn't exist or has null fields
  Future<void> ensureUserInfoDefaults() async {
    try {
      final docRef = _firestore.collection('userInfo').doc(_userInfoDocId);
      final doc = await docRef.get();

      if (!doc.exists) {
        // Create default UserInfo document if it doesn't exist
        final defaultUserInfo = UserInfo(
          id: _userInfoDocId,
          name: 'Your Name',
          title: 'Web Developer',
          bio: 'Enter your bio here...',
          profilePictureUrl: 'https://via.placeholder.com/150',
          contactEmail: 'your.email@example.com',
          linkedinUrl: 'https://linkedin.com/in/yourprofile',
          githubUrl: 'https://github.com/yourusername',
        );

        await docRef.set(defaultUserInfo.toJson());
        print('Created default UserInfo document');
      } else {
        // Check for null fields and update with defaults if needed
        final data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          final updates = <String, dynamic>{};

          if (data['name'] == null) updates['name'] = 'Your Name';
          if (data['title'] == null) updates['title'] = 'Web Developer';
          if (data['bio'] == null) updates['bio'] = 'Enter your bio here...';
          if (data['profilePictureUrl'] == null)
            updates['profilePictureUrl'] = 'https://via.placeholder.com/150';
          if (data['contactEmail'] == null)
            updates['contactEmail'] = 'your.email@example.com';

          if (updates.isNotEmpty) {
            await docRef.set(updates, SetOptions(merge: true));
            print('Updated UserInfo with default values for null fields');
          }
        }
      }
    } catch (e) {
      print('Error ensuring UserInfo defaults: $e');
    }
  }

  // Removed ensureProjectsDefaults()
  // Removed ensureSkillsDefaults()

  // Deprecated: Use getUserInfo() which returns UserInfo?
  // Fetches personal info from the 'personal_info' collection, assuming a single document (e.g., 'main')
  // Future<Map<String, dynamic>> getPersonalInfo() async {
  //   try {
  //     // Assuming a single document holds the personal info, e.g., with ID 'main'
  //     // Adjust 'main' if your document ID is different (e.g., user ID)
  //     final doc =
  //         await _firestore.collection('personal_info').doc('main').get();
  //     if (doc.exists) {
  //       return doc.data() ?? {};
  //     } else {
  //       print('Personal info document not found.');
  //       return {}; // Return empty map if document doesn't exist
  //     }
  //   } catch (e) {
  //     print('Error fetching personal info: $e');
  //     // Consider more robust error handling/logging
  //     return {}; // Return empty map on error
  //   }
  // }
}
