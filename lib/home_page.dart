import 'dart:async';
import 'dart:ui';

import 'package:app/emoji_picker_widget.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:http/http.dart' as http;

import 'image_button_widget.dart';
import 'web_embeds/web_embeds.dart';

const quillEditorKey = Key('quillEditorKey');
const emojiButtonKey = Key('emojiButtonKey');

/// Types of selection that person can make when triple clicking
enum _SelectionType {
  none,
  word,
}

/// Home page with the `flutter-quill` editor
class HomePage extends StatefulWidget {
  const HomePage({
    required this.platformService,
    required this.imageFilePicker,
    super.key, required this.client,
  });

  /// Platform service used to check if the user is on mobile.
  final PlatformService platformService;

  /// Image file picker service that opens File Picker and returns result
  final ImageFilePicker imageFilePicker;

  /// HTTP client used to make network requests
  final http.Client client;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  /// `flutter-quill` editor controller
  QuillController? _controller;

  /// Focus node used to obtain keyboard focus and events
  final FocusNode _focusNode = FocusNode();

  /// Selection types for triple clicking
  _SelectionType _selectionType = _SelectionType.none;

  /// Show emoji picker
  bool _offstageEmojiPickerOffstage = true;

  @override
  void initState() {
    super.initState();
    _initializeText();
  }

