This file is a merged representation of the entire codebase, combined into a single document by Repomix.

# File Summary

## Purpose
This file contains a packed representation of the entire repository's contents.
It is designed to be easily consumable by AI systems for analysis, code review,
or other automated processes.

## File Format
The content is organized as follows:
1. This summary section
2. Repository information
3. Directory structure
4. Multiple file entries, each consisting of:
  a. A header with the file path (## File: path/to/file)
  b. The full contents of the file in a code block

## Usage Guidelines
- This file should be treated as read-only. Any changes should be made to the
  original repository files, not this packed version.
- When processing this file, use the file path to distinguish
  between different files in the repository.
- Be aware that this file may contain sensitive information. Handle it with
  the same level of security as you would the original repository.

## Notes
- Some files may have been excluded based on .gitignore rules and Repomix's configuration
- Binary files are not included in this packed representation. Please refer to the Repository Structure section for a complete list of file paths, including binary files
- Files matching patterns in .gitignore are excluded
- Files matching default ignore patterns are excluded
- Files are sorted by Git change count (files with more changes are at the bottom)

## Additional Info

# Directory Structure
```
dataconnect/
  connector/
    connector.yaml
    mutations.gql
    queries.gql
  schema/
    schema.gql
  dataconnect.yaml
dataconnect-generated/
  dart/
    default_connector/
      default.dart
      README.md
functions/
  src/
    genkit-sample.ts
    index.ts
  package.json
  tsconfig.dev.json
  tsconfig.json
lib/
  data/
    services/
      auth_service.dart
      blog_service.dart
    portfolio_data.dart
  models/
    blog_post.dart
    project.dart
    skill.dart
  screens/
    auth/
      login_screen.dart
    blog/
      blog_list_screen.dart
      blog_post_edit_screen.dart
      blog_post_view_screen.dart
    tabbed_portfolio_screen.dart
  services/
    url_launcher_service.dart
  theme/
    simplified_theme.dart
  widgets/
    common/
      contact_info_item.dart
      portfolio_tab_view.dart
      skill_progress_bar.dart
    markdown/
      markdown_edit_view.dart
      markdown_preview_view.dart
    tabs/
      about_tab.dart
      contact_tab.dart
      home_tab.dart
      projects_tab.dart
      skills_tab.dart
    markdown_editor.dart
    project_card.dart
  firebase_options.dart
  main.dart
web/
  index.html
  manifest.json
analysis_options.yaml
apphosting.yaml
firebase.json
firestore.indexes.json
firestore.rules
pubspec.lock
pubspec.yaml
README.md
```

# Files

## File: dataconnect/connector/connector.yaml
````yaml
connectorId: default
generate:
  dartSdk:
    outputDir: ../../dataconnect-generated/dart/default_connector
    package: default_connector
````

## File: dataconnect/connector/mutations.gql
````graphql
# # Example mutations for a simple movie app

# # Create a movie based on user input
# mutation CreateMovie($title: String!, $genre: String!, $imageUrl: String!)
# @auth(level: USER_EMAIL_VERIFIED) {
#   movie_insert(data: { title: $title, genre: $genre, imageUrl: $imageUrl })
# }

# # Upsert (update or insert) a user's username based on their auth.uid
# mutation UpsertUser($username: String!) @auth(level: USER) {
#   # The "auth.uid" server value ensures that users can only register their own user.
#   user_upsert(data: { id_expr: "auth.uid", username: $username })
# }

# # Add a review for a movie
# mutation AddReview($movieId: UUID!, $rating: Int!, $reviewText: String!)
# @auth(level: USER) {
#   review_upsert(
#     data: {
#       userId_expr: "auth.uid"
#       movieId: $movieId
#       rating: $rating
#       reviewText: $reviewText
#       # reviewDate defaults to today in the schema. No need to set it manually.
#     }
#   )
# }

# # Logged in user can delete their review for a movie
# mutation DeleteReview($movieId: UUID!) @auth(level: USER) {
#   # The "auth.uid" server value ensures that users can only delete their own reviews.
#   review_delete(key: { userId_expr: "auth.uid", movieId: $movieId })
# }
````

## File: dataconnect/connector/queries.gql
````graphql
# # Example queries for a simple movie app.

# # @auth() directives control who can call each operation.
# # Anyone should be able to list all movies, so the auth level is set to PUBLIC
# query ListMovies @auth(level: PUBLIC) {
#   movies {
#     id
#     title
#     imageUrl
#     genre
#   }
# }

# # List all users, only admins should be able to list all users, so we use NO_ACCESS
# query ListUsers @auth(level: NO_ACCESS) {
#   users {
#     id
#     username
#   }
# }

# # Logged in users can list all their reviews and movie titles associated with the review
# # Since the query uses the uid of the current authenticated user, we set auth level to USER
# query ListUserReviews @auth(level: USER) {
#   user(key: { id_expr: "auth.uid" }) {
#     id
#     username
#     # <field>_on_<foreign_key_field> makes it easy to grab info from another table
#     # Here, we use it to grab all the reviews written by the user.
#     reviews: reviews_on_user {
#       rating
#       reviewDate
#       reviewText
#       movie {
#         id
#         title
#       }
#     }
#   }
# }

# # Get movie by id
# query GetMovieById($id: UUID!) @auth(level: PUBLIC) {
#   movie(id: $id) {
#     id
#     title
#     imageUrl
#     genre
#     metadata: movieMetadata_on_movie {
#       rating
#       releaseYear
#       description
#     }
#     reviews: reviews_on_movie {
#       reviewText
#       reviewDate
#       rating
#       user {
#         id
#         username
#       }
#     }
#   }
# }

# # Search for movies, actors, and reviews
# query SearchMovie($titleInput: String, $genre: String) @auth(level: PUBLIC) {
#   movies(
#     where: {
#       _and: [{ genre: { eq: $genre } }, { title: { contains: $titleInput } }]
#     }
#   ) {
#     id
#     title
#     genre
#     imageUrl
#   }
# }
````

## File: dataconnect/schema/schema.gql
````graphql
# # Example schema for simple movie review app

# # User table is keyed by Firebase Auth UID.
# type User @table {
#   # `@default(expr: "auth.uid")` sets it to Firebase Auth UID during insert and upsert.
#   id: String! @default(expr: "auth.uid")
#   username: String! @col(dataType: "varchar(50)")
#   # The `user: User!` field in the Review table generates the following one-to-many query field.
#   #  reviews_on_user: [Review!]!
#   # The `Review` join table the following many-to-many query field.
#   #  movies_via_Review: [Movie!]!
# }

# # Movie is keyed by a randomly generated UUID.
# type Movie @table {
#   # If you do not pass a 'key' to `@table`, Data Connect automatically adds the following 'id' column.
#   # Feel free to uncomment and customize it.
#   #  id: UUID! @default(expr: "uuidV4()")
#   title: String!
#   imageUrl: String!
#   genre: String
# }

# # MovieMetadata is a metadata attached to a Movie.
# # Movie <-> MovieMetadata is a one-to-one relationship
# type MovieMetadata @table {
#   # @unique ensures each Movie can only one MovieMetadata.
#   movie: Movie! @unique
#   # The movie field adds the following foreign key field. Feel free to uncomment and customize it.
#   #  movieId: UUID!
#   rating: Float
#   releaseYear: Int
#   description: String
# }

# # Reviews is a join table between User and Movie.
# # It has a composite primary keys `userUid` and `movieId`.
# # A user can leave reviews for many movies. A movie can have reviews from many users.
# # User  <-> Review is a one-to-many relationship
# # Movie <-> Review is a one-to-many relationship
# # Movie <-> User is a many-to-many relationship
# type Review @table(name: "Reviews", key: ["movie", "user"]) {
#   user: User!
#   # The user field adds the following foreign key field. Feel free to uncomment and customize it.
#   #  userUid: String!
#   movie: Movie!
#   # The movie field adds the following foreign key field. Feel free to uncomment and customize it.
#   #  movieId: UUID!
#   rating: Int
#   reviewText: String
#   reviewDate: Date! @default(expr: "request.time")
# }
````

## File: dataconnect/dataconnect.yaml
````yaml
specVersion: "v1beta"
serviceId: "portfoliocore"
location: "us-central1"
schema:
  source: "./schema"
  datasource:
    postgresql:
      database: "fdcdb"
      cloudSql:
        instanceId: "portfoliocore-fdc"
      # schemaValidation: "COMPATIBLE"
connectorDirs: ["./connector"]
````

## File: dataconnect-generated/dart/default_connector/default.dart
````dart
library default_connector;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'dart:convert';







class DefaultConnector {
  

  static ConnectorConfig connectorConfig = ConnectorConfig(
    'us-central1',
    'default',
    'portfoliocore',
  );

  DefaultConnector({required this.dataConnect});
  static DefaultConnector get instance {
    return DefaultConnector(
        dataConnect: FirebaseDataConnect.instanceFor(
            connectorConfig: connectorConfig,
            sdkType: CallerSDKType.generated));
  }

  FirebaseDataConnect dataConnect;
}
````

## File: dataconnect-generated/dart/default_connector/README.md
````markdown
# default_connector SDK

## Installation
```sh
flutter pub get firebase_data_connect
flutterfire configure
```
For more information, see [Flutter for Firebase installation documentation](https://firebase.google.com/docs/data-connect/flutter-sdk#use-core).

## Data Connect instance
Each connector creates a static class, with an instance of the `DataConnect` class that can be used to connect to your Data Connect backend and call operations.

### Connecting to the emulator

```dart
String host = 'localhost'; // or your host name
int port = 9399; // or your port number
DefaultConnector.instance.dataConnect.useDataConnectEmulator(host, port);
```

You can also call queries and mutations by using the connector class.
## Queries
This connector does not contain any queries.
## Mutations
This connector does not contain any mutations.
````

## File: functions/src/genkit-sample.ts
````typescript
// Import the Genkit core libraries and plugins.
import {genkit, z} from "genkit";
import {googleAI} from "@genkit-ai/googleai";

// Import models from the Google AI plugin. The Google AI API provides access to
// several generative models. Here, we import Gemini 1.5 Flash.
import {gemini15Flash} from "@genkit-ai/googleai";

// Cloud Functions for Firebase supports Genkit natively. The onCallGenkit function creates a callable
// function from a Genkit action. It automatically implements streaming if your flow does.
// The https library also has other utility methods such as hasClaim, which verifies that
// a caller's token has a specific claim (optionally matching a specific value)
import { onCallGenkit, hasClaim } from "firebase-functions/https";

// Genkit models generally depend on an API key. APIs should be stored in Cloud Secret Manager so that
// access to these sensitive values can be controlled. defineSecret does this for you automatically.
// If you are using Google generative AI you can get an API key at https://aistudio.google.com/app/apikey
import { defineSecret } from "firebase-functions/params";
const apiKey = defineSecret("GOOGLE_GENAI_API_KEY");

const ai = genkit({
  plugins: [
    // Load the Google AI plugin. You can optionally specify your API key
    // by passing in a config object; if you don't, the Google AI plugin uses
    // the value from the GOOGLE_GENAI_API_KEY environment variable, which is
    // the recommended practice.
    googleAI(),
  ],
});

// Define a simple flow that prompts an LLM to generate menu suggestions.
const menuSuggestionFlow = ai.defineFlow({
    name: "menuSuggestionFlow",
    inputSchema: z.string().describe("A restaurant theme").default("seafood"),
    outputSchema: z.string(),
    streamSchema: z.string(),
  }, async (subject, { sendChunk }) => {
    // Construct a request and send it to the model API.
    const prompt =
      `Suggest an item for the menu of a ${subject} themed restaurant`;
    const { response, stream } = ai.generateStream({
      model: gemini15Flash,
      prompt: prompt,
      config: {
        temperature: 1,
      },
    });

    for await (const chunk of stream) {
      sendChunk(chunk.text);
    }

    // Handle the response from the model API. In this sample, we just
    // convert it to a string, but more complicated flows might coerce the
    // response into structured output or chain the response into another
    // LLM call, etc.
    return (await response).text;
  }
);

export const menuSuggestion = onCallGenkit({
  // Uncomment to enable AppCheck. This can reduce costs by ensuring only your Verified
  // app users can use your API. Read more at https://firebase.google.com/docs/app-check/cloud-functions
  // enforceAppCheck: true,

  // authPolicy can be any callback that accepts an AuthData (a uid and tokens dictionary) and the
  // request data. The isSignedIn() and hasClaim() helpers can be used to simplify. The following
  // will require the user to have the email_verified claim, for example.
  // authPolicy: hasClaim("email_verified"),

  // Grant access to the API key to this function:
  secrets: [apiKey],
}, menuSuggestionFlow);
````

## File: functions/src/index.ts
````typescript
/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import {onRequest} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
````

## File: functions/package.json
````json
{
  "main": "lib/index.js",
  "scripts": {
    "genkit:start": "genkit start -- tsx --watch src/genkit-sample.ts",
    "lint": "eslint --ext .js,.ts .",
    "build": "tsc",
    "build:watch": "tsc --watch",
    "serve": "npm run build && firebase emulators:start --only functions",
    "shell": "npm run build && firebase functions:shell",
    "start": "npm run shell",
    "deploy": "firebase deploy --only functions",
    "logs": "firebase functions:log"
  },
  "name": "functions",
  "engines": {
    "node": "22"
  },
  "dependencies": {
    "@genkit-ai/firebase": "^1.5.0",
    "@genkit-ai/googleai": "^1.5.0",
    "express": "^5.1.0",
    "firebase-admin": "^12.6.0",
    "firebase-functions": "^6.0.1",
    "genkit": "^1.5.0"
  },
  "devDependencies": {
    "@typescript-eslint/eslint-plugin": "^5.12.0",
    "@typescript-eslint/parser": "^5.12.0",
    "eslint": "^8.9.0",
    "eslint-config-google": "^0.14.0",
    "eslint-plugin-import": "^2.25.4",
    "firebase-functions-test": "^3.1.0",
    "tsx": "^4.19.3",
    "typescript": "^4.9.5"
  },
  "private": true
}
````

## File: functions/tsconfig.dev.json
````json
{
  "include": [
    ".eslintrc.js"
  ]
}
````

## File: functions/tsconfig.json
````json
{
  "compileOnSave": true,
  "include": [
    "src"
  ],
  "compilerOptions": {
    "module": "NodeNext",
    "noImplicitReturns": true,
    "outDir": "lib",
    "sourceMap": true,
    "strict": true,
    "target": "es2017",
    "skipLibCheck": true,
    "esModuleInterop": true,
    "moduleResolution": "nodenext",
    "noUnusedLocals": true
  }
}
````

## File: lib/data/services/auth_service.dart
````dart
import 'dart:async'; // Import async for StreamSubscription
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:flutter/foundation.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Get FirebaseAuth instance
  User? _currentUser; // Store the current Firebase user
  StreamSubscription<User?>?
      _authStateSubscription; // Subscription to auth state changes

  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthService() {
    // Listen to authentication state changes
    _authStateSubscription = _auth.authStateChanges().listen((User? user) {
      _currentUser = user;
      _clearError(); // Clear any previous errors on auth state change
      _setLoading(false); // Ensure loading is false after state change
      notifyListeners(); // Notify listeners about the change
    });
  }

  // Override dispose to cancel the stream subscription
  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }

  // Login with email and password
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Auth state listener will handle setting _currentUser and notifying
      // _setLoading(false); // Listener handles this
      return true; // Login successful (state change will confirm)
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors
      _setError(e.message ?? 'An unknown error occurred during login.');
      _setLoading(false);
      return false;
    } catch (e) {
      // Handle other potential errors
      _setError('An unexpected error occurred: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Logout the current user
  Future<void> logout() async {
    _setLoading(true); // Indicate loading during logout
    _clearError();
    try {
      await _auth.signOut();
      // Auth state listener will handle setting _currentUser to null and notifying
    } catch (e) {
      // Handle potential errors during sign out
      _setError('An error occurred during logout: ${e.toString()}');
      _setLoading(false); // Ensure loading is reset on error
    }
    // Listener will set loading to false eventually
  }

  // --- Helper methods for state management ---

  void _setLoading(bool loading) {
    // Avoid unnecessary notifications if state hasn't changed
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  void _setError(String message) {
    _errorMessage = message;
    // Optionally clear error after some time or on next action
    notifyListeners();
  }

  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }
}
````

## File: lib/data/services/blog_service.dart
````dart
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:portfolio_core/models/blog_post.dart';
import 'package:portfolio_core/data/services/auth_service.dart'; // To check auth status

class BlogService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Get Firestore instance
  final AuthService _authService; // Inject AuthService

  BlogService(this._authService);

  // Get a reference to the 'posts' collection
  CollectionReference<BlogPost> get _postsCollection =>
      _firestore.collection('posts').withConverter<BlogPost>(
            fromFirestore: (snapshots, _) => BlogPost.fromFirestore(snapshots),
            toFirestore: (blogPost, _) =>
                blogPost.toFirestore(), // Use default (update)
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
      // TODO: Implement proper logging
      // print('Error fetching post $id: $e');
      // Consider throwing a more specific error (e.g., PostNotFoundException)
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
      // Removed overly complex block that attempted to use converter during add.
      // Simpler approach: Add Map directly to the base collection reference
      final baseCollection = _firestore.collection('posts');
      final docRefSimple = await baseCollection.add({
        'title': title,
        'markdownContent': markdownContent,
        'authorId': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Return the DocumentReference of the newly created post
      // Cast it back to the type expected by the converter if needed elsewhere,
      // but for returning, the base reference is fine.
      return docRefSimple as DocumentReference<
          BlogPost>; // Cast might be needed depending on usage
    } catch (e) {
      // TODO: Implement proper logging
      // print('Error creating post: $e');
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
      // TODO: Implement proper logging
      // print('Error updating post $id: $e');
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
      // TODO: Implement proper logging
      // print('Error deleting post $id: $e');
      throw Exception('Failed to delete post $id. Error: ${e.toString()}');
    }
  }
}
````

## File: lib/models/blog_post.dart
````dart
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
  // 'createdAt' is only set on creation.
  // 'updatedAt' is set on both creation and update.
  Map<String, dynamic> toFirestore({bool isCreating = false}) {
    return {
      'title': title,
      'markdownContent': markdownContent,
      // Use server timestamp on creation for createdAt
      if (isCreating) 'createdAt': FieldValue.serverTimestamp(),
      // Always use server timestamp for updatedAt
      'updatedAt': FieldValue.serverTimestamp(),
      'authorId': authorId, // Include authorId if available
    };
  }

  // Deprecated methods removed. Use fromFirestore and toFirestore.
}
````

