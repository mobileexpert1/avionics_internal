import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import '../../../../CustomFiles/onboarding_model.dart';
import '../../../../bloc/Profile/VideoPlayer/video_player_cubit.dart';
import '../../../../bloc/Profile/VideoPlayer/video_player_state.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingInfo info;

  const OnboardingPage({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    double responsiveFontSize(double baseSize) {
      final width = size.width;
      if (kIsWeb) return (baseSize * (width / 600)).clamp(baseSize * 0.8, baseSize * 1.2);
      return baseSize * (width / 375);
    }

    Widget buildTitle(String text, double baseSize) => Text(
      text,
      style: TextStyle(
        fontSize: responsiveFontSize(baseSize),
        fontWeight: FontWeight.w600,
        color: const Color(0xFF2E2E3A),
      ),
    );

    Widget buildDescription(String text, double baseSize, {Color? color}) => Text(
      text,
      style: TextStyle(
        fontSize: responsiveFontSize(baseSize),
        color: color ?? Colors.grey[600],
      ),
    );

    Widget buildVideo(double height) => BlocProvider(
      create: (_) => VideoPlayerCubit()..initialize(),
      child: BlocBuilder<VideoPlayerCubit, VideoPlayerState>(
        builder: (context, state) {
          final cubit = context.read<VideoPlayerCubit>();

          if (state.controller == null || !state.controller!.value.isInitialized) {
            return const Center(child: CircularProgressIndicator());
          }

          return SizedBox(
            width: double.infinity,
            height: height,
            child: Stack(
              children: [
                Positioned.fill(
                  child: AspectRatio(
                    aspectRatio: state.controller!.value.aspectRatio,
                    child: VideoPlayer(state.controller!),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.replay_10, color: Colors.white),
                          onPressed: cubit.seekBackward,
                        ),
                        IconButton(
                          icon: Icon(
                            state.isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                          ),
                          onPressed: cubit.playPause,
                        ),
                        IconButton(
                          icon: const Icon(Icons.forward_10, color: Colors.white),
                          onPressed: cubit.seekForward,
                        ),
                        IconButton(
                          icon: Icon(
                            state.isMuted ? Icons.volume_off : Icons.volume_up,
                            color: Colors.white,
                          ),
                          onPressed: cubit.toggleMute,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    // ---------------- WEB ----------------
    if (kIsWeb) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (info.videoUrl == "") ...[
            SizedBox(
              width: double.infinity,
              height: size.height * 0.65,
              child: info.imageWidget,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 75),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTitle(info.title, 30),
                    const SizedBox(height: 20),
                    buildDescription(info.description, 20),
                  ],
                ),
              ),
            ),
          ],
          if (info.videoUrl != "") ...[
            buildVideo(size.height * 0.88),
          ],
        ],
      );
    }

    // ---------------- MOBILE ----------------
    return SizedBox.expand(
      child: Stack(
        children: [
          if (info.videoUrl == "") ...[
            Positioned(top: 0, left: 0, right: 0, child: info.imageWidget),
            Positioned(
              top: size.height * 0.62,
              left: size.width * 0.13,
              right: size.width * 0.04,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTitle(info.title, 24),
                  SizedBox(height: size.height * 0.015),
                  buildDescription(info.description, 14),
                ],
              ),
            ),
          ],
          if (info.videoUrl != "") ...[
            Positioned(
              top: size.height * 0.1,
              left: 0,
              right: 0,
              child: buildVideo(size.height * 0.75),
            ),
          ],
        ],
      ),
    );
  }
}