  /// Initializing the [Delta](https://quilljs.com/docs/delta/) document with sample text.
  Future<void> _initializeText() async {
    // final doc = Document()..insert(0, 'Just a friendly empty text :)');
    final doc = Document();
    setState(() {
      _controller = QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Loading widget if controller's not loaded
    if (_controller == null) {
      return const Scaffold(body: Center(child: Text('Loading...')));
    }

    /// Returning scaffold with editor as body
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Flutter Quill',
        ),
      ),
      body: _buildEditor(context),
    );
  }

  /// Callback called whenever the person taps on the text.
  /// It will select nothing, then the word if another tap is detected
  /// and then the whole text if another tap is detected (triple).
  bool _onTripleClickSelection() {
    final controller = _controller!;

    // If nothing is selected, selection type is `none`
    if (controller.selection.isCollapsed) {
      _selectionType = _SelectionType.none;
    }

    // If nothing is selected, selection type becomes `word
    if (_selectionType == _SelectionType.none) {
      _selectionType = _SelectionType.word;
      return false;
    }

    // If the word is selected, select all text
    if (_selectionType == _SelectionType.word) {
      final child = controller.document.queryChild(
        controller.selection.baseOffset,
      );
      final offset = child.node?.documentOffset ?? 0;
      final length = child.node?.length ?? 0;

      final selection = TextSelection(
        baseOffset: offset,
        extentOffset: offset + length,
      );

      // Select all text and make next selection to `none`
      controller.updateSelection(selection, ChangeSource.REMOTE);

      _selectionType = _SelectionType.none;

      return true;
    }

    return false;
  }

  /// Callback called whenever the person taps on the emoji button in the toolbar.
  /// It shows/hides the emoji picker and focus/unfocusses the keyboard accordingly.
  void _onEmojiButtonPressed(BuildContext context) {
    final isEmojiPickerShown = !_offstageEmojiPickerOffstage;

    // If emoji picker is being shown, we show the keyboard and hide the emoji picker.
    if (isEmojiPickerShown) {
      _focusNode.requestFocus();
      setState(() {
        _offstageEmojiPickerOffstage = true;
      });
    }

    // Otherwise, we do the inverse.
    else {
      // Unfocusing when the person clicks away. This is to hide the keyboard.
      // See https://flutterigniter.com/dismiss-keyboard-form-lose-focus/
      // and https://www.youtube.com/watch?v=MKrEJtheGPk&t=40s&ab_channel=HeyFlutter%E2%80%A4com.
      final currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        //currentFocus.unfocus();
      }

      setState(() {
        _offstageEmojiPickerOffstage = false;
      });
    }
  }

  /// Build the `flutter-quill` editor to be shown on screen.
  Widget _buildEditor(BuildContext context) {
    // Default editor (for mobile devices)
    Widget quillEditor = QuillEditor(
      controller: _controller!,
      scrollController: ScrollController(),
      scrollable: true,
      focusNode: _focusNode,
      autoFocus: false,
      readOnly: false,
      placeholder: 'Write what\'s on your mind.',
      enableSelectionToolbar: isMobile(),
      expands: false,
      padding: EdgeInsets.zero,
      onTapDown: (details, p1) {
        // When the person taps on the text, we want to hide the emoji picker
        // so only the keyboard is shown
        setState(() {
          _offstageEmojiPickerOffstage = true;
        });
        return false;
      },
      onTapUp: (details, p1) {
        return _onTripleClickSelection();
      },
      customStyles: DefaultStyles(
        h1: DefaultTextBlockStyle(
          const TextStyle(
            fontSize: 32,
            color: Colors.black,
            height: 1.15,
            fontWeight: FontWeight.w600,
          ),
          const VerticalSpacing(16, 0),
          const VerticalSpacing(0, 0),
          null,
        ),
        h2: DefaultTextBlockStyle(
          const TextStyle(
            fontSize: 24,
            color: Colors.black87,
            height: 1.15,
            fontWeight: FontWeight.w600,
          ),
          const VerticalSpacing(8, 0),
          const VerticalSpacing(0, 0),
          null,
        ),
        h3: DefaultTextBlockStyle(
          const TextStyle(
            fontSize: 20,
            color: Colors.black87,
            height: 1.25,
            fontWeight: FontWeight.w600,
          ),
          const VerticalSpacing(8, 0),
          const VerticalSpacing(0, 0),
          null,
        ),
        sizeSmall: const TextStyle(fontSize: 9),
        subscript: const TextStyle(
          fontFamily: 'SF-UI-Display',
          fontFeatures: [FontFeature.subscripts()],
        ),
        superscript: const TextStyle(
          fontFamily: 'SF-UI-Display',
          fontFeatures: [FontFeature.superscripts()],
        ),
      ),
      embedBuilders: [...FlutterQuillEmbeds.builders()],
    );

    // Alternatively, the web editor version is shown  (with the web embeds)
    if (widget.platformService.isWebPlatform()) {
      quillEditor = QuillEditor(
        controller: _controller!,
        scrollController: ScrollController(),
        scrollable: true,
        focusNode: _focusNode,
        autoFocus: false,
        readOnly: false,
        placeholder: 'Add content',
        expands: false,
        padding: EdgeInsets.zero,
        onTapUp: (details, p1) {
          return _onTripleClickSelection();
        },
        customStyles: DefaultStyles(
          h1: DefaultTextBlockStyle(
            const TextStyle(
              fontSize: 32,
              color: Colors.black,
              height: 1.15,
              fontWeight: FontWeight.w600,
            ),
            const VerticalSpacing(16, 0),
            const VerticalSpacing(0, 0),
            null,
          ),
          h2: DefaultTextBlockStyle(
            const TextStyle(
              fontSize: 24,
              color: Colors.black87,
              height: 1.15,
              fontWeight: FontWeight.w600,
            ),
            const VerticalSpacing(8, 0),
            const VerticalSpacing(0, 0),
            null,
          ),
          h3: DefaultTextBlockStyle(
            const TextStyle(
              fontSize: 20,
              color: Colors.black87,
              height: 1.25,
              fontWeight: FontWeight.w600,
            ),
            const VerticalSpacing(8, 0),
            const VerticalSpacing(0, 0),
            null,
          ),
          sizeSmall: const TextStyle(fontSize: 9),
        ),
        embedBuilders: [...defaultEmbedBuildersWeb],
      );
    }

    // Toolbar definitions
    const toolbarIconSize = 18.0;

    // Instantiating the toolbar
    final toolbar = QuillToolbar(
      afterButtonPressed: _focusNode.requestFocus,
      children: [
        CustomButton(
          key: emojiButtonKey,
          onPressed: () => _onEmojiButtonPressed(context),
          icon: Icons.emoji_emotions,
          iconSize: toolbarIconSize,
        ),
        HistoryButton(
          icon: Icons.undo_outlined,
          iconSize: toolbarIconSize,
          controller: _controller!,
          undo: true,
        ),
        HistoryButton(
          icon: Icons.redo_outlined,
          iconSize: toolbarIconSize,
          controller: _controller!,
          undo: false,
        ),
        SelectHeaderStyleButton(
          controller: _controller!,
          axis: Axis.horizontal,
          iconSize: toolbarIconSize,
          attributes: const [Attribute.h1, Attribute.h2, Attribute.h3],
        ),
        ToggleStyleButton(
          attribute: Attribute.bold,
          icon: Icons.format_bold,
          iconSize: toolbarIconSize,
          controller: _controller!,
        ),
        ToggleStyleButton(
          attribute: Attribute.italic,
          icon: Icons.format_italic,
          iconSize: toolbarIconSize,
          controller: _controller!,
        ),
        ToggleStyleButton(
          attribute: Attribute.underline,
          icon: Icons.format_underline,
          iconSize: toolbarIconSize,
          controller: _controller!,
        ),
        ToggleStyleButton(
          attribute: Attribute.strikeThrough,
          icon: Icons.format_strikethrough,
          iconSize: toolbarIconSize,
          controller: _controller!,
        ),
        LinkStyleButton(
          controller: _controller!,
          iconSize: toolbarIconSize,
          linkRegExp: RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+'),
        ),
        ImageToolbarButton(
          controller: _controller!,
          client: widget.client,
          imageFilePicker: widget.imageFilePicker,
          platformService: widget.platformService,
          toolbarIconSize: toolbarIconSize,
        ),
      ],
    );

    // Rendering the final editor + toolbar
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 15,
            child: Container(
              key: quillEditorKey,
              color: Colors.white,
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: quillEditor,
            ),
          ),
          Container(child: toolbar),
          OffstageEmojiPicker(
            offstageEmojiPicker: _offstageEmojiPickerOffstage,
            quillController: _controller,
          ),
        ],
      ),
    );
  }
}