## File: lib/screens/auth/login_screen.dart
````dart
import 'package:flutter/material.dart';
import 'package:portfolio_core/data/services/auth_service.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return; // Don't proceed if form is invalid
    }

    // Access AuthService - listen: false as we only call a method
    // Ensure context is valid before accessing Provider
    if (!mounted) return;
    final authService = Provider.of<AuthService>(context, listen: false);

    final success = await authService.login(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success && mounted) {
      // Navigate back or to home screen on successful login
      Navigator.pop(context); // Assuming it was pushed onto the stack
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Login Successful!'), backgroundColor: Colors.green),
      );
    }
    // Error messages are handled by listening to authService.errorMessage below
    // If login fails, the error message will appear automatically due to the listener
  }

  @override
  Widget build(BuildContext context) {
    // Listen to AuthService for loading state and error messages
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          // Prevent overflow on small screens
          padding: Theme.of(context)
              .extension<PortfolioThemeExtension>()!
              .screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Admin Login', // Or more generic title
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Display error message if any
                // Use Consumer or Selector for more targeted rebuilds if needed
                if (authService.errorMessage != null)
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: Theme.of(context)
                            .extension<PortfolioThemeExtension>()!
                            .itemSpacing),
                    child: Text(
                      authService.errorMessage!,
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                      textAlign: TextAlign.center,
                    ),
                  ),

                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  enabled: !authService.isLoading,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                  enabled: !authService.isLoading,
                  onFieldSubmitted: (_) => authService.isLoading
                      ? null
                      : _login(), // Allow login via keyboard action
                ),
                const SizedBox(height: 24),
                authService.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton.icon(
                        icon: const Icon(Icons.login),
                        label: const Text('Login'),
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          textStyle: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
````

## File: lib/screens/blog/blog_list_screen.dart
````dart
import 'package:flutter/material.dart';
import 'package:portfolio_core/data/services/auth_service.dart';
import 'package:portfolio_core/data/services/blog_service.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';
import 'package:portfolio_core/models/blog_post.dart';
import 'package:portfolio_core/screens/blog/blog_post_view_screen.dart';
import 'package:portfolio_core/screens/blog/blog_post_edit_screen.dart';
import 'package:portfolio_core/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';

class BlogListScreen extends StatefulWidget {
  const BlogListScreen({super.key});

  @override
  State<BlogListScreen> createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  // No need for _postsFuture or initState fetching with StreamBuilder

  void _navigateToViewScreen(BuildContext context, String postId) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BlogPostViewScreen(postId: postId)),
    );
  }

  void _navigateToCreateScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const BlogPostEditScreen()), // No postId for create
    );
    // No need to manually refresh, StreamBuilder handles updates
  }

  void _navigateToLoginScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
    // No refresh needed here, the screen rebuilds based on Provider state change
  }

  @override
  Widget build(BuildContext context) {
    // Access AuthService to check authentication status for the FAB
    // Use watch: true (default) or select to rebuild when auth state changes
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      // Using a simple AppBar for now, can be integrated into TabbedPortfolioScreen later
      appBar: AppBar(
        title: const Text('Blog Posts'),
        actions: [
          // Optional: Add Login/Logout button based on auth state
          // Refresh button removed as StreamBuilder handles updates
          if (authService.isAuthenticated)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await authService.logout();
                // Optionally navigate or show feedback
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out successfully')),
                );
              },
              tooltip: 'Logout',
            )
          else
            IconButton(
              icon: const Icon(Icons.login),
              onPressed: () => _navigateToLoginScreen(context),
              tooltip: 'Login',
            ),
        ],
      ),
      // Use StreamBuilder to listen to the posts stream
      body: StreamBuilder<List<BlogPost>>(
        stream:
            Provider.of<BlogService>(context, listen: false).getPostsStream(),
        builder: (context, snapshot) {
          // Handle stream states
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Log the actual error for debugging
            print("Error in posts stream: ${snapshot.error}");
            return Center(
              child: Padding(
                padding: Theme.of(context)
                    .extension<PortfolioThemeExtension>()!
                    .contentPadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Error loading posts. Please check logs or try again later.', // User-friendly message
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                    // Optionally add a retry button, though streams often reconnect
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No blog posts found.'));
          } else {
            // Data is available
            final posts = snapshot.data!;
            // No need for RefreshIndicator with StreamBuilder
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                // Format Timestamp correctly
                final formattedDate =
                    post.createdAt.toDate().toString().substring(0, 10);
                return ListTile(
                  title: Text(post.title),
                  subtitle:
                      Text('Published: $formattedDate'), // Use formatted date
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _navigateToViewScreen(context, post.id),
                );
              },
            );
          }
        }, // End StreamBuilder builder
      ),
      floatingActionButton: authService.isAuthenticated
          ? FloatingActionButton(
              onPressed: () => _navigateToCreateScreen(context),
              tooltip: 'Create New Post',
              child: const Icon(Icons.add),
            )
          : null, // No FAB if not authenticated
    );
  }
}
````

## File: lib/screens/blog/blog_post_edit_screen.dart
````dart
import 'package:flutter/material.dart';
import 'package:portfolio_core/data/services/blog_service.dart';
import 'package:portfolio_core/models/blog_post.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';
import 'package:portfolio_core/widgets/markdown_editor.dart'; // Import the editor
import 'package:provider/provider.dart';

class BlogPostEditScreen extends StatefulWidget {
  final String? postId; // Null for create mode, non-null for edit mode

  const BlogPostEditScreen({this.postId, super.key});

  @override
  State<BlogPostEditScreen> createState() => _BlogPostEditScreenState();
}

