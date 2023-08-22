import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:universal_html/html.dart' as html;

import 'dart:ui_web' as ui_web; 

class ImageEmbedBuilderWeb extends EmbedBuilder {
  @override
  String get key => BlockEmbed.imageType;

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    Embed node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    final imageUrl = node.value.data;
    if (isImageBase64(imageUrl)) {
      // TODO: handle imageUrl of base64
      return const SizedBox();
    }
    final size = MediaQuery.of(context).size;
    ui_web.platformViewRegistry.registerViewFactory(imageUrl, (viewId) {
      return html.ImageElement()
        ..src = imageUrl
        ..style.height = 'auto'
        ..style.width = 'auto';
    });
    return Padding(
      padding: EdgeInsets.only(
        right: ResponsiveBreakpoints.of(context).smallerThan(TABLET)
            ? size.width * 0.5
            : (ResponsiveBreakpoints.of(context).equals('4K'))
                ? size.width * 0.75
                : size.width * 0.2,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.45,
        child: HtmlElementView(
          viewType: imageUrl,
        ),
      ),
    );
  }
}

List<EmbedBuilder> get defaultEmbedBuildersWeb => [
      ImageEmbedBuilderWeb(),
    ];
