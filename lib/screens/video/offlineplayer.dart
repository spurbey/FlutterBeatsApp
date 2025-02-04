import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Beats/data/data.dart';
import 'package:video_player/video_player.dart';

class OfflineVideoPlayer extends StatefulWidget {
  final Video video;
  OfflineVideoPlayer({Key? key, required this.video}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<OfflineVideoPlayer> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  @override
  void initState() {
    _controller = VideoPlayerController.asset(widget.video.asset);
    // _controller = VideoPlayerController.network(
    //   widget.video.url,
    // );

    _initializeVideoPlayerFuture = _controller.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.pink,
        title: Text(
          widget.video.title,
          style: GoogleFonts.lato(),
        ),
      ),
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white30.withOpacity(0.2),
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.orangeAccent,
        ),
      ),
    );
  }
}
