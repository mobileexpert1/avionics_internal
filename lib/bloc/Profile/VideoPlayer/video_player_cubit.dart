import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'video_player_state.dart';

class VideoPlayerCubit extends Cubit<VideoPlayerState> {
  VideoPlayerCubit() : super(VideoPlayerState());

  Future<void> initialize() async {
    final String urlVideo =
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4";

    final controller = VideoPlayerController.networkUrl(Uri.parse(urlVideo));

    await controller.initialize();
    controller.addListener(_listener);

    emit(
      state.copyWith(
        controller: controller,
        duration: controller.value.duration,
      ),
    );
  }

  void _listener() {
    final controller = state.controller;
    if (controller == null) return;

    emit(
      state.copyWith(
        isPlaying: controller.value.isPlaying,
        position: controller.value.position,
        duration: controller.value.duration,
        isBuffering: controller.value.isBuffering,
      ),
    );
  }

  void playPause() {
    final controller = state.controller;
    if (controller == null) return;
    controller.value.isPlaying ? controller.pause() : controller.play();
  }

  void seekForward() {
    final controller = state.controller;
    if (controller == null) return;
    controller.seekTo(controller.value.position + const Duration(seconds: 10));
  }

  void seekBackward() {
    final controller = state.controller;
    if (controller == null) return;
    controller.seekTo(controller.value.position - const Duration(seconds: 10));
  }

  void toggleMute() {
    final controller = state.controller;
    if (controller == null) return;
    final muted = !state.isMuted;
    controller.setVolume(muted ? 0 : 1);
    emit(state.copyWith(isMuted: muted));
  }

  @override
  Future<void> close() {
    state.controller?.dispose();
    return super.close();
  }
}