class _BlogPostEditScreenState extends State<BlogPostEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController; // For MarkdownEditor

  bool _isLoading = false;
  bool _isFetchingData = false; // Separate flag for initial data load
  String? _errorMessage;
  BlogPost? _editingPost; // Store the post being edited

  bool get _isEditMode => widget.postId != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();

    if (_isEditMode) {
      _fetchPostData();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _fetchPostData() async {
    setState(() {
      _isFetchingData = true;
      _errorMessage = null;
    });
    try {
      // Ensure context is available before using Provider
      if (!mounted) return;
      final post = await Provider.of<BlogService>(context, listen: false)
          .getPostById(widget.postId!);
      if (mounted) {
        // Handle potential null post
        if (post != null) {
          setState(() {
            _editingPost = post;
            _titleController.text = post.title;
            _contentController.text =
                post.markdownContent; // Set editor content
            _isFetchingData = false;
          });
        } else {
          // Post not found, set error message
          setState(() {
            _errorMessage = 'Post not found or could not be loaded.';
            _isFetchingData = false;
          });
        }
      }
    } catch (e) {
      // Add the missing catch block
      print("Error fetching post for edit: $e");
      if (mounted) {
        setState(() {
          _errorMessage = "Failed to load post data: ${e.toString()}";
          _isFetchingData = false;
        });
      }
    }
  }

  Future<void> _savePost() async {
    if (_isLoading) return; // Prevent multiple submissions
    if (!_formKey.currentState!.validate()) return; // Check form validity

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final title = _titleController.text;
    final content =
        _contentController.text; // Get content from editor controller
    // Ensure context is available before using Provider
    if (!mounted) return;
    final blogService = Provider.of<BlogService>(context, listen: false);

    try {
      if (_isEditMode) {
        await blogService.updatePost(widget.postId!, title, content);
      } else {
        await blogService.createPost(title, content);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Post saved successfully!'),
            backgroundColor: Colors.green, // Success feedback
          ),
        );
        // Return true to indicate success to the previous screen (e.g., BlogListScreen)
        Navigator.pop(context, true);
      }
    } catch (e) {
      print("Error saving post: $e");
      if (mounted) {
        setState(() {
          _errorMessage = "Failed to save post: ${e.toString()}";
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving post: ${e.toString()}'),
            backgroundColor:
                Theme.of(context).colorScheme.error, // Error feedback
          ),
        );
      }
    } finally {
      // Ensure isLoading is reset even if mounted check fails after async gap
      if (mounted && _isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Post' : 'Create New Post'),
        actions: [
          // Show loading indicator in AppBar while saving
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Center(
                  child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white))), // Explicit color for AppBar
            )
          else
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _savePost,
              tooltip: 'Save Post',
            ),
        ],
      ),
      body:
          _isFetchingData // Show loading indicator while fetching data for edit mode
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: Theme.of(context)
                      .extension<PortfolioThemeExtension>()!
                      .contentPadding,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .stretch, // Stretch children horizontally
                      children: [
                        // Display error message if any
                        if (_errorMessage != null)
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: Theme.of(context)
                                    .extension<PortfolioThemeExtension>()!
                                    .itemSpacing),
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error),
                              textAlign: TextAlign.center,
                            ),
                          ),

                        TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            labelText: 'Title',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a title';
                            }
                            return null;
                          },
                          enabled: !_isLoading, // Disable fields while saving
                          textInputAction:
                              TextInputAction.next, // Improve form navigation
                        ),
                        const SizedBox(height: 16),
                        // Use Expanded to make the editor fill remaining space
                        Expanded(
                          child: MarkdownEditor(
                            controller: _contentController,
                            // initialValue is handled by controller initialization now
                          ),
                        ),
                        // Optional: Add a separate save button at the bottom as well
                        // const SizedBox(height: 16),
                        // ElevatedButton.icon(
                        //   icon: const Icon(Icons.save),
                        //   label: const Text('Save Post'),
                        //   onPressed: _isLoading ? null : _savePost,
                        //   style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 40)),
                        // ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
````

## File: lib/screens/blog/blog_post_view_screen.dart
````dart
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:portfolio_core/data/services/auth_service.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';
import 'package:portfolio_core/data/services/blog_service.dart';
import 'package:portfolio_core/models/blog_post.dart';
import 'package:portfolio_core/screens/blog/blog_post_edit_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // For handling links in Markdown

class BlogPostViewScreen extends StatefulWidget {
  final String postId;

  const BlogPostViewScreen({required this.postId, super.key});

  @override
  State<BlogPostViewScreen> createState() => _BlogPostViewScreenState();
}

class _BlogPostViewScreenState extends State<BlogPostViewScreen> {
  late Future<BlogPost?> _postFuture; // Allow null BlogPost
  String _appBarTitle = 'Loading Post...'; // State for AppBar title

  @override
  void initState() {
    super.initState();
    _fetchPost();
  }

  void _fetchPost() {
    // Use mounted check for safety
    if (mounted) {
      try {
        final future = Provider.of<BlogService>(context, listen: false)
            .getPostById(widget.postId);

        // Update AppBar title when future completes
        future.then((post) {
          // post is now BlogPost?
          if (mounted) {
            setState(() {
              // Handle null post when setting title
              _appBarTitle = post?.title ?? 'Post Not Found';
            });
          }
        }).catchError((error) {
          if (mounted) {
            setState(() {
              _appBarTitle = 'Error Loading';
            });
          }
        });

        // Assign the Future<BlogPost?> to the state variable
        setState(() {
          _postFuture = future;
        });
      } catch (e) {
        print("Error accessing BlogService: $e");
        setState(() {
          _appBarTitle = 'Error';
          _postFuture = Future.error("BlogService not available.");
        });
      }
    }
  }

  void _navigateToEditScreen(BuildContext context, String postId) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BlogPostEditScreen(postId: postId)),
    ).then((success) {
      // BlogPostEditScreen returns true if save was successful
      if (success == true && mounted) {
        _fetchPost(); // Re-fetch post data
      }
    });
  }

  // Handle link taps in Markdown content
  Future<void> _onTapLink(String text, String? href, String title) async {
    if (href != null) {
      final Uri url = Uri.parse(href);
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        print('Could not launch $url');
        // Optionally show a snackbar or dialog
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open link: $href')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService =
        Provider.of<AuthService>(context); // For edit button visibility

    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle), // Use state variable for title
        actions: [
          // Show edit button only if authenticated
          // TODO: Add author check if necessary: && post.authorId == authService.currentUser?.id
          if (authService.isAuthenticated)
            // Use FutureBuilder<BlogPost?>
            FutureBuilder<BlogPost?>(
                future: _postFuture, // Check against the loaded post data
                builder: (context, snapshot) {
                  // Show button only if post loaded successfully (data is not null) and user is authenticated
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData &&
                      snapshot.data != null && // Explicit null check for data
                      !snapshot.hasError) {
                    return IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () =>
                          _navigateToEditScreen(context, widget.postId),
                      tooltip: 'Edit Post',
                    );
                  }
                  return const SizedBox
                      .shrink(); // Return empty space otherwise
                }),
        ],
      ),
      // Use FutureBuilder<BlogPost?>
      body: FutureBuilder<BlogPost?>(
        future: _postFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: Theme.of(context)
                    .extension<PortfolioThemeExtension>()!
                    .contentPadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Error loading post: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                      onPressed: _fetchPost,
                    )
                  ],
                ),
              ),
            );
            // Check for null data explicitly
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Post not found.'));
          } else {
            // Data is available and not null, safe to use !
            final post = snapshot.data!;

            // Format Timestamps correctly using .toDate()
            final publishedDate =
                post.createdAt.toDate().toString().substring(0, 10);
            final updatedDate =
                post.updatedAt.toDate().toString().substring(0, 10);

            return SingleChildScrollView(
              // Allow scrolling for long posts
              padding: Theme.of(context)
                  .extension<PortfolioThemeExtension>()!
                  .contentPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title is now in AppBar
                  // Text(
                  //   post.title,
                  //   style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  // ),
                  // const SizedBox(height: 8),
                  Text(
                    'Published: $publishedDate | Updated: $updatedDate', // Use formatted dates
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Divider(height: 24),
                  MarkdownBody(
                    data: post.markdownContent,
                    selectable: true, // Allow text selection
                    onTapLink: _onTapLink, // Handle link taps
                    // TODO: Customize MarkdownStyleSheet if needed based on app theme
                    // styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(...),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
````

## File: lib/services/url_launcher_service.dart
````dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  /// Launches a URL in the default browser
  static Future<bool> openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return true;
    }
    return false;
  }

  /// Launches an email URL
  static Future<bool> openEmail(String email) async {
    return openUrl('mailto:$email');
  }

  /// Handles Markdown link taps
  static Future<void> handleMarkdownLinkTap(
    BuildContext context,
    String text,
    String? href,
    String title,
  ) async {
    if (href != null) {
      final success = await openUrl(href);
      if (!success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open link: $href')),
        );
      }
    }
  }
}
````

## File: lib/widgets/common/contact_info_item.dart
````dart
import 'package:flutter/material.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';
import 'package:portfolio_core/services/url_launcher_service.dart';

class ContactInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;
  final bool isClickable;
  final double iconSize;

  const ContactInfoItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
    this.isClickable = true,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final content = Row(
      children: [
        Icon(
          icon,
          color: SimplifiedTheme.primaryBlue,
          size: iconSize,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isClickable ? SimplifiedTheme.primaryBlue : null,
                    ),
              ),
            ],
          ),
        ),
        if (isClickable)
          Icon(
            Icons.arrow_forward_ios,
            color: SimplifiedTheme.primaryBlue,
            size: 16,
          ),
      ],
    );

    if (isClickable && onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: Theme.of(context)
              .extension<PortfolioThemeExtension>()!
              .smallPadding,
          child: content,
        ),
      );
    } else {
      return Container(
        padding: Theme.of(context)
            .extension<PortfolioThemeExtension>()!
            .contentPadding,
        decoration: BoxDecoration(
          color: isDarkMode
              ? SimplifiedTheme.backgroundDark
              : SimplifiedTheme.backgroundLight,
          borderRadius: BorderRadius.circular(Theme.of(context)
              .extension<PortfolioThemeExtension>()!
              .cardBorderRadius),
        ),
        child: content,
      );
    }
  }
}
````

## File: lib/widgets/common/portfolio_tab_view.dart
````dart
import 'package:flutter/material.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';

class PortfolioTabView extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final CrossAxisAlignment crossAxisAlignment;

  const PortfolioTabView({
    super.key,
    required this.title,
    required this.children,
    this.padding,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: padding ??
          Theme.of(context).extension<PortfolioThemeExtension>()!.screenPadding,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          // Header
          Text(
            title,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 24),

          // Content
          ...children,
        ],
      ),
    );
  }
}
````

## File: lib/widgets/common/skill_progress_bar.dart
````dart
import 'package:flutter/material.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';
import 'package:portfolio_core/models/skill.dart';

class SkillProgressBar extends StatelessWidget {
  final Skill skill;

  const SkillProgressBar({
    super.key,
    required this.skill,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              skill.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              '${(skill.level * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: SimplifiedTheme.primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: skill.level,
            child: Container(
              decoration: BoxDecoration(
                color: SimplifiedTheme.primaryBlue,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
````

## File: lib/widgets/markdown/markdown_edit_view.dart
````dart
import 'package:flutter/material.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';

class MarkdownEditView extends StatelessWidget {
  final TextEditingController controller;

  const MarkdownEditView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('edit_view'),
      padding:
          Theme.of(context).extension<PortfolioThemeExtension>()!.smallPadding,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: TextField(
        controller: controller,
        maxLines: null, // Allows unlimited lines
        expands: true, // Fills available space
        keyboardType: TextInputType.multiline,
        decoration: const InputDecoration(
          hintText: 'Enter your Markdown here...',
          border: InputBorder.none, // Remove TextField's own border
          isDense: true, // Reduce padding
        ),
        style: const TextStyle(fontFamily: 'monospace'), // Use monospace font
        textAlignVertical: TextAlignVertical.top,
      ),
    );
  }
}
````

## File: lib/widgets/markdown/markdown_preview_view.dart
````dart
import 'package:flutter/material.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:portfolio_core/services/url_launcher_service.dart';

class MarkdownPreviewView extends StatelessWidget {
  final TextEditingController controller;

  const MarkdownPreviewView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('preview_view'),
      padding:
          Theme.of(context).extension<PortfolioThemeExtension>()!.smallPadding,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(4.0),
      ),
      // Use a Scrollbar for potentially long previews
      child: Scrollbar(
        child: SingleChildScrollView(
          // Ensure preview area is scrollable
          child: MarkdownBody(
            data: controller.text.isEmpty
                ? "*Preview will appear here...*" // Placeholder if empty
                : controller.text,
            selectable: true,
            onTapLink: (text, href, title) =>
                UrlLauncherService.handleMarkdownLinkTap(
                    context, text, href, title),
          ),
        ),
      ),
    );
  }
}
````

