import 'package:flutter/material.dart';
import 'package:portfolio_core/services/blog_service.dart';
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
