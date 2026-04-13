import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'video_player_state.dart';

class VideoPlayerCubit extends Cubit<VideoPlayerState> {
  VideoPlayerCubit() : super(VideoPlayerState());

  Future<void> initialize() async {
    final String urlVideo =
        "https://avionica.csdevhub.com/s3/manufacturer/aviation_tutorial.mp4";

    try {
      final uri = Uri.tryParse(urlVideo);

      if (uri == null || !uri.hasAbsolutePath) {
        emit(state.copyWith(errorMessage: "Invalid video URL"));
        return;
      }

      final controller = VideoPlayerController.networkUrl(uri);

      await controller.initialize();

      if (!controller.value.isInitialized) {
        emit(state.copyWith(errorMessage: "Video failed to initialize"));
        return;
      }

      if (isClosed) {
        controller.dispose();
        return;
      }

      controller.addListener(_listener);

      emit(
        state.copyWith(
          controller: controller,
          duration: controller.value.duration,
          errorMessage: null,
        ),
      );
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            isPlaying: false,
            errorMessage: "Video not available or failed to load",
          ),
        );
      }
    }
  }

  void _listener() {
    if (isClosed) return;

    final controller = state.controller;
    if (controller == null || !controller.value.isInitialized) return;

    if (controller.value.hasError) {
      emit(
        state.copyWith(
          isPlaying: false,
          errorMessage: controller.value.errorDescription ?? "Playback error",
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isPlaying: controller.value.isPlaying,
        position: controller.value.position,
        duration: controller.value.duration,
        isBuffering: controller.value.isBuffering,
        errorMessage: null,
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

    if (!isClosed) {
      emit(state.copyWith(isMuted: muted));
    }
  }

  @override
  Future<void> close() {
    state.controller?.removeListener(_listener);
    state.controller?.dispose();
    return super.close();
  }
}