## File: lib/widgets/markdown_editor.dart
````dart
import 'package:flutter/material.dart';
import 'package:portfolio_core/widgets/markdown/markdown_edit_view.dart';
import 'package:portfolio_core/widgets/markdown/markdown_preview_view.dart';

enum EditorMode { edit, preview }

class MarkdownEditor extends StatefulWidget {
  final String initialValue;
  final TextEditingController controller;

  const MarkdownEditor({
    required this.controller,
    this.initialValue = '',
    super.key,
  });

  @override
  State<MarkdownEditor> createState() => _MarkdownEditorState();
}

class _MarkdownEditorState extends State<MarkdownEditor> {
  EditorMode _selectedMode = EditorMode.edit;

  @override
  void initState() {
    super.initState();
    // Initialize controller text if it's empty and initialValue is provided
    if (widget.controller.text.isEmpty && widget.initialValue.isNotEmpty) {
      widget.controller.text = widget.initialValue;
    }
    // Add listener to rebuild preview when text changes
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    // Remove listener, but don't dispose the controller as it's external
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    // If in preview mode, trigger a rebuild to update the preview
    if (_selectedMode == EditorMode.preview && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SegmentedButton<EditorMode>(
            segments: const <ButtonSegment<EditorMode>>[
              ButtonSegment<EditorMode>(
                  value: EditorMode.edit,
                  label: Text('Edit'),
                  icon: Icon(Icons.edit_note)),
              ButtonSegment<EditorMode>(
                  value: EditorMode.preview,
                  label: Text('Preview'),
                  icon: Icon(Icons.visibility)),
            ],
            selected: <EditorMode>{_selectedMode},
            onSelectionChanged: (Set<EditorMode> newSelection) {
              setState(() {
                _selectedMode = newSelection.first;
              });
            },
          ),
        ),
        Expanded(
          child: AnimatedSwitcher(
            // Smooth transition between modes
            duration: const Duration(milliseconds: 300),
            child: _selectedMode == EditorMode.edit
                ? MarkdownEditView(controller: widget.controller)
                : MarkdownPreviewView(controller: widget.controller),
          ),
        ),
      ],
    );
  }
}
````

## File: lib/firebase_options.dart
````dart
// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAFlpqcvU61bVTnY_0go9ZgqSwQ3kXX3Z8',
    appId: '1:133393946896:web:20b5449d128c1c90816d95',
    messagingSenderId: '133393946896',
    projectId: 'alialqattandev',
    authDomain: 'alialqattandev.firebaseapp.com',
    databaseURL: 'https://alialqattandev-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'alialqattandev.firebasestorage.app',
    measurementId: 'G-J5Q0EX54WB',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAFlpqcvU61bVTnY_0go9ZgqSwQ3kXX3Z8',
    appId: '1:133393946896:web:20b5449d128c1c90816d95',
    messagingSenderId: '133393946896',
    projectId: 'alialqattandev',
    authDomain: 'alialqattandev.firebaseapp.com',
    databaseURL: 'https://alialqattandev-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'alialqattandev.firebasestorage.app',
    measurementId: 'G-J5Q0EX54WB',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAAxmMgR-id2KAzpJ-9XgbfGSmKRajfrb8',
    appId: '1:133393946896:ios:7f8180f255b0b379816d95',
    messagingSenderId: '133393946896',
    projectId: 'alialqattandev',
    databaseURL: 'https://alialqattandev-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'alialqattandev.firebasestorage.app',
    iosBundleId: 'com.example.portfolioCore',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAAxmMgR-id2KAzpJ-9XgbfGSmKRajfrb8',
    appId: '1:133393946896:ios:7f8180f255b0b379816d95',
    messagingSenderId: '133393946896',
    projectId: 'alialqattandev',
    databaseURL: 'https://alialqattandev-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'alialqattandev.firebasestorage.app',
    iosBundleId: 'com.example.portfolioCore',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDXNjK5l-ExhjpI3leZM4Jyh5ZvFQYUazY',
    appId: '1:133393946896:android:d481cd330c8f6025816d95',
    messagingSenderId: '133393946896',
    projectId: 'alialqattandev',
    databaseURL: 'https://alialqattandev-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'alialqattandev.firebasestorage.app',
  );

}
````

## File: apphosting.yaml
````yaml
# Settings for Backend (on Cloud Run).
# See https://firebase.google.com/docs/app-hosting/configure#cloud-run
runConfig:
  minInstances: 0
  # maxInstances: 100
  # concurrency: 80
  # cpu: 1
  # memoryMiB: 512

# Environment variables and secrets.
# env:
  # Configure environment variables.
  # See https://firebase.google.com/docs/app-hosting/configure#user-defined-environment
  # - variable: MESSAGE
  #   value: Hello world!
  #   availability:
  #     - BUILD
  #     - RUNTIME

  # Grant access to secrets in Cloud Secret Manager.
  # See https://firebase.google.com/docs/app-hosting/configure#secret-parameters
  # - variable: MY_SECRET
  #   secret: mySecretRef
````

## File: firebase.json
````json
{
  "firestore": {
    "rules": "firestore.rules",
    "indexes": "firestore.indexes.json"
  },
  "flutter": {
    "platforms": {
      "dart": {
        "lib/firebase_options.dart": {
          "projectId": "alialqattandev",
          "configurations": {
            "android": "1:133393946896:android:d481cd330c8f6025816d95",
            "ios": "1:133393946896:ios:7f8180f255b0b379816d95",
            "macos": "1:133393946896:ios:7f8180f255b0b379816d95",
            "web": "1:133393946896:web:20b5449d128c1c90816d95",
            "windows": "1:133393946896:web:20b5449d128c1c90816d95"
          }
        }
      },
      "android": {
        "default": {
          "projectId": "alialqattandev",
          "appId": "1:133393946896:android:d481cd330c8f6025816d95",
          "fileOutput": "android/app/google-services.json"
        }
      }
    }
  },
  "functions": [
    {
      "source": "functions",
      "codebase": "default",
      "predeploy": [
        "npm --prefix \"$RESOURCE_DIR\" run lint",
        "npm --prefix \"$RESOURCE_DIR\" run build"
      ]
    }
  ],
  "hosting": {
    "public": "public",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ]
  }
}
````

## File: firestore.indexes.json
````json
{
  "indexes": [],
  "fieldOverrides": []
}
````

## File: firestore.rules
````
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {

    // Allow public read access to projects
    match /projects/{projectId} {
      allow get, list: if true;
      allow create, update, delete: if false; // Writes disallowed for now
    }

    // Allow public read access to skills
    // Assuming skills are stored similarly or adjust path if needed
    match /skills/{skillId} {
      allow get, list: if true;
      allow create, update, delete: if false; // Writes disallowed for now
    }

    // Rules for blog posts
    match /posts/{postId} {
      // Anyone can read blog posts
      allow get, list: if true;

      // Only authenticated users can create posts
      allow create: if request.auth != null;

      // Only the author of the post can update or delete it
      allow update, delete: if request.auth != null && request.auth.uid == resource.data.authorId;
    }

    // Firestore defaults to denying access for any path not explicitly matched.
  }
}
````

## File: lib/data/portfolio_data.dart
````dart
import 'package:flutter/material.dart';
import 'package:portfolio_core/models/project.dart';
import 'package:portfolio_core/models/skill.dart';

class PortfolioData extends ChangeNotifier {
  // Personal Information
  final String name = 'Ali';
  final String title = 'Neovim Enthusiast & Developer';
  final String email = 'ali@example.com';
  final String github = 'https://github.com/your-username';
  final String linkedin = 'https://linkedin.com/in/your-profile';

  // Bio with coding references
  final String bio =
      '''I'm a passionate developer and terminal enthusiast who lives by the keyboard. Vim motions are my second language, and I believe efficient code is beautiful code.

My development environment is carefully crafted with Neovim, tmux, and a custom set of dotfiles that I've been perfecting for years. When I'm not optimizing my workflow, I'm building applications with a focus on performance and clean architecture.''';

  // Skills
  final List<Skill> skills = [
    Skill(name: 'Neovim/Vim', level: 0.95),
    Skill(name: 'Flutter/Dart', level: 0.90),
    Skill(name: 'Lua', level: 0.85),
    Skill(name: 'TypeScript', level: 0.80),
    Skill(name: 'Rust', level: 0.75),
    Skill(name: 'Docker', level: 0.80),
    Skill(name: 'Linux/Shell', level: 0.90),
    Skill(name: 'Git', level: 0.85),
  ];

  // Projects
  final List<Project> projects = [
    Project(
      id: 'neovim-config-manager',
      title: 'Neovim Config Manager',
      description:
          'A plugin manager and configuration system for Neovim that allows for modular configuration and easy installation of plugins across multiple machines.',
      technologies: ['Lua', 'Neovim API', 'Shell'],
      imageUrl: 'assets/images/project1.png',
      githubUrl: 'https://github.com/your-username/nvim-config',
      liveUrl: 'https://your-nvim-config.com',
    ),
    Project(
      id: 'terminal-dashboard',
      title: 'Terminal Dashboard',
      description:
          'A Flutter-based dashboard that provides a coding-focused overview of your system resources, git repositories, and task management in a terminal aesthetic.',
      technologies: ['Flutter', 'Dart', 'System APIs'],
      imageUrl: 'assets/images/project2.png',
      githubUrl: 'https://github.com/your-username/term-dashboard',
      liveUrl: 'https://your-term-dashboard.com',
    ),
    Project(
      id: 'code-snippet-manager',
      title: 'Code Snippet Manager',
      description:
          'A cross-platform application for organizing and searching code snippets with syntax highlighting, tags, and keyboard-centric navigation.',
      technologies: ['Flutter', 'SQLite', 'Provider'],
      imageUrl: 'assets/images/project3.png',
      githubUrl: 'https://github.com/your-username/snippet-manager',
      liveUrl: 'https://your-snippet-manager.com',
    ),
    Project(
      id: 'dotfiles-orchestrator',
      title: 'Dotfiles Orchestrator',
      description:
          'A Rust-based tool that manages and synchronizes dotfiles across multiple machines, with automated installation and configuration of development tools.',
      technologies: ['Rust', 'TOML', 'Shell'],
      imageUrl: 'assets/images/project4.png',
      githubUrl: 'https://github.com/your-username/dotfiles-orch',
      liveUrl: 'https://your-dotfiles-tool.com',
    ),
  ];
}
````

## File: lib/models/project.dart
````dart
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
      'technologies': technologies,
      'imageUrl': imageUrl,
      'githubUrl': githubUrl,
      'liveUrl': liveUrl,
      // Consider adding timestamps if needed (e.g., 'createdAt', 'updatedAt')
      // 'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
````

## File: lib/models/skill.dart
````dart
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
````

## File: lib/screens/tabbed_portfolio_screen.dart
````dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_core/data/portfolio_data.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';
import 'package:portfolio_core/widgets/tabs/about_tab.dart';
import 'package:portfolio_core/widgets/tabs/contact_tab.dart';
import 'package:portfolio_core/widgets/tabs/home_tab.dart';
import 'package:portfolio_core/widgets/tabs/projects_tab.dart';
import 'package:portfolio_core/widgets/tabs/skills_tab.dart';
import 'package:portfolio_core/screens/blog/blog_list_screen.dart'; // Import BlogListScreen

class TabbedPortfolioScreen extends StatefulWidget {
  const TabbedPortfolioScreen({super.key});

  @override
  State<TabbedPortfolioScreen> createState() => _TabbedPortfolioScreenState();
}

