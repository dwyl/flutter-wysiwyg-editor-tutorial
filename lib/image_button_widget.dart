import 'dart:convert';
import 'dart:io';

import 'package:app/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

const imageButtonKey = Key('imageButtonKey');

/// Image button shown in the toolbar to embed images in the editor
class ImageToolbarButton extends StatelessWidget {
  // Dependency injectors
  final http.Client client;
  final PlatformService platformService;
  final ImageFilePicker imageFilePicker;

  // Quill arguments
  final double toolbarIconSize;
  final QuillController controller;

  const ImageToolbarButton({
    required this.toolbarIconSize,
    required this.platformService,
    required this.imageFilePicker,
    required this.controller,
    required this.client, super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      key: imageButtonKey,
      onPressed: () async {
        final result = await imageFilePicker.pickImage();

        // The result will be null, if the user aborted the dialog
        if (result == null || result.files.isEmpty) {
          return;
        }

        // Check if it is web-based or not and act accordingly
        String? imagePath;
        if (platformService.isWebPlatform()) {
          imagePath = await _webPickCallback(result);
        } else {
          imagePath = await _onMobileCallback(result);
        }

        if (imagePath == null) {
          return;
        }

        // Embed the image in the editor
        final index = controller.selection.baseOffset;
        final length = controller.selection.extentOffset - index;
        controller.replaceText(index, length, BlockEmbed.image(imagePath), null);
      },
      icon: Icons.image,
      iconSize: toolbarIconSize,
    );
  }

  /// Returns the file path of the chosen file on mobile platforms.
  Future<String> _onMobileCallback(FilePickerResult result) async {
    final file = File(result.files.single.path!);

    final appDocDir = await getApplicationDocumentsDirectory();
    final path = '${appDocDir.path}/${basename(file.path)}';
    final copiedFile = await file.copy(path);

    return copiedFile.path.toString();
  }

  /// Callback that is called after an image is picked whilst on the web platform.
  /// Returns the URL path of the image.
  /// Returns null if an error occurred uploading the file or the image was not picked.
  Future<String?> _webPickCallback(FilePickerResult result) async {
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
    return client.send(request).then((response) async {
      if (response.statusCode != 200) {
        return null;
      }

      final responseStream = await http.Response.fromStream(response);
      final responseData = json.decode(responseStream.body);
      return responseData['url'];
    });
  }
}
