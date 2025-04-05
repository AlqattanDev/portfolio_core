import 'package:flutter/material.dart';
import 'package:portfolio_core/models/blog_post.dart';
import 'package:portfolio_core/services/blog_service.dart';
import 'package:portfolio_core/theme/colors.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';
import 'package:portfolio_core/utils/async_helper.dart';
import 'package:portfolio_core/utils/loading_state.dart';
import 'package:portfolio_core/widgets/markdown_editor.dart';
import 'package:provider/provider.dart';

class BlogPostEditScreen extends StatefulWidget {
  final String? postId;

  const BlogPostEditScreen({this.postId, super.key});

  @override
  State<BlogPostEditScreen> createState() => _BlogPostEditScreenState();
}

class _BlogPostEditScreenState extends State<BlogPostEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  // Single LoadingState for all async operations
  late LoadingStateData<BlogPost?> _postState;

  bool get _isEditMode => widget.postId != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _postState = const LoadingStateData();

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
    await AsyncHelper.execute<BlogPost?>(
        operation: () => Provider.of<BlogService>(context, listen: false)
            .getPostById(widget.postId!),
        setStateCallback: (state) => setState(() => _postState = state),
        context: context,
        mounted: mounted,
        onSuccess: (post) {
          if (post != null) {
            _titleController.text = post.title;
            _contentController.text = post.markdownContent;
          }
        },
        onError: (_) {});
  }

  Future<void> _savePost() async {
    if (_postState.isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    final title = _titleController.text;
    final content = _contentController.text;
    final blogService = Provider.of<BlogService>(context, listen: false);

    final result = await AsyncHelper.withLoadingIndicator<bool>(
      context: context,
      operation: () async {
        if (_isEditMode) {
          await blogService.updatePost(widget.postId!, title, content);
        } else {
          await blogService.createPost(title, content);
        }
        return true;
      },
      successMessage: 'Post saved successfully!',
    );

    if (result == true && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeExt = Theme.of(context).extension<PortfolioThemeExtension>()!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Post' : 'Create New Post'),
        actions: [
          if (_postState.isLoading)
            Padding(
              padding: themeExt.smallPadding.copyWith(right: 16.0),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _savePost,
              tooltip: 'Save Post',
            ),
        ],
      ),
      body: _postState.isLoading && _isEditMode
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: themeExt.contentPadding,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_postState.isError)
                      Padding(
                        padding: EdgeInsets.only(bottom: themeExt.itemSpacing),
                        child: Text(
                          _postState.errorMessage!,
                          style: TextStyle(
                            color: AppColors.error,
                          ),
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
                      enabled: !_postState.isLoading,
                      textInputAction: TextInputAction.next,
                    ),
                    themeExt.verticalSpacing,
                    Expanded(
                      child: MarkdownEditor(
                        controller: _contentController,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
