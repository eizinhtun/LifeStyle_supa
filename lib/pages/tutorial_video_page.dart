//@dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:left_style/localization/translate.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class TutorialVideoPage extends StatefulWidget {
  final String type;
  final String url;

  TutorialVideoPage({Key key, @required this.type, this.url}) : super(key: key);

  @override
  _TutorialVideoPage createState() => _TutorialVideoPage();
}

class _TutorialVideoPage extends State<TutorialVideoPage> {
  YoutubePlayerController _controller;

  var video = "";

  @override
  void initState() {
    super.initState();
  }

  // @override
  // void deactivate() {
  //   // Pauses video while navigating to next page.
  //   _controller.pause();
  //   super.deactivate();
  // }

  // @override
  // void dispose() {
  //   _controller.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    const player = YoutubePlayerIFrame();
    if (widget.url != null && widget.url != "") {
      if (_controller == null) {
        _controller = YoutubePlayerController(
          initialVideoId:
              YoutubePlayerController.convertUrlToId(widget.url.trim()),
          params: const YoutubePlayerParams(
            startAt: const Duration(minutes: 0, seconds: 0),
            autoPlay: true,
            showControls: true,
            showFullscreenButton: true,
            desktopMode: true,
            privacyEnhanced: true,
            useHybridComposition: true,
          ),
        );
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(Tran.of(context).text("tutorial_video").toString()),
        centerTitle: true,
      ),
      body: widget.url == null || widget.url == ""
          ? Center(
              child: SpinKitDoubleBounce(
                color: Theme.of(context).primaryColor,
              ),
            )
          : YoutubePlayerControllerProvider(
              controller: _controller,
              child: Column(
                children: [
                  Container(
                    // height: 300,
                    child: player,
                  ),
                  Expanded(
                    // height: 500,
                    child: Card(
                      elevation: 1,
                      margin: EdgeInsets.only(top: 1),
                      child: ListTile(
                        onTap: () {
                          String videoId;
                          videoId = YoutubePlayerController.convertUrlToId(
                              widget.url.trim());
                          _controller.load(videoId);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget get _space => const SizedBox(height: 10);

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }
}
