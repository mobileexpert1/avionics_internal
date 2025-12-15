import 'package:video_player/video_player.dart';

class VideoPlayerState {
  final VideoPlayerController? controller;
  final bool isPlaying;
  final bool isMuted;
  final Duration position;
  final Duration duration;
  final bool isBuffering;
  final bool isFullScreen;

  VideoPlayerState({
    this.controller,
    this.isPlaying = false,
    this.isMuted = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.isBuffering = false,
    this.isFullScreen = false,
  });

  VideoPlayerState copyWith({
    VideoPlayerController? controller,
    bool? isPlaying,
    bool? isMuted,
    Duration? position,
    Duration? duration,
    bool? isBuffering,
    bool? isFullScreen,
  }) {
    return VideoPlayerState(
      controller: controller ?? this.controller,
      isPlaying: isPlaying ?? this.isPlaying,
      isMuted: isMuted ?? this.isMuted,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isBuffering: isBuffering ?? this.isBuffering,
      isFullScreen: isFullScreen ?? this.isFullScreen,
    );
  }
}
