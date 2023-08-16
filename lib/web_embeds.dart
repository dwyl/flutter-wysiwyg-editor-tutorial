import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'responsive_widget.dart';

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

    return Padding(
      padding: EdgeInsets.only(
        right: ResponsiveWidget.isMediumScreen(context)
            ? size.width * 0.5
            : (ResponsiveWidget.isLargeScreen(context))
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

class VideoEmbedBuilderWeb extends EmbedBuilder {
  @override
  String get key => BlockEmbed.videoType;

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    Embed node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    var videoUrl = node.value.data;
    if (videoUrl.contains('youtube.com') || videoUrl.contains('youtu.be')) {
      final youtubeID = YoutubePlayer.convertUrlToId(videoUrl);
      if (youtubeID != null) {
        videoUrl = 'https://www.youtube.com/embed/$youtubeID';
      }
    }



    return SizedBox(
      height: 500,
      child: HtmlElementView(
        viewType: videoUrl,
      ),
    );
  }
}

List<EmbedBuilder> get defaultEmbedBuildersWeb => [
      ImageEmbedBuilderWeb(),
      VideoEmbedBuilderWeb(),
    ];