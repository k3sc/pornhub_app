import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerScreen({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isFullScreen = false;
  double _brightness = 0.5;
  double _volume = 0.5;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            },
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
          if (!_isFullScreen)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black.withOpacity(0.4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        });
                      },
                      icon: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                        colors: VideoProgressColors(
                          playedColor: Colors.white,
                          bufferedColor: Colors.white.withOpacity(0.5),
                          backgroundColor: Colors.grey,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _toggleFullScreen,
                      icon: Icon(
                        Icons.fullscreen,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (_isFullScreen)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                    Slider(
                      value: _volume,
                      onChanged: (value) {
                        setState(() {
                          _volume = value;
                          _controller.setVolume(_volume);
                        });
                      },
                      min: 0.0,
                      max: 1.0,
                      activeColor: Colors.white,
                      inactiveColor: Colors.white.withOpacity(0.5),
                      label: '$_volume',
                    ),
                    SizedBox(height: 16),
                    Slider(
                      value: _brightness,
                      onChanged: (value) {
                        setState(() {
                          _brightness = value;
                        });
                        // Set screen brightness
                      },
                      min: 0.0,
                      max: 1.0,
                      activeColor: Colors.white,
                      inactiveColor: Colors.white.withOpacity(0.5),
                      label: '$_brightness',
                    ),
                    IconButton(
                      onPressed: _toggleFullScreen,
                      icon: Icon(
                        Icons.fullscreen_exit,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
