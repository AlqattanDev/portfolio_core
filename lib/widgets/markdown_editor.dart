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
