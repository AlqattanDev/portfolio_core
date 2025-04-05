import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio_core/models/project.dart';
import 'package:portfolio_core/models/skill.dart';
import 'package:portfolio_core/models/user_info.dart';

class PortfolioService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _userInfoDocId =
      'main'; // Assuming a single document for user info

  // --- Project Methods ---

  // Fetches projects from the 'projects' collection
  Future<List<Project>> getProjects() async {
    try {
      final snapshot = await _firestore
          .collection('projects')
          .orderBy('order', descending: false)
          .get();
      return snapshot.docs.map((doc) => Project.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching projects: $e');
      return [];
    }
  }

  // Adds a new project
  Future<DocumentReference?> addProject(Project project) async {
    try {
      // Add the project data (excluding ID) to Firestore
      return await _firestore.collection('projects').add(project.toFirestore());
    } catch (e) {
      print('Error adding project: $e');
      return null;
    }
  }

  // Updates an existing project
  Future<void> updateProject(Project project) async {
    if (project.id == null) {
      print('Error updating project: Project ID is null.');
      return;
    }
    try {
      await _firestore
          .collection('projects')
          .doc(project.id)
          .update(project.toFirestore());
    } catch (e) {
      print('Error updating project ${project.id}: $e');
    }
  }

  // Deletes a project
  Future<void> deleteProject(String projectId) async {
    try {
      await _firestore.collection('projects').doc(projectId).delete();
    } catch (e) {
      print('Error deleting project $projectId: $e');
    }
  }

  // --- Skill Methods ---

  // Fetches skills from the 'skills' collection
  Future<List<Skill>> getSkills() async {
    try {
      final snapshot = await _firestore
          .collection('skills')
          .orderBy('level', descending: true) // Example sorting
          .get();
      return snapshot.docs.map((doc) => Skill.fromFirestore(doc)).toList();
    } catch (e) {
      print('Error fetching skills: $e');
      return [];
    }
  }

  // Adds a new skill
  Future<DocumentReference?> addSkill(Skill skill) async {
    try {
      return await _firestore.collection('skills').add(skill.toFirestore());
    } catch (e) {
      print('Error adding skill: $e');
      return null;
    }
  }

  // Updates an existing skill
  Future<void> updateSkill(Skill skill) async {
    if (skill.id == null) {
      print('Error updating skill: Skill ID is null.');
      return;
    }
    try {
      await _firestore
          .collection('skills')
          .doc(skill.id)
          .update(skill.toFirestore());
    } catch (e) {
      print('Error updating skill ${skill.id}: $e');
    }
  }

  // Deletes a skill
  Future<void> deleteSkill(String skillId) async {
    try {
      await _firestore.collection('skills').doc(skillId).delete();
    } catch (e) {
      print('Error deleting skill $skillId: $e');
    }
  }

  // --- UserInfo Methods ---

  // Fetches personal info from the 'userInfo' collection
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
  Future<void> ensureDefaultValues() async {
    await ensureUserInfoDefaults();
    await ensureProjectsDefaults();
    await ensureSkillsDefaults();
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

  // Ensures Projects collection has some default projects if empty
  Future<void> ensureProjectsDefaults() async {
    try {
      final collection = _firestore.collection('projects');
      final snapshot = await collection.limit(1).get();

      if (snapshot.docs.isEmpty) {
        // Collection is empty, add a default project
        final defaultProject = Project(
          id: 'sample-project',
          title: 'Sample Project',
          description:
              'This is a sample project. Replace with your own projects.',
          technologies: ['Flutter', 'Firebase', 'Dart'],
          imageUrl: 'https://via.placeholder.com/300x200',
          githubUrl: 'https://github.com/yourusername/sample-project',
          liveUrl: 'https://your-sample-project.web.app',
        );

        await collection.doc('sample-project').set({
          'title': defaultProject.title,
          'description': defaultProject.description,
          'technologies': defaultProject.technologies,
          'imageUrl': defaultProject.imageUrl,
          'githubUrl': defaultProject.githubUrl,
          'liveUrl': defaultProject.liveUrl,
          'order': 1,
        });
        print('Created default Project document');
      } else {
        // For each project, check for null fields
        for (final doc in (await collection.get()).docs) {
          final data = doc.data();
          final updates = <String, dynamic>{};

          if (data['title'] == null) updates['title'] = 'Untitled Project';
          if (data['description'] == null)
            updates['description'] = 'No description provided';
          if (data['technologies'] == null)
            updates['technologies'] = ['No technologies specified'];
          if (data['imageUrl'] == null)
            updates['imageUrl'] = 'https://via.placeholder.com/300x200';
          if (data['order'] == null) updates['order'] = 999; // Default order

          if (updates.isNotEmpty) {
            await doc.reference.set(updates, SetOptions(merge: true));
            print('Updated Project ${doc.id} with default values');
          }
        }
      }
    } catch (e) {
      print('Error ensuring Projects defaults: $e');
    }
  }

  // Ensures Skills collection has some default skills if empty
  Future<void> ensureSkillsDefaults() async {
    try {
      final collection = _firestore.collection('skills');
      final snapshot = await collection.limit(1).get();

      if (snapshot.docs.isEmpty) {
        // Collection is empty, add some default skills
        final defaultSkills = [
          {'id': 'skill1', 'name': 'Flutter', 'level': 80},
          {'id': 'skill2', 'name': 'Firebase', 'level': 75},
          {'id': 'skill3', 'name': 'Dart', 'level': 85},
        ];

        for (final skill in defaultSkills) {
          await collection.doc(skill['id'] as String).set({
            'name': skill['name'],
            'level': skill['level'],
          });
        }
        print('Created default Skill documents');
      } else {
        // For each skill, check for null fields
        for (final doc in (await collection.get()).docs) {
          final data = doc.data();
          final updates = <String, dynamic>{};

          if (data['name'] == null) updates['name'] = 'Unnamed Skill';
          if (data['level'] == null) updates['level'] = 50; // Default mid-level

          if (updates.isNotEmpty) {
            await doc.reference.set(updates, SetOptions(merge: true));
            print('Updated Skill ${doc.id} with default values');
          }
        }
      }
    } catch (e) {
      print('Error ensuring Skills defaults: $e');
    }
  }

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
