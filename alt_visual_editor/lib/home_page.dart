import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:visual_editor/document/models/attributes/attributes.model.dart';
import 'package:visual_editor/visual-editor.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

const quillEditorKey = Key('quillEditorKey');

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
  EditorController? _controller;

  /// Focus node used to obtain keyboard focus and events
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initializeText();
  }

  /// Initializing the [Delta](https://quilljs.com/docs/delta/) document with sample text.
  Future<void> _initializeText() async {
    // final doc = Document()..insert(0, 'Just a friendly empty text :)');
    final doc = DeltaDocM();
    setState(() {
      _controller = EditorController(
        document: doc,
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
          'Visual Editor',
        ),
      ),
      body: _buildEditor(context),
    );
  }

  /// Build the `flutter-quill` editor to be shown on screen.
  Widget _buildEditor(BuildContext context) {
    // Default editor (for mobile devices)
    Widget quillEditor = VisualEditor(
      controller: _controller!,
      scrollController: ScrollController(),
      focusNode: _focusNode,
      config: EditorConfigM(
        scrollable: true,
        autoFocus: false,
        readOnly: false,
        placeholder: 'Write what\'s on your mind.',
        enableInteractiveSelection: true,
        expands: false,
        padding: EdgeInsets.zero,
        customStyles: const EditorStylesM(
          h1: TextBlockStyleM(
            TextStyle(
              fontSize: 32,
              color: Colors.black,
              height: 1.15,
              fontWeight: FontWeight.w300,
            ),
            VerticalSpacing(top: 16, bottom: 0),
            VerticalSpacing(top: 0, bottom: 0),
            VerticalSpacing(top: 16, bottom: 0),
            null,
          ),
          sizeSmall: TextStyle(fontSize: 9),
        ),
      ),
    );

    // Alternatively, the web editor version is shown  (with the web embeds)
    if (widget.platformService.isWebPlatform()) {
      quillEditor = VisualEditor(
        controller: _controller!,
        scrollController: ScrollController(),
        focusNode: _focusNode,
        config: EditorConfigM(
          scrollable: true,
          enableInteractiveSelection: false,
          autoFocus: false,
          readOnly: false,
          placeholder: 'Add content',
          expands: false,
          padding: EdgeInsets.zero,
          customStyles: const EditorStylesM(
            h1: TextBlockStyleM(
              TextStyle(
                fontSize: 32,
                color: Colors.black,
                height: 1.15,
                fontWeight: FontWeight.w300,
              ),
              VerticalSpacing(top: 16, bottom: 0),
              VerticalSpacing(top: 0, bottom: 0),
              VerticalSpacing(top: 16, bottom: 0),
              null,
            ),
            sizeSmall: TextStyle(fontSize: 9),
          ),
        ),
      );
    }

    // Toolbar definitions
    const toolbarIconSize = 18.0;
    const toolbarButtonSpacing = 2.5;

    // Instantiating the toolbar
    final toolbar = EditorToolbar(
      children: [
        HistoryButton(
          buttonsSpacing: toolbarButtonSpacing,
          icon: Icons.undo_outlined,
          iconSize: toolbarIconSize,
          controller: _controller!,
          isUndo: true,
        ),
        HistoryButton(
          buttonsSpacing: toolbarButtonSpacing,
          icon: Icons.redo_outlined,
          iconSize: toolbarIconSize,
          controller: _controller!,
          isUndo: false,
        ),
        ToggleStyleButton(
          buttonsSpacing: toolbarButtonSpacing,
          attribute: AttributesM.bold,
          icon: Icons.format_bold,
          iconSize: toolbarIconSize,
          controller: _controller!,
        ),
        ToggleStyleButton(
          buttonsSpacing: toolbarButtonSpacing,
          attribute: AttributesM.italic,
          icon: Icons.format_italic,
          iconSize: toolbarIconSize,
          controller: _controller!,
        ),
        ToggleStyleButton(
          buttonsSpacing: toolbarButtonSpacing,
          attribute: AttributesM.underline,
          icon: Icons.format_underline,
          iconSize: toolbarIconSize,
          controller: _controller!,
        ),
        ToggleStyleButton(
          buttonsSpacing: toolbarButtonSpacing,
          attribute: AttributesM.strikeThrough,
          icon: Icons.format_strikethrough,
          iconSize: toolbarIconSize,
          controller: _controller!,
        ),

        // Our embed buttons
        ImageButton(
          icon: Icons.image,
          iconSize: toolbarIconSize,
          buttonsSpacing: toolbarButtonSpacing,
          controller: _controller!,
          onImagePickCallback: _onImagePickCallback,
          webImagePickImpl: _webImagePickImpl,
          mediaPickSettingSelector: (context) {
            return Future.value(MediaPickSettingE.Gallery);
          },
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
        ],
      ),
    );
  }

  /// Renders the image picked by imagePicker from local file storage
  /// You can also upload the picked image to any server (eg : AWS s3
  /// or Firebase) and then return the uploaded image URL.
  ///
  /// It's only called on mobile platforms.
  Future<String> _onImagePickCallback(File file) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final copiedFile = await file.copy('${appDocDir.path}/${basename(file.path)}');
    return copiedFile.path.toString();
  }

  /// Callback that is called after an image is picked whilst on the web platform.
  /// Returns the URL of the image.
  /// Returns null if an error occurred uploading the file or the image was not picked.
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

    // Make HTTP request to upload the image to the file
    const apiURL = 'https://imgup.fly.dev/api/images';
    final request = http.MultipartRequest('POST', Uri.parse(apiURL));

    final httpImage = http.MultipartFile.fromBytes(
      'image',
      bytes,
      contentType: MediaType.parse(lookupMimeType('', headerBytes: bytes)!),
      filename: platformFile.name,
    );
    request.files.add(httpImage);

    // Check the response and handle accordingly
    return http.Client().send(request).then((response) async {
      if (response.statusCode != 200) {
        return null;
      }

      final responseStream = await http.Response.fromStream(response);
      final responseData = json.decode(responseStream.body);
      return responseData['url'];
    });
  }
}

// coverage:ignore-start
/// Image file picker wrapper class
class ImageFilePicker {
  Future<FilePickerResult?> pickImage() => FilePicker.platform.pickFiles(type: FileType.image);
}
// coverage:ignore-end