class _TabbedPortfolioScreenState extends State<TabbedPortfolioScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final portfolioData = PortfolioData();

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 6, vsync: this); // Increased length to 6
    // Add listener to update the state when tab changes
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    // Force rebuild when tab index changes to update IndexedStack
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  // Helper method to build the header
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Name/Logo
        Text(
          portfolioData.name, // Access state's portfolioData
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: SimplifiedTheme.primaryBlue,
          ),
        ),
      ],
    );
  }

  // Helper method to build the TabBar container
  Widget _buildTabBar(BuildContext context, bool isDarkMode, Size size) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Container(
        decoration: BoxDecoration(
          color:
              isDarkMode ? SimplifiedTheme.cardDark : SimplifiedTheme.cardLight,
          borderRadius: BorderRadius.circular(Theme.of(context)
              .extension<PortfolioThemeExtension>()!
              .cardBorderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isDarkMode ? 40 : 20),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TabBar(
          controller: _tabController, // Access state's _tabController
          labelColor: SimplifiedTheme.primaryBlue,
          unselectedLabelColor:
              isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
          indicatorColor: SimplifiedTheme.primaryBlue,
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          isScrollable: size.width < 600, // Scrollable on small screens
          labelStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 14,
          ),
          tabs: const [
            Tab(icon: Icon(Icons.home_outlined), text: 'Home'),
            Tab(icon: Icon(Icons.person_outline), text: 'About'),
            Tab(icon: Icon(Icons.code_outlined), text: 'Skills'),
            Tab(icon: Icon(Icons.work_outline), text: 'Projects'),
            Tab(icon: Icon(Icons.mail_outline), text: 'Contact'),
            Tab(
                icon: Icon(Icons.article_outlined),
                text: 'Blog'), // Added Blog Tab
          ],
        ),
      ),
    );
  }

  // Helper method to build the Tab Content container
  Widget _buildTabContent(BuildContext context, bool isDarkMode) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color:
              isDarkMode ? SimplifiedTheme.cardDark : SimplifiedTheme.cardLight,
          borderRadius: BorderRadius.circular(Theme.of(context)
              .extension<PortfolioThemeExtension>()!
              .cardBorderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isDarkMode ? 40 : 20),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Theme.of(context)
              .extension<PortfolioThemeExtension>()!
              .cardBorderRadius),
          child: IndexedStack(
            index: _tabController.index, // Access state's _tabController
            children: [
              // Home tab
              HomeTab(
                  portfolioData: portfolioData), // Access state's portfolioData

              // About tab
              AboutTab(portfolioData: portfolioData),

              // Skills tab
              SkillsTab(portfolioData: portfolioData),

              // Projects tab
              ProjectsTab(portfolioData: portfolioData),

              // Contact tab
              ContactTab(portfolioData: portfolioData),

              // Blog tab
              BlogListScreen(), // Added BlogListScreen
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: isDarkMode
              ? SimplifiedTheme.backgroundDark
              : SimplifiedTheme.backgroundLight,
        ),
        child: SafeArea(
          child: Padding(
            padding: Theme.of(context)
                .extension<PortfolioThemeExtension>()!
                .contentPadding,
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  // Header
                  _buildHeader(context),

                  SizedBox(height: constraints.maxHeight * 0.03),

                  // Tab bar
                  _buildTabBar(context, isDarkMode, size),

                  SizedBox(height: constraints.maxHeight * 0.03),

                  // Tab content
                  _buildTabContent(context, isDarkMode),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
````

## File: lib/theme/simplified_theme.dart
````dart
import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A simplified theme class for the portfolio
class SimplifiedTheme {
  // Primary colors
  static const Color primaryBlue = Color(0xFF61AFEF);
  static const Color accentGreen = Color(0xFF98C379);
  static const Color accentPurple = Color(0xFFC678DD);

  // Background colors
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF1E2127);

  // Card colors
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF282C34);

  // Text colors
  static const Color textDark = Color(0xFF2C3E50);
  static const Color textLight = Color(0xFFABB2BF);

  // Border radius (Moved to PortfolioThemeExtension)

  // Get Light Theme
  // Define standard padding/spacing values
  static const EdgeInsets _screenPadding = EdgeInsets.all(24.0);
  static const EdgeInsets _contentPadding = EdgeInsets.all(16.0);
  static const EdgeInsets _smallPadding = EdgeInsets.all(8.0);
  static const double _itemSpacing = 16.0;

  static ThemeData getLightTheme() {
    const double borderRadius = 12.0; // Define locally for theme creation
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryBlue,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.light,
        secondary: accentGreen,
      ),
      scaffoldBackgroundColor: backgroundLight,
      cardColor: cardLight,
      textTheme: getTextTheme(false),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        color: cardLight,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: cardLight,
        iconTheme: const IconThemeData(color: primaryBlue),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: primaryBlue,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          minimumSize: const Size(100, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: primaryBlue.withAlpha(((0.15) * 255).round()),
        labelStyle: GoogleFonts.inter(
          color: primaryBlue,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: primaryBlue,
        unselectedLabelColor: textDark.withAlpha(((0.7) * 255).round()),
        indicatorColor: primaryBlue,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
        ),
      ),
      extensions: const <ThemeExtension<dynamic>>[
        PortfolioThemeExtension(
          cardBorderRadius: borderRadius,
          screenPadding: _screenPadding,
          contentPadding: _contentPadding,
          smallPadding: _smallPadding,
          itemSpacing: _itemSpacing,
        ),
      ],
    );
  }

  // Get Dark Theme
  static ThemeData getDarkTheme() {
    const double borderRadius = 12.0; // Define locally for theme creation
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryBlue,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.dark,
        secondary: accentPurple,
      ),
      scaffoldBackgroundColor: backgroundDark,
      cardColor: cardDark,
      textTheme: getTextTheme(true),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        color: cardDark,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: cardDark,
        iconTheme: const IconThemeData(color: primaryBlue),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: primaryBlue,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          minimumSize: const Size(100, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: primaryBlue.withAlpha(((0.15) * 255).round()),
        labelStyle: GoogleFonts.inter(
          color: primaryBlue,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: primaryBlue,
        unselectedLabelColor: textLight.withAlpha(((0.7) * 255).round()),
        indicatorColor: primaryBlue,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
        ),
      ),
      extensions: const <ThemeExtension<dynamic>>[
        PortfolioThemeExtension(
          cardBorderRadius: borderRadius,
          screenPadding: _screenPadding,
          contentPadding: _contentPadding,
          smallPadding: _smallPadding,
          itemSpacing: _itemSpacing,
        ),
      ],
    );
  }

  // Text Styles
  static TextTheme getTextTheme(bool isDark) {
    final Color textColor = isDark ? textLight : textDark;

    return TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: 42,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
        color: isDark ? primaryBlue : primaryBlue,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 34,
        fontWeight: FontWeight.bold,
        color: isDark ? primaryBlue : primaryBlue,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: isDark ? primaryBlue : primaryBlue,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: isDark ? accentPurple : accentGreen,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: isDark ? accentGreen : primaryBlue,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 18,
        height: 1.6,
        color: textColor,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 16,
        height: 1.5,
        color: textColor,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 14,
        height: 1.5,
        color: textColor.withAlpha(((0.8) * 255).round()),
      ),
    );
  }
}

// --- Theme Extension ---

/// Defines custom theme properties for the portfolio app.
class PortfolioThemeExtension extends ThemeExtension<PortfolioThemeExtension> {
  const PortfolioThemeExtension({
    required this.cardBorderRadius,
    required this.screenPadding,
    required this.contentPadding,
    required this.smallPadding,
    required this.itemSpacing,
  });

  final double cardBorderRadius;
  final EdgeInsets screenPadding;
  final EdgeInsets contentPadding;
  final EdgeInsets smallPadding;
  final double itemSpacing;

  @override
  PortfolioThemeExtension copyWith({
    double? cardBorderRadius,
    EdgeInsets? screenPadding,
    EdgeInsets? contentPadding,
    EdgeInsets? smallPadding,
    double? itemSpacing,
  }) {
    return PortfolioThemeExtension(
      cardBorderRadius: cardBorderRadius ?? this.cardBorderRadius,
      screenPadding: screenPadding ?? this.screenPadding,
      contentPadding: contentPadding ?? this.contentPadding,
      smallPadding: smallPadding ?? this.smallPadding,
      itemSpacing: itemSpacing ?? this.itemSpacing,
    );
  }

  @override
  PortfolioThemeExtension lerp(
      ThemeExtension<PortfolioThemeExtension>? other, double t) {
    if (other is! PortfolioThemeExtension) {
      return this;
    }
    return PortfolioThemeExtension(
      cardBorderRadius:
          lerpDouble(cardBorderRadius, other.cardBorderRadius, t) ??
              cardBorderRadius,
      screenPadding: EdgeInsets.lerp(screenPadding, other.screenPadding, t) ??
          screenPadding,
      contentPadding:
          EdgeInsets.lerp(contentPadding, other.contentPadding, t) ??
              contentPadding,
      smallPadding:
          EdgeInsets.lerp(smallPadding, other.smallPadding, t) ?? smallPadding,
      itemSpacing: lerpDouble(itemSpacing, other.itemSpacing, t) ?? itemSpacing,
    );
  }

  // Optional: Add toString for debugging
  @override
  String toString() =>
      'PortfolioThemeExtension(cardBorderRadius: $cardBorderRadius, screenPadding: $screenPadding, contentPadding: $contentPadding, smallPadding: $smallPadding, itemSpacing: $itemSpacing)';
}
````

## File: lib/widgets/tabs/about_tab.dart
````dart
import 'package:flutter/material.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';
import 'package:portfolio_core/data/portfolio_data.dart';
import 'package:portfolio_core/widgets/common/portfolio_tab_view.dart';
import 'package:portfolio_core/widgets/common/contact_info_item.dart';

class AboutTab extends StatelessWidget {
  final PortfolioData portfolioData;

  const AboutTab({super.key, required this.portfolioData});

  @override
  Widget build(BuildContext context) {
    return PortfolioTabView(
      title: 'About Me',
      children: [
        // About content
        Text(
          portfolioData.bio,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 32),

        // Contact Info Section
        Text(
          'Contact Information',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),

        // Email
        ContactInfoItem(
          icon: Icons.email_outlined,
          label: 'Email',
          value: portfolioData.email,
          isClickable: false,
        ),
        const SizedBox(height: 12),

        // GitHub
        ContactInfoItem(
          icon: Icons.code_outlined,
          label: 'GitHub',
          value: portfolioData.github,
          isClickable: false,
        ),
        const SizedBox(height: 12),

        // LinkedIn
        ContactInfoItem(
          icon: Icons.business_outlined,
          label: 'LinkedIn',
          value: portfolioData.linkedin,
          isClickable: false,
        ),
      ],
    );
  }
}
````

## File: lib/widgets/tabs/contact_tab.dart
````dart
import 'package:flutter/material.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';
import 'package:portfolio_core/data/portfolio_data.dart';
import 'package:portfolio_core/widgets/common/portfolio_tab_view.dart';
import 'package:portfolio_core/widgets/common/contact_info_item.dart';
import 'package:portfolio_core/services/url_launcher_service.dart';

class ContactTab extends StatelessWidget {
  final PortfolioData portfolioData;

