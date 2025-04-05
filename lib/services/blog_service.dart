import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portfolio_core/models/blog_post.dart';
import 'package:portfolio_core/services/auth_service.dart';

class BlogService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService;

  BlogService(this._authService);

  // Get a reference to the 'posts' collection
  CollectionReference<BlogPost> get _postsCollection =>
      _firestore.collection('posts').withConverter<BlogPost>(
            fromFirestore: (snapshots, _) => BlogPost.fromFirestore(snapshots),
            toFirestore: (blogPost, _) => blogPost.toFirestore(),
          );

  // Stream of all posts, ordered by creation date descending
  Stream<List<BlogPost>> getPostsStream() {
    return _postsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // Fetch a single post by ID
  Future<BlogPost?> getPostById(String id) async {
    try {
      final snapshot = await _postsCollection.doc(id).get();
      if (snapshot.exists) {
        return snapshot.data();
      } else {
        return null; // Post not found
      }
    } catch (e) {
      throw Exception('Failed to load post $id. Error: ${e.toString()}');
    }
  }

  // Create a new post
  Future<DocumentReference<BlogPost>> createPost(
      String title, String markdownContent) async {
    final user = _authService.currentUser;
    if (user == null) {
      throw Exception('Authentication required to create post.');
    }
    try {
      // Create a map of data for the new post
      final postData = {
        'title': title,
        'markdownContent': markdownContent,
        'authorId': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Add the document to the collection
      final docRef = await _firestore.collection('posts').add(postData);

      // Return the document reference with the correct type
      return _postsCollection.doc(docRef.id);
    } catch (e) {
      throw Exception('Failed to create post. Error: ${e.toString()}');
    }
  }

  // Update an existing post
  Future<void> updatePost(
      String id, String title, String markdownContent) async {
    final user = _authService.currentUser;
    if (user == null) {
      throw Exception('Authentication required to update post.');
    }
    // Check if the current user is the author before allowing update
    final post = await getPostById(id);
    if (post == null) {
      throw Exception('Post with ID $id not found.');
    }
    if (post.authorId != user.uid) {
      throw Exception('User not authorized to update this post.');
    }

    try {
      // Prepare data for update, ensuring updatedAt is set by the server
      final updateData = {
        'title': title,
        'markdownContent': markdownContent,
        'updatedAt': FieldValue.serverTimestamp(),
        // Do not update authorId or createdAt
      };
      await _postsCollection.doc(id).update(updateData);
    } catch (e) {
      throw Exception('Failed to update post $id. Error: ${e.toString()}');
    }
  }

  // Delete a post
  Future<void> deletePost(String id) async {
    final user = _authService.currentUser;
    if (user == null) {
      throw Exception('Authentication required to delete post.');
    }
    // Check if the current user is the author before allowing delete
    final post = await getPostById(id);
    if (post == null) {
      throw Exception('Post with ID $id not found.');
    }
    if (post.authorId != user.uid) {
      throw Exception('User not authorized to delete this post.');
    }

    try {
      await _postsCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete post $id. Error: ${e.toString()}');
    }
  }
}
