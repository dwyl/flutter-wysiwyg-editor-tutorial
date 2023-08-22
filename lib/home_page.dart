import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mime/mime.dart';

import 'web_embeds.dart';

enum _SelectionType {
  none,
  word,
  // line,
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  QuillController? _controller;
  final FocusNode _focusNode = FocusNode();
  _SelectionType _selectionType = _SelectionType.none;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializeText();
  }

  Future<void> _initializeText() async {
    final doc = Document()..insert(0, 'Just a friendly empty text :)');
    setState(() {
      _controller = QuillController(document: doc, selection: const TextSelection.collapsed(offset: 0));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Scaffold(body: Center(child: Text('Loading...')));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Flutter Quill',
        ),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: Text(_controller!.document.toPlainText([...FlutterQuillEmbeds.builders()])),
              ),
            ),
            icon: const Icon(Icons.text_fields_rounded),
          )
        ],
      ),
      body: _buildWelcomeEditor(context),
    );
  }

  bool _onTripleClickSelection() {
    final controller = _controller!;

    // If you want to select all text after paragraph, uncomment this line
    // if (_selectionType == _SelectionType.line) {
    //   final selection = TextSelection(
    //     baseOffset: 0,
    //     extentOffset: controller.document.length,
    //   );

    //   controller.updateSelection(selection, ChangeSource.REMOTE);

    //   _selectionType = _SelectionType.none;

    //   return true;
    // }

    if (controller.selection.isCollapsed) {
      _selectionType = _SelectionType.none;
    }

    if (_selectionType == _SelectionType.none) {
      _selectionType = _SelectionType.word;
      return false;
    }

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

      controller.updateSelection(selection, ChangeSource.REMOTE);

      // _selectionType = _SelectionType.line;

      _selectionType = _SelectionType.none;

      return true;
    }

    return false;
  }

  Widget _buildWelcomeEditor(BuildContext context) {
    Widget quillEditor = QuillEditor(
      controller: _controller!,
      scrollController: ScrollController(),
      scrollable: true,
      focusNode: _focusNode,
      autoFocus: false,
      readOnly: false,
      placeholder: 'Add content',
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
            null),
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
    if (kIsWeb) {
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
                null),
            sizeSmall: const TextStyle(fontSize: 9),
          ),
          embedBuilders: [...defaultEmbedBuildersWeb]);
    }

    const toolbarIconSize = 18.0;
    final embedButtons = FlutterQuillEmbeds.buttons(
      showCameraButton: false,
      showFormulaButton: false,
      showVideoButton: false,
      showImageButton: true,

      // provide a callback to enable picking images from device.
      // if omit, "image" button only allows adding images from url.
      // same goes for videos.
      onImagePickCallback: _onImagePickCallback,
      webImagePickImpl: _webImagePickImpl,
      mediaPickSettingSelector: (context) {
        return Future.value(MediaPickSetting.Gallery);
      },
      // uncomment to provide a custom "pick from" dialog.
      // mediaPickSettingSelector: _selectMediaPickSetting,
      // uncomment to provide a custom "pick from" dialog.
      // cameraPickSettingSelector: _selectCameraPickSetting,
    );
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
        for (final builder in embedButtons) builder(_controller!, toolbarIconSize, null, null),
      ],
    );

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 15,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: quillEditor,
            ),
          ),
          Container(child: toolbar)
        ],
      ),
    );
  }

  // Renders the image picked by imagePicker from local file storage
  // You can also upload the picked image to any server (eg : AWS s3
  // or Firebase) and then return the uploaded image URL.
  Future<String> _onImagePickCallback(File file) async {
    if (!kIsWeb) {
      // Copies the picked file from temporary cache to applications directory
      final appDocDir = await getApplicationDocumentsDirectory();
      final copiedFile = await file.copy('${appDocDir.path}/${basename(file.path)}');
      return copiedFile.path.toString();
    } else {
      // TODO: This will fail on web
      // Might have to upload to S3 or embed a canvas like https://stackoverflow.com/questions/71798042/flutter-how-do-i-write-a-file-to-local-directory-with-path-provider.

      return file.path;
    }
  }

  Future<String?> _webImagePickImpl(OnImagePickCallback onImagePickCallback) async {
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
  Future<FilePickerResult?> pickImage() => FilePicker.platform.pickFiles(type: FileType.image);
}
// coverage:ignore-end