  const ContactTab({super.key, required this.portfolioData});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return PortfolioTabView(
      title: 'Contact Me',
      children: [
        // Contact intro
        Text(
          'Feel free to reach out to me for collaboration, job opportunities, or just to say hello!',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 32),

        // Contact card
        Container(
          padding: Theme.of(context)
              .extension<PortfolioThemeExtension>()!
              .screenPadding,
          decoration: BoxDecoration(
            color: isDarkMode
                ? SimplifiedTheme.backgroundDark
                : SimplifiedTheme.backgroundLight,
            borderRadius: BorderRadius.circular(Theme.of(context)
                .extension<PortfolioThemeExtension>()!
                .cardBorderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(isDarkMode ? 40 : 20),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              // Email
              ContactInfoItem(
                icon: Icons.email_outlined,
                label: 'Email',
                value: portfolioData.email,
                iconSize: 32,
                onTap: () => UrlLauncherService.openEmail(portfolioData.email),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // GitHub
              ContactInfoItem(
                icon: Icons.code_outlined,
                label: 'GitHub',
                value: portfolioData.github,
                iconSize: 32,
                onTap: () => UrlLauncherService.openUrl(portfolioData.github),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // LinkedIn
              ContactInfoItem(
                icon: Icons.business_outlined,
                label: 'LinkedIn',
                value: portfolioData.linkedin,
                iconSize: 32,
                onTap: () => UrlLauncherService.openUrl(portfolioData.linkedin),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
````

## File: lib/widgets/tabs/home_tab.dart
````dart
import 'package:flutter/material.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';
import 'package:portfolio_core/data/portfolio_data.dart';
import 'package:portfolio_core/widgets/common/portfolio_tab_view.dart';

class HomeTab extends StatelessWidget {
  final PortfolioData portfolioData;

  const HomeTab({super.key, required this.portfolioData});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return PortfolioTabView(
      title: 'Home',
      children: [
        // Bio section
        Text(
          'Hello, I\'m',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 8),
        Text(
          portfolioData.name,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: 8),
        Text(
          portfolioData.title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: SimplifiedTheme.accentGreen,
              ),
        ),
        const SizedBox(height: 24),

        // Bio
        Text(
          portfolioData.bio,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 32),

        // Call to action
        Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: () {
              // Can be used to navigate to projects or contact
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: SimplifiedTheme.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
            ),
            child: const Text(
              'View My Projects',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
````

## File: lib/widgets/tabs/projects_tab.dart
````dart
import 'package:flutter/material.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';
import 'package:portfolio_core/data/portfolio_data.dart';
import 'package:portfolio_core/widgets/project_card.dart';
import 'package:portfolio_core/widgets/common/portfolio_tab_view.dart';

class ProjectsTab extends StatelessWidget {
  final PortfolioData portfolioData;

  const ProjectsTab({super.key, required this.portfolioData});

  @override
  Widget build(BuildContext context) {
    return PortfolioTabView(
      title: 'Projects',
      children: [
        // Projects grid
        LayoutBuilder(builder: (context, constraints) {
          // Responsive grid - 1 column on mobile, 2 on larger screens
          final crossAxisCount = constraints.maxWidth > 700 ? 2 : 1;

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              mainAxisExtent: 450, // Fixed height for cards
            ),
            itemCount: portfolioData.projects.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final project = portfolioData.projects[index];
              return ProjectCard(project: project);
            },
          );
        }),
      ],
    );
  }
}
````

## File: lib/widgets/tabs/skills_tab.dart
````dart
import 'package:flutter/material.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';
import 'package:portfolio_core/data/portfolio_data.dart';
import 'package:portfolio_core/widgets/common/portfolio_tab_view.dart';
import 'package:portfolio_core/widgets/common/skill_progress_bar.dart';

class SkillsTab extends StatelessWidget {
  final PortfolioData portfolioData;

  const SkillsTab({super.key, required this.portfolioData});

  @override
  Widget build(BuildContext context) {
    return PortfolioTabView(
      title: 'Skills',
      children: [
        // Skills list
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: portfolioData.skills.length,
          itemBuilder: (context, index) {
            final skill = portfolioData.skills[index];
            return Padding(
              padding: EdgeInsets.only(
                  bottom: Theme.of(context)
                      .extension<PortfolioThemeExtension>()!
                      .itemSpacing),
              child: SkillProgressBar(skill: skill),
            );
          },
        ),
      ],
    );
  }
}
````

## File: lib/widgets/project_card.dart
````dart
import 'package:flutter/material.dart';
import 'package:portfolio_core/models/project.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';
import 'package:portfolio_core/services/url_launcher_service.dart';

class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode
            ? SimplifiedTheme.backgroundDark
            : SimplifiedTheme.backgroundLight,
        borderRadius: BorderRadius.circular(Theme.of(context)
            .extension<PortfolioThemeExtension>()!
            .cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDarkMode ? 40 : 20),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project image
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.asset(
              project.imageUrl,
              fit: BoxFit.cover,
            ),
          ),

          // Project content
          Padding(
            padding: Theme.of(context)
                .extension<PortfolioThemeExtension>()!
                .contentPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  project.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  project.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),

                // Technologies
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: project.technologies.map((tech) {
                    return Chip(
                      label: Text(tech),
                      backgroundColor:
                          SimplifiedTheme.primaryBlue.withOpacity(0.15),
                      labelStyle: TextStyle(
                        color: SimplifiedTheme.primaryBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Links
                Row(
                  children: [
                    if (project.githubUrl != null)
                      _buildLinkButton(
                        context,
                        'GitHub',
                        Icons.code,
                        () => UrlLauncherService.openUrl(project.githubUrl!),
                      ),
                    const SizedBox(width: 12),
                    if (project.liveUrl != null)
                      _buildLinkButton(
                        context,
                        'Live Demo',
                        Icons.open_in_new,
                        () => UrlLauncherService.openUrl(project.liveUrl!),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: SimplifiedTheme.primaryBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}
````

## File: lib/main.dart
````dart
import 'package:flutter/material.dart';
import 'package:portfolio_core/data/services/auth_service.dart';
import 'package:portfolio_core/data/services/blog_service.dart';
import 'package:portfolio_core/screens/tabbed_portfolio_screen.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:portfolio_core/firebase_options.dart'; // Import generated options

Future<void> main() async {
  // Make main async
  WidgetsFlutterBinding.ensureInitialized(); // Ensure bindings are initialized
  await Firebase.initializeApp(
    // Initialize Firebase
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        // BlogService depends on AuthService
        ProxyProvider<AuthService, BlogService>(
          update: (_, authService, previousBlogService) =>
              BlogService(authService),
          // We only need to create it once and provide the AuthService instance
        ),
      ],
      child: const PortfolioApp(),
    ),
  );
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio Core',
      debugShowCheckedModeBanner: false,
      theme: SimplifiedTheme.getLightTheme(),
      darkTheme: SimplifiedTheme.getDarkTheme(),
      themeMode: ThemeMode.system,
      scrollBehavior: const ScrollBehavior().copyWith(
        scrollbars: false,
        overscroll: false,
      ),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(1.0),
          ),
          child: child!,
        );
      },
      home: const TabbedPortfolioScreen(),
    );
  }
}
````

## File: web/index.html
````html
<!DOCTYPE html>
<html lang="en">
<head>
  <!--
    If you are serving your web app in a path other than the root, change the
    href value below to reflect the base path you are serving from.

    The path provided below has to start and end with a slash "/" in order for
    it to work correctly.

    For more details:
    * https://developer.mozilla.org/en-US/docs/Web/HTML/Element/base

    This is a placeholder for base href that will be replaced by the value of
    the `--base-href` argument provided to `flutter build`.
  -->
  <base href="$FLUTTER_BASE_HREF">

  <meta charset="UTF-8">
  <meta content="IE=Edge" http-equiv="X-UA-Compatible">
  <meta name="description" content="A new Flutter project.">

  <!-- Viewport meta tag -->
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <!-- iOS meta tags & icons -->
  <meta name="mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="black">
  <meta name="apple-mobile-web-app-title" content="portfolio_core">
  <link rel="apple-touch-icon" href="icons/Icon-192.png">

  <!-- Favicon -->
  <link rel="icon" type="image/png" href="favicon.png"/>

  <title>portfolio_core</title>
  <link rel="manifest" href="manifest.json">

  <!-- Firebase SDK -->
  <script src="https://www.gstatic.com/firebasejs/9.6.1/firebase-app-compat.js"></script>
  <script src="https://www.gstatic.com/firebasejs/9.6.1/firebase-auth-compat.js"></script>
  <script src="https://www.gstatic.com/firebasejs/9.6.1/firebase-firestore-compat.js"></script>
  <!-- TODO: Add SDKs for Firebase products that you want to use
       https://firebase.google.com/docs/web/setup#available-libraries -->

  <script>
    // Your web app's Firebase configuration
    // Use the values from lib/firebase_options.dart
    const firebaseConfig = {
      apiKey: "AIzaSyAFlpqcvU61bVTnY_0go9ZgqSwQ3kXX3Z8",
      authDomain: "alialqattandev.firebaseapp.com",
      databaseURL: "https://alialqattandev-default-rtdb.europe-west1.firebasedatabase.app",
      projectId: "alialqattandev",
      storageBucket: "alialqattandev.firebasestorage.app",
      messagingSenderId: "133393946896",
      appId: "1:133393946896:web:20b5449d128c1c90816d95",
      measurementId: "G-J5Q0EX54WB"
    };

    // Initialize Firebase
    firebase.initializeApp(firebaseConfig);
  </script>
</head>
<body>
  <script src="flutter_bootstrap.js" async></script>
</body>
</html>
````

## File: web/manifest.json
````json
{
    "name": "portfolio_core",
    "short_name": "portfolio_core",
    "start_url": ".",
    "display": "standalone",
    "background_color": "#0175C2",
    "theme_color": "#0175C2",
    "description": "A new Flutter project.",
    "orientation": "portrait-primary",
    "prefer_related_applications": false,
    "icons": [
        {
            "src": "icons/Icon-192.png",
            "sizes": "192x192",
            "type": "image/png"
        },
        {
            "src": "icons/Icon-512.png",
            "sizes": "512x512",
            "type": "image/png"
        },
        {
            "src": "icons/Icon-maskable-192.png",
            "sizes": "192x192",
            "type": "image/png",
            "purpose": "maskable"
        },
        {
            "src": "icons/Icon-maskable-512.png",
            "sizes": "512x512",
            "type": "image/png",
            "purpose": "maskable"
        }
    ]
}
````

## File: analysis_options.yaml
````yaml
# This file configures the analyzer, which statically analyzes Dart code to
# check for errors, warnings, and lints.
#
# The issues identified by the analyzer are surfaced in the UI of Dart-enabled
# IDEs (https://dart.dev/tools#ides-and-editors). The analyzer can also be
# invoked from the command line by running `flutter analyze`.

# The following line activates a set of recommended lints for Flutter apps,
# packages, and plugins designed to encourage good coding practices.
include: package:flutter_lints/flutter.yaml

linter:
  # The lint rules applied to this project can be customized in the
  # section below to disable rules from the `package:flutter_lints/flutter.yaml`
  # included above or to enable additional rules. A list of all available lints
  # and their documentation is published at https://dart.dev/lints.
  #
  # Instead of disabling a lint rule for the entire project in the
  # section below, it can also be suppressed for a single line of code
  # or a specific dart file by using the `// ignore: name_of_lint` and
  # `// ignore_for_file: name_of_lint` syntax on the line or in the file
  # producing the lint.
  rules:
    # avoid_print: false  # Uncomment to disable the `avoid_print` rule
    # prefer_single_quotes: true  # Uncomment to enable the `prefer_single_quotes` rule

# Additional information about this file can be found at
# https://dart.dev/guides/language/analysis-options
````

## File: pubspec.lock
````
# Generated by pub
# See https://dart.dev/tools/pub/glossary#lockfile
packages:
  _flutterfire_internals:
    dependency: transitive
    description:
      name: _flutterfire_internals
      sha256: de9ecbb3ddafd446095f7e833c853aff2fa1682b017921fe63a833f9d6f0e422
      url: "https://pub.dev"
    source: hosted
    version: "1.3.54"
  archive:
    dependency: transitive
    description:
      name: archive
      sha256: cb6a278ef2dbb298455e1a713bda08524a175630ec643a242c399c932a0a1f7d
      url: "https://pub.dev"
    source: hosted
    version: "3.6.1"
  args:
    dependency: transitive
    description:
      name: args
      sha256: d0481093c50b1da8910eb0bb301626d4d8eb7284aa739614d2b394ee09e3ea04
      url: "https://pub.dev"
    source: hosted
    version: "2.7.0"
  async:
    dependency: transitive
    description:
      name: async
      sha256: "947bfcf187f74dbc5e146c9eb9c0f10c9f8b30743e341481c1e2ed3ecc18c20c"
      url: "https://pub.dev"
    source: hosted
    version: "2.11.0"
  boolean_selector:
    dependency: transitive
    description:
      name: boolean_selector
      sha256: "6cfb5af12253eaf2b368f07bacc5a80d1301a071c73360d746b7f2e32d762c66"
      url: "https://pub.dev"
    source: hosted
    version: "2.1.1"
  characters:
    dependency: transitive
    description:
      name: characters
      sha256: "04a925763edad70e8443c99234dc3328f442e811f1d8fd1a72f1c8ad0f69a605"
      url: "https://pub.dev"
    source: hosted
    version: "1.3.0"
  clock:
    dependency: transitive
    description:
      name: clock
      sha256: cb6d7f03e1de671e34607e909a7213e31d7752be4fb66a86d29fe1eb14bfb5cf
      url: "https://pub.dev"
    source: hosted
    version: "1.1.1"
  cloud_firestore:
    dependency: "direct main"
    description:
      name: cloud_firestore
      sha256: "89a5e32716794b6a8d0ec1b5dfda988194e92daedaa3f3bed66fa0d0a595252e"
      url: "https://pub.dev"
    source: hosted
    version: "5.6.6"
  cloud_firestore_platform_interface:
    dependency: transitive
    description:
      name: cloud_firestore_platform_interface
      sha256: "9f012844eb59be6827ed97415875c5a29ccacd28bc79bf85b4680738251a33df"
      url: "https://pub.dev"
    source: hosted
    version: "6.6.6"
  cloud_firestore_web:
    dependency: transitive
    description:
      name: cloud_firestore_web
      sha256: b8b754269be0e907acd9ff63ad60f66b84c78d330ca1d7e474f86c9527ddc803
      url: "https://pub.dev"
    source: hosted
    version: "4.4.6"
  collection:
    dependency: transitive
    description:
      name: collection
      sha256: a1ace0a119f20aabc852d165077c036cd864315bd99b7eaa10a60100341941bf
      url: "https://pub.dev"
    source: hosted
    version: "1.19.0"
  crypto:
    dependency: transitive
    description:
      name: crypto
      sha256: "1e445881f28f22d6140f181e07737b22f1e099a5e1ff94b0af2f9e4a463f4855"
      url: "https://pub.dev"
    source: hosted
    version: "3.0.6"
  cupertino_icons:
    dependency: "direct main"
    description:
      name: cupertino_icons
      sha256: ba631d1c7f7bef6b729a622b7b752645a2d076dba9976925b8f25725a30e1ee6
      url: "https://pub.dev"
    source: hosted
    version: "1.0.8"
  fake_async:
    dependency: transitive
    description:
      name: fake_async
      sha256: "511392330127add0b769b75a987850d136345d9227c6b94c96a04cf4a391bf78"
      url: "https://pub.dev"
    source: hosted
    version: "1.3.1"
  ffi:
    dependency: transitive
    description:
      name: ffi
      sha256: "16ed7b077ef01ad6170a3d0c57caa4a112a38d7a2ed5602e0aca9ca6f3d98da6"
      url: "https://pub.dev"
    source: hosted
    version: "2.1.3"
  firebase_app_check:
    dependency: transitive
    description:
      name: firebase_app_check
      sha256: "9c2b9af9204f5255501127b2e62597ead4003121a93eb385732a43e05fb182e3"
      url: "https://pub.dev"
    source: hosted
    version: "0.3.2+5"
  firebase_app_check_platform_interface:
    dependency: transitive
    description:
      name: firebase_app_check_platform_interface
      sha256: bac6ede93128828039f4cf95c5ecd2f7aca0daec41005ec8375b98d8fb470b1c
      url: "https://pub.dev"
    source: hosted
    version: "0.1.1+5"
  firebase_app_check_web:
    dependency: transitive
    description:
      name: firebase_app_check_web
      sha256: d9a406cf2e99917aa20ab2c68c350550e5b0bd448d3095f7eeb48c4673d02797
      url: "https://pub.dev"
    source: hosted
    version: "0.2.0+9"
  firebase_auth:
    dependency: "direct main"
    description:
      name: firebase_auth
      sha256: "54c62b2d187709114dd09ce658a8803ee91f9119b0e0d3fc2245130ad9bff9ad"
      url: "https://pub.dev"
    source: hosted
    version: "5.5.2"
  firebase_auth_platform_interface:
    dependency: transitive
    description:
      name: firebase_auth_platform_interface
      sha256: "5402d13f4bb7f29f2fb819f3b6b5a5a56c9f714aef2276546d397e25ac1b6b8e"
      url: "https://pub.dev"
    source: hosted
    version: "7.6.2"
  firebase_auth_web:
    dependency: transitive
    description:
      name: firebase_auth_web
      sha256: "2be496911f0807895d5fe8067b70b7d758142dd7fb26485cbe23e525e2547764"
      url: "https://pub.dev"
    source: hosted
    version: "5.14.2"
  firebase_core:
    dependency: "direct main"
    description:
      name: firebase_core
      sha256: "017d17d9915670e6117497e640b2859e0b868026ea36bf3a57feb28c3b97debe"
      url: "https://pub.dev"
    source: hosted
    version: "3.13.0"
  firebase_core_platform_interface:
    dependency: transitive
    description:
      name: firebase_core_platform_interface
      sha256: d7253d255ff10f85cfd2adaba9ac17bae878fa3ba577462451163bd9f1d1f0bf
      url: "https://pub.dev"
    source: hosted
    version: "5.4.0"
  firebase_core_web:
    dependency: transitive
    description:
      name: firebase_core_web
      sha256: "129a34d1e0fb62e2b488d988a1fc26cc15636357e50944ffee2862efe8929b23"
      url: "https://pub.dev"
    source: hosted
    version: "2.22.0"
  firebase_data_connect:
    dependency: "direct main"
    description:
      name: firebase_data_connect
      sha256: cb2270ec2f132ed20abdf87fccdc96ea6959b9ca9fda2227c2f5aa0882968579
      url: "https://pub.dev"
    source: hosted
    version: "0.1.4"
  fixnum:
    dependency: transitive
    description:
      name: fixnum
      sha256: b6dc7065e46c974bc7c5f143080a6764ec7a4be6da1285ececdc37be96de53be
      url: "https://pub.dev"
    source: hosted
    version: "1.1.1"
  flutter:
    dependency: "direct main"
    description: flutter
    source: sdk
    version: "0.0.0"
  flutter_highlight:
    dependency: "direct main"
    description:
      name: flutter_highlight
      sha256: "7b96333867aa07e122e245c033b8ad622e4e3a42a1a2372cbb098a2541d8782c"
      url: "https://pub.dev"
    source: hosted
    version: "0.7.0"
  flutter_lints:
    dependency: "direct dev"
    description:
      name: flutter_lints
      sha256: "5398f14efa795ffb7a33e9b6a08798b26a180edac4ad7db3f231e40f82ce11e1"
      url: "https://pub.dev"
    source: hosted
    version: "5.0.0"
  flutter_markdown:
    dependency: "direct main"
    description:
      name: flutter_markdown
      sha256: "634622a3a826d67cb05c0e3e576d1812c430fa98404e95b60b131775c73d76ec"
      url: "https://pub.dev"
    source: hosted
    version: "0.7.7"
  flutter_secure_storage:
    dependency: "direct main"
    description:
      name: flutter_secure_storage
      sha256: "9cad52d75ebc511adfae3d447d5d13da15a55a92c9410e50f67335b6d21d16ea"
      url: "https://pub.dev"
    source: hosted
    version: "9.2.4"
  flutter_secure_storage_linux:
    dependency: transitive
    description:
      name: flutter_secure_storage_linux
      sha256: bf7404619d7ab5c0a1151d7c4e802edad8f33535abfbeff2f9e1fe1274e2d705
      url: "https://pub.dev"
    source: hosted
    version: "1.2.2"
  flutter_secure_storage_macos:
    dependency: transitive
    description:
      name: flutter_secure_storage_macos
      sha256: "6c0a2795a2d1de26ae202a0d78527d163f4acbb11cde4c75c670f3a0fc064247"
      url: "https://pub.dev"
    source: hosted
    version: "3.1.3"
  flutter_secure_storage_platform_interface:
    dependency: transitive
    description:
      name: flutter_secure_storage_platform_interface
      sha256: cf91ad32ce5adef6fba4d736a542baca9daf3beac4db2d04be350b87f69ac4a8
      url: "https://pub.dev"
    source: hosted
    version: "1.1.2"
  flutter_secure_storage_web:
    dependency: transitive
    description:
      name: flutter_secure_storage_web
      sha256: f4ebff989b4f07b2656fb16b47852c0aab9fed9b4ec1c70103368337bc1886a9
      url: "https://pub.dev"
    source: hosted
    version: "1.2.1"
  flutter_secure_storage_windows:
    dependency: transitive
    description:
      name: flutter_secure_storage_windows
      sha256: b20b07cb5ed4ed74fc567b78a72936203f587eba460af1df11281c9326cd3709
      url: "https://pub.dev"
    source: hosted
    version: "3.1.2"
  flutter_test:
    dependency: "direct dev"
    description: flutter
    source: sdk
    version: "0.0.0"
  flutter_web_plugins:
    dependency: transitive
    description: flutter
    source: sdk
    version: "0.0.0"
  google_fonts:
    dependency: "direct main"
    description:
      name: google_fonts
      sha256: b1ac0fe2832c9cc95e5e88b57d627c5e68c223b9657f4b96e1487aa9098c7b82
      url: "https://pub.dev"
    source: hosted
    version: "6.2.1"
  google_identity_services_web:
    dependency: transitive
    description:
      name: google_identity_services_web
      sha256: "55580f436822d64c8ff9a77e37d61f5fb1e6c7ec9d632a43ee324e2a05c3c6c9"
      url: "https://pub.dev"
    source: hosted
    version: "0.3.3"
  googleapis_auth:
    dependency: transitive
    description:
      name: googleapis_auth
      sha256: befd71383a955535060acde8792e7efc11d2fccd03dd1d3ec434e85b68775938
      url: "https://pub.dev"
    source: hosted
    version: "1.6.0"
  grpc:
    dependency: transitive
    description:
      name: grpc
      sha256: e93ee3bce45c134bf44e9728119102358c7cd69de7832d9a874e2e74eb8cab40
      url: "https://pub.dev"
    source: hosted
    version: "3.2.4"
  highlight:
    dependency: "direct main"
    description:
      name: highlight
      sha256: "5353a83ffe3e3eca7df0abfb72dcf3fa66cc56b953728e7113ad4ad88497cf21"
      url: "https://pub.dev"
    source: hosted
    version: "0.7.0"
  http:
    dependency: "direct main"
    description:
      name: http
      sha256: fe7ab022b76f3034adc518fb6ea04a82387620e19977665ea18d30a1cf43442f
      url: "https://pub.dev"
    source: hosted
    version: "1.3.0"
  http2:
    dependency: transitive
    description:
      name: http2
      sha256: "382d3aefc5bd6dc68c6b892d7664f29b5beb3251611ae946a98d35158a82bbfa"
      url: "https://pub.dev"
    source: hosted
    version: "2.3.1"
  http_parser:
    dependency: transitive
    description:
      name: http_parser
      sha256: "178d74305e7866013777bab2c3d8726205dc5a4dd935297175b19a23a2e66571"
      url: "https://pub.dev"
    source: hosted
    version: "4.1.2"
  intl:
    dependency: transitive
    description:
      name: intl
      sha256: d6f56758b7d3014a48af9701c085700aac781a92a87a62b1333b46d8879661cf
      url: "https://pub.dev"
    source: hosted
    version: "0.19.0"
  js:
    dependency: transitive
    description:
      name: js
      sha256: f2c445dce49627136094980615a031419f7f3eb393237e4ecd97ac15dea343f3
      url: "https://pub.dev"
    source: hosted
    version: "0.6.7"
  leak_tracker:
    dependency: transitive
    description:
      name: leak_tracker
      sha256: "7bb2830ebd849694d1ec25bf1f44582d6ac531a57a365a803a6034ff751d2d06"
      url: "https://pub.dev"
    source: hosted
    version: "10.0.7"
  leak_tracker_flutter_testing:
    dependency: transitive
    description:
      name: leak_tracker_flutter_testing
      sha256: "9491a714cca3667b60b5c420da8217e6de0d1ba7a5ec322fab01758f6998f379"
      url: "https://pub.dev"
    source: hosted
    version: "3.0.8"
  leak_tracker_testing:
    dependency: transitive
    description:
      name: leak_tracker_testing
      sha256: "6ba465d5d76e67ddf503e1161d1f4a6bc42306f9d66ca1e8f079a47290fb06d3"
      url: "https://pub.dev"
    source: hosted
    version: "3.0.1"
  lints:
    dependency: transitive
    description:
      name: lints
      sha256: c35bb79562d980e9a453fc715854e1ed39e24e7d0297a880ef54e17f9874a9d7
      url: "https://pub.dev"
    source: hosted
    version: "5.1.1"
  markdown:
    dependency: transitive
    description:
      name: markdown
      sha256: "935e23e1ff3bc02d390bad4d4be001208ee92cc217cb5b5a6c19bc14aaa318c1"
      url: "https://pub.dev"
    source: hosted
    version: "7.3.0"
  matcher:
    dependency: transitive
    description:
      name: matcher
      sha256: d2323aa2060500f906aa31a895b4030b6da3ebdcc5619d14ce1aada65cd161cb
      url: "https://pub.dev"
    source: hosted
    version: "0.12.16+1"
  material_color_utilities:
    dependency: transitive
    description:
      name: material_color_utilities
      sha256: f7142bb1154231d7ea5f96bc7bde4bda2a0945d2806bb11670e30b850d56bdec
      url: "https://pub.dev"
    source: hosted
    version: "0.11.1"
  meta:
    dependency: transitive
    description:
      name: meta
      sha256: bdb68674043280c3428e9ec998512fb681678676b3c54e773629ffe74419f8c7
      url: "https://pub.dev"
    source: hosted
    version: "1.15.0"
  nested:
    dependency: transitive
    description:
      name: nested
      sha256: "03bac4c528c64c95c722ec99280375a6f2fc708eec17c7b3f07253b626cd2a20"
      url: "https://pub.dev"
    source: hosted
    version: "1.0.0"
  path:
    dependency: transitive
    description:
      name: path
      sha256: "087ce49c3f0dc39180befefc60fdb4acd8f8620e5682fe2476afd0b3688bb4af"
      url: "https://pub.dev"
    source: hosted
    version: "1.9.0"
  path_provider:
    dependency: transitive
    description:
      name: path_provider
      sha256: "50c5dd5b6e1aaf6fb3a78b33f6aa3afca52bf903a8a5298f53101fdaee55bbcd"
      url: "https://pub.dev"
    source: hosted
    version: "2.1.5"
  path_provider_android:
    dependency: transitive
    description:
      name: path_provider_android
      sha256: "0ca7359dad67fd7063cb2892ab0c0737b2daafd807cf1acecd62374c8fae6c12"
      url: "https://pub.dev"
    source: hosted
    version: "2.2.16"
  path_provider_foundation:
    dependency: transitive
    description:
      name: path_provider_foundation
      sha256: "4843174df4d288f5e29185bd6e72a6fbdf5a4a4602717eed565497429f179942"
      url: "https://pub.dev"
    source: hosted
    version: "2.4.1"
  path_provider_linux:
    dependency: transitive
    description:
      name: path_provider_linux
      sha256: f7a1fe3a634fe7734c8d3f2766ad746ae2a2884abe22e241a8b301bf5cac3279
      url: "https://pub.dev"
    source: hosted
    version: "2.2.1"
  path_provider_platform_interface:
    dependency: transitive
    description:
      name: path_provider_platform_interface
      sha256: "88f5779f72ba699763fa3a3b06aa4bf6de76c8e5de842cf6f29e2e06476c2334"
      url: "https://pub.dev"
    source: hosted
    version: "2.1.2"
  path_provider_windows:
    dependency: transitive
    description:
      name: path_provider_windows
      sha256: bd6f00dbd873bfb70d0761682da2b3a2c2fccc2b9e84c495821639601d81afe7
      url: "https://pub.dev"
    source: hosted
    version: "2.3.0"
  platform:
    dependency: transitive
    description:
      name: platform
      sha256: "5d6b1b0036a5f331ebc77c850ebc8506cbc1e9416c27e59b439f917a902a4984"
      url: "https://pub.dev"
    source: hosted
    version: "3.1.6"
  plugin_platform_interface:
    dependency: transitive
    description:
      name: plugin_platform_interface
      sha256: "4820fbfdb9478b1ebae27888254d445073732dae3d6ea81f0b7e06d5dedc3f02"
      url: "https://pub.dev"
    source: hosted
    version: "2.1.8"
  protobuf:
    dependency: transitive
    description:
      name: protobuf
      sha256: "68645b24e0716782e58948f8467fd42a880f255096a821f9e7d0ec625b00c84d"
      url: "https://pub.dev"
    source: hosted
    version: "3.1.0"
  provider:
    dependency: "direct main"
    description:
      name: provider
      sha256: "489024f942069c2920c844ee18bb3d467c69e48955a4f32d1677f71be103e310"
      url: "https://pub.dev"
    source: hosted
    version: "6.1.4"
  sky_engine:
    dependency: transitive
    description: flutter
    source: sdk
    version: "0.0.0"
  source_span:
    dependency: transitive
    description:
      name: source_span
      sha256: "53e943d4206a5e30df338fd4c6e7a077e02254531b138a15aec3bd143c1a8b3c"
      url: "https://pub.dev"
    source: hosted
    version: "1.10.0"
  stack_trace:
    dependency: transitive
    description:
      name: stack_trace
      sha256: "9f47fd3630d76be3ab26f0ee06d213679aa425996925ff3feffdec504931c377"
      url: "https://pub.dev"
    source: hosted
    version: "1.12.0"
  stream_channel:
    dependency: transitive
    description:
      name: stream_channel
      sha256: ba2aa5d8cc609d96bbb2899c28934f9e1af5cddbd60a827822ea467161eb54e7
      url: "https://pub.dev"
    source: hosted
    version: "2.1.2"
  string_scanner:
    dependency: transitive
    description:
      name: string_scanner
      sha256: "688af5ed3402a4bde5b3a6c15fd768dbf2621a614950b17f04626c431ab3c4c3"
      url: "https://pub.dev"
    source: hosted
    version: "1.3.0"
  term_glyph:
    dependency: transitive
    description:
      name: term_glyph
      sha256: a29248a84fbb7c79282b40b8c72a1209db169a2e0542bce341da992fe1bc7e84
      url: "https://pub.dev"
    source: hosted
    version: "1.2.1"
  test_api:
    dependency: transitive
    description:
      name: test_api
      sha256: "664d3a9a64782fcdeb83ce9c6b39e78fd2971d4e37827b9b06c3aa1edc5e760c"
      url: "https://pub.dev"
    source: hosted
    version: "0.7.3"
  typed_data:
    dependency: transitive
    description:
      name: typed_data
      sha256: f9049c039ebfeb4cf7a7104a675823cd72dba8297f264b6637062516699fa006
      url: "https://pub.dev"
    source: hosted
    version: "1.4.0"
  url_launcher:
    dependency: "direct main"
    description:
      name: url_launcher
      sha256: "9d06212b1362abc2f0f0d78e6f09f726608c74e3b9462e8368bb03314aa8d603"
      url: "https://pub.dev"
    source: hosted
    version: "6.3.1"
  url_launcher_android:
    dependency: transitive
    description:
      name: url_launcher_android
      sha256: "1d0eae19bd7606ef60fe69ef3b312a437a16549476c42321d5dc1506c9ca3bf4"
      url: "https://pub.dev"
    source: hosted
    version: "6.3.15"
  url_launcher_ios:
    dependency: transitive
    description:
      name: url_launcher_ios
      sha256: "7f2022359d4c099eea7df3fdf739f7d3d3b9faf3166fb1dd390775176e0b76cb"
      url: "https://pub.dev"
    source: hosted
    version: "6.3.3"
  url_launcher_linux:
    dependency: transitive
    description:
      name: url_launcher_linux
      sha256: "4e9ba368772369e3e08f231d2301b4ef72b9ff87c31192ef471b380ef29a4935"
      url: "https://pub.dev"
    source: hosted
    version: "3.2.1"
  url_launcher_macos:
    dependency: transitive
    description:
      name: url_launcher_macos
      sha256: "17ba2000b847f334f16626a574c702b196723af2a289e7a93ffcb79acff855c2"
      url: "https://pub.dev"
    source: hosted
    version: "3.2.2"
  url_launcher_platform_interface:
    dependency: transitive
    description:
      name: url_launcher_platform_interface
      sha256: "552f8a1e663569be95a8190206a38187b531910283c3e982193e4f2733f01029"
      url: "https://pub.dev"
    source: hosted
    version: "2.3.2"
  url_launcher_web:
    dependency: transitive
    description:
      name: url_launcher_web
      sha256: "3ba963161bd0fe395917ba881d320b9c4f6dd3c4a233da62ab18a5025c85f1e9"
      url: "https://pub.dev"
    source: hosted
    version: "2.4.0"
  url_launcher_windows:
    dependency: transitive
    description:
      name: url_launcher_windows
      sha256: "3284b6d2ac454cf34f114e1d3319866fdd1e19cdc329999057e44ffe936cfa77"
      url: "https://pub.dev"
    source: hosted
    version: "3.1.4"
  vector_math:
    dependency: transitive
    description:
      name: vector_math
      sha256: "80b3257d1492ce4d091729e3a67a60407d227c27241d6927be0130c98e741803"
      url: "https://pub.dev"
    source: hosted
    version: "2.1.4"
  vm_service:
    dependency: transitive
    description:
      name: vm_service
      sha256: f6be3ed8bd01289b34d679c2b62226f63c0e69f9fd2e50a6b3c1c729a961041b
      url: "https://pub.dev"
    source: hosted
    version: "14.3.0"
  web:
    dependency: transitive
    description:
      name: web
      sha256: "868d88a33d8a87b18ffc05f9f030ba328ffefba92d6c127917a2ba740f9cfe4a"
      url: "https://pub.dev"
    source: hosted
    version: "1.1.1"
  win32:
    dependency: transitive
    description:
      name: win32
      sha256: daf97c9d80197ed7b619040e86c8ab9a9dad285e7671ee7390f9180cc828a51e
      url: "https://pub.dev"
    source: hosted
    version: "5.10.1"
  xdg_directories:
    dependency: transitive
    description:
      name: xdg_directories
      sha256: "7a3f37b05d989967cdddcbb571f1ea834867ae2faa29725fd085180e0883aa15"
      url: "https://pub.dev"
    source: hosted
    version: "1.1.0"
sdks:
  dart: ">=3.6.2 <4.0.0"
  flutter: ">=3.27.0"
````

## File: pubspec.yaml
````yaml
name: portfolio_core
description: "Core portfolio functionality"
# The following line prevents the package from being accidentally published to
# pub.dev using `flutter pub publish`. This is preferred for private packages.
publish_to: 'none' # Remove this line if you wish to publish to pub.dev

# The following defines the version and build number for your application.
# A version number is three numbers separated by dots, like 1.2.43
# followed by an optional build number separated by a +.
# Both the version and the builder number may be overridden in flutter
# build by specifying --build-name and --build-number, respectively.
# In Android, build-name is used as versionName while build-number used as versionCode.
# Read more about Android versioning at https://developer.android.com/studio/publish/versioning
# In iOS, build-name is used as CFBundleShortVersionString while build-number is used as CFBundleVersion.
# Read more about iOS versioning at
# https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html
# In Windows, build-name is used as the major, minor, and patch parts
# of the product and file versions while build-number is used as the build suffix.
version: 1.0.0+1

environment:
  sdk: ^3.6.2

# Dependencies specify other packages that your package needs in order to work.
# To automatically upgrade your package dependencies to the latest versions
# consider running `flutter pub upgrade --major-versions`. Alternatively,
# dependencies can be manually updated by changing the version numbers below to
# the latest version available on pub.dev. To see which dependencies have newer
# versions available, run `flutter pub outdated`.
dependencies:
  flutter:
    sdk: flutter

  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.8
  google_fonts: ^6.2.1
  provider: ^6.1.4
  url_launcher: ^6.3.1
  http: ^1.2.2
  flutter_markdown: ^0.7.3
  flutter_secure_storage: ^9.2.2
  flutter_highlight: ^0.7.0
  highlight: ^0.7.0
  firebase_core: ^3.13.0 # Use suggested version
  firebase_auth: ^5.5.2
  cloud_firestore: ^5.6.6
  firebase_data_connect: ^0.1.0 # Add the Data Connect package

dev_dependencies:
  flutter_test:
    sdk: flutter

  # The "flutter_lints" package below contains a set of recommended lints to
  # encourage good coding practices. The lint set provided by the package is
  # activated in the `analysis_options.yaml` file located at the root of your
  # package. See that file for information about deactivating specific lint
  # rules and activating additional ones.
  flutter_lints: ^5.0.0

# For information on the generic Dart part of this file, see the
# following page: https://dart.dev/tools/pub/pubspec

# The following section is specific to Flutter packages.
flutter:

  # The following line ensures that the Material Icons font is
  # included with your application, so that you can use the icons in
  # the material Icons class.
  uses-material-design: true

  # To add assets to your application, add an assets section, like this:
  assets:
    - assets/images/ # Declare the whole directory

  # An image asset can refer to one or more resolution-specific "variants", see
  # https://flutter.dev/to/resolution-aware-images

  # For details regarding adding assets from package dependencies, see
  # https://flutter.dev/to/asset-from-package

  # To add custom fonts to your application, add a fonts section here,
  # in this "flutter" section. Each entry in this list should have a
  # "family" key with the font family name, and a "fonts" key with a
  # list giving the asset and other descriptors for the font. For
  # example:
  # fonts:
  #   - family: Schyler
  #     fonts:
  #       - asset: fonts/Schyler-Regular.ttf
  #       - asset: fonts/Schyler-Italic.ttf
  #         style: italic
  #   - family: Trajan Pro
  #     fonts:
  #       - asset: fonts/TrajanPro.ttf
  #       - asset: fonts/TrajanPro_Bold.ttf
  #         weight: 700
  #
  # For details regarding fonts from package dependencies,
  # see https://flutter.dev/to/font-from-package
````

## File: README.md
````markdown
# portfolio_core

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
````
