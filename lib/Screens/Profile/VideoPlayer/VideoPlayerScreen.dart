import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:video_player/video_player.dart';

import '../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../Constants/ConstantStrings.dart';
import '../../../Constants/constantImages.dart';
import '../../../CustomFiles/CustomAppBar.dart';
import '../../../bloc/Profile/VideoPlayer/video_player_cubit.dart';
import '../../../bloc/Profile/VideoPlayer/video_player_state.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = VideoPlayerCubit();
    _cubit.initialize();
    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.videoPlayerScreen,
    );
  }

  @override
  void dispose() {
    _cubit.close();
    _cubit.state.controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<VideoPlayerCubit, VideoPlayerState>(
        builder: (context, state) {
          final cubit = context.read<VideoPlayerCubit>();

          // --- Loading State ---
          if (state.controller == null ||
              !state.controller!.value.isInitialized) {
            return Scaffold(
              backgroundColor: Colors.black,
              appBar: CustomAppBar(
                title: ConstantStrings.tutorialScreen,
                centerTitle: false,
                leftButton: IconButton(
                  icon: SvgPicture.asset(
                    CommonUi.setSvgImage(AssetsPath.backArrowButton),
                    fit: BoxFit.cover,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          // --- Video Player UI ---
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: CustomAppBar(
              title: ConstantStrings.tutorialScreen,
              centerTitle: false,
              leftButton: IconButton(
                icon: SvgPicture.asset(
                  CommonUi.setSvgImage(AssetsPath.backArrowButton),
                  fit: BoxFit.cover,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: state.controller!.value.aspectRatio,
                      child: Stack(
                        children: [
                          VideoPlayer(state.controller!),

                          if (state.isBuffering)
                            const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),

                          _controls(context, state, cubit),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: _progressBar(context, state, cubit),
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ------------------------------
  // CONTROLS
  // ------------------------------
  Widget _controls(
    BuildContext context,
    VideoPlayerState state,
    VideoPlayerCubit cubit,
  ) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 65,
          color: Colors.black54,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                color: Colors.white,
                iconSize: 28,
                icon: const Icon(Icons.replay_10),
                onPressed: cubit.seekBackward,
              ),
              IconButton(
                color: Colors.white,
                iconSize: 40,
                icon: Icon(state.isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: cubit.playPause,
              ),
              IconButton(
                color: Colors.white,
                iconSize: 28,
                icon: const Icon(Icons.forward_10),
                onPressed: cubit.seekForward,
              ),
              IconButton(
                color: Colors.white,
                iconSize: 28,
                icon: Icon(state.isMuted ? Icons.volume_off : Icons.volume_up),
                onPressed: cubit.toggleMute,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------------------
  // PROGRESS BAR
  // ------------------------------
  Widget _progressBar(
    BuildContext context,
    VideoPlayerState state,
    VideoPlayerCubit cubit,
  ) {
    return Slider(
      activeColor: Colors.red,
      inactiveColor: Colors.white30,
      value: state.position.inSeconds.toDouble().clamp(
        0.0,
        state.duration.inSeconds.toDouble(),
      ),
      max: state.duration.inSeconds.toDouble(),
      onChanged: (value) {
        cubit.state.controller?.seekTo(Duration(seconds: value.toInt()));
      },
    );
  }
}
