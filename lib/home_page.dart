import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:app/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'web_embeds/web_embeds.dart';

const quillEditorKey = Key('quillEditorKey');

/// Types of selection that person can make when triple clicking
enum _SelectionType {
  none,
  word,
}

/// Home page with the `flutter-quill` editor
class HomePage extends StatefulWidget {
  const HomePage({
    required this.platformService,
    super.key,
  });

  final PlatformService platformService;

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
          document: doc, selection: const TextSelection.collapsed(offset: 0));
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
      onTapUp: (details, p1) {
        return _onTripleClickSelection();
      },
      customStyles: DefaultStyles(
        h1: DefaultTextBlockStyle(
          const TextStyle(
            fontSize: 32,
            color: Colors.black,
            height: 1.15,
            fontWeight: FontWeight.w300,
          ),
          const VerticalSpacing(16, 0),
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
              fontWeight: FontWeight.w300,
            ),
            const VerticalSpacing(16, 0),
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
    final embedButtons = FlutterQuillEmbeds.buttons(
      // Showing only necessary default buttons
      showCameraButton: false,
      showFormulaButton: false,
      showVideoButton: false,
      showImageButton: true,

      // `onImagePickCallback` is called after image (from any platform) is picked
      onImagePickCallback: _onImagePickCallback,

      // `webImagePickImpl` is called after image (from web) is picked and then `onImagePickCallback` is called
      webImagePickImpl: _webImagePickImpl,

      // defining the selector (we only want to open the gallery whenever the person wants to upload an image)
      mediaPickSettingSelector: (context) {
        return Future.value(MediaPickSetting.Gallery);
      },
    );

    // Instantiating the toolbar
    final toolbar = QuillToolbar(
      afterButtonPressed: _focusNode.requestFocus,
      children: [
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
        for (final builder in embedButtons)
          builder(_controller!, toolbarIconSize, null, null),
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
        ],
      ),
    );
  }

  // Renders the image picked by imagePicker from local file storage
  // You can also upload the picked image to any server (eg : AWS s3
  // or Firebase) and then return the uploaded image URL.
  Future<String> _onImagePickCallback(File file) async {
    //return "https://pbs.twimg.com/media/EzmJ_YBVgAEnoF2?format=jpg&name=large";
    if (!widget.platformService.isWebPlatform()) {
      // Copies the picked file from temporary cache to applications directory
      final appDocDir = await getApplicationDocumentsDirectory();
      final copiedFile =
          await file.copy('${appDocDir.path}/${basename(file.path)}');
      return copiedFile.path.toString();
    } else {
      // TODO: This will fail on web
      // Might have to upload to S3 or embed a canvas like https://stackoverflow.com/questions/71798042/flutter-how-do-i-write-a-file-to-local-directory-with-path-provider.

      return file.path;
    }
  }

  /// Callback that is called after an image is picked whilst on the web platform.
  Future<String?> _webImagePickImpl(
      OnImagePickCallback onImagePickCallback) async {
    // Lets the user pick one file; files with any file extension can be selected
    final result = await ImageFilePicker().pickImage();

    // The result will be null, if the user aborted the dialog
    if (result == null || result.files.isEmpty) {
      return null;
    }

    // Read file as bytes (https://github.com/miguelpruivo/flutter_file_picker/wiki/FAQ#q-how-do-i-access-the-path-on-web)
    final platformFile = result.files.first;
    final bytes = platformFile.bytes;

    if (bytes == null) {
      return null;
    }

    final file = File.fromRawPath(bytes);

    return onImagePickCallback(file);
  }
}

// coverage:ignore-start
/// Image file picker wrapper class
class ImageFilePicker {
  Future<FilePickerResult?> pickImage() =>
      FilePicker.platform.pickFiles(type: FileType.image);
}
// coverage:ignore-end
