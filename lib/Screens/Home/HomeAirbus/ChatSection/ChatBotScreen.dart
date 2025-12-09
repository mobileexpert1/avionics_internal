import 'dart:async';
import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../Constants/constantImages.dart';
import '../../../../bloc/home/chatSection/ChatBot/ChatCubit.dart';
import 'ChatHistoryScreen.dart';

class AskWilcoScreen extends StatefulWidget {
  const AskWilcoScreen({
    super.key,
    required this.accessToken,
    required this.isComeFromTab,
    required this.sessionId,
    required this.title,
  });

  final String accessToken;
  final bool isComeFromTab;
  final String sessionId;
  final String title;

  @override
  State<AskWilcoScreen> createState() => _AskWilcoScreenState();
}

class _AskWilcoScreenState extends State<AskWilcoScreen> {
  final _controller = TextEditingController();
  final _scrollCtrl = ScrollController();

  final ValueNotifier<bool> _isConnected = ValueNotifier(true);
  late stt.SpeechToText _speech;
  bool _isListening = false;
  Timer? _speechTimeoutTimer;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();

    _controller.addListener(() {
      setState(() {});
    });
    AnalyticsService.instance.logVisibleScreen(FirebaseEvents.askChatScreen);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollCtrl.dispose();
    _speech.stop();
    super.dispose();
  }

  Future<void> _startListening(BuildContext context) async {
    if (_isListening) return;

    var micStatus = await Permission.microphone.status;
    if (!micStatus.isGranted) {
      micStatus = await Permission.microphone.request();
    }
    if (!micStatus.isGranted) {
      debugPrint("Microphone permission not granted");
      return;
    }

    bool available = await _speech.initialize(
      onStatus: (status) async {
        debugPrint("Speech status: $status");
        if (status == "done" || status == "notListening") {
          await _stopListening(context);
        }
      },
      onError: (error) => debugPrint("Speech error: $error"),
    );

    if (!available) return;

    setState(() => _isListening = true);

    _speech.listen(
      onResult: (result) {
        setState(() {
          _controller.text = result.recognizedWords;
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
        });

        _speechTimeoutTimer?.cancel();
        _speechTimeoutTimer = Timer(const Duration(seconds: 5), () async {
          if (_isListening) {
            debugPrint("Auto-stopping mic after inactivity");
            await _stopListening(context);
          }
        });
      },
    );

    _speechTimeoutTimer?.cancel();
    _speechTimeoutTimer = Timer(const Duration(seconds: 60), () async {
      if (_isListening) {
        debugPrint("Force stop after 60s max listening");
        await _stopListening(context);
      }
    });
  }

  Future<void> _stopListening(BuildContext context) async {
    if (!_isListening) return;

    _speechTimeoutTimer?.cancel();
    _speechTimeoutTimer = null;

    await _speech.stop();
    setState(() => _isListening = false);
  }

  void _listenToInternet(ChatCubit cubit) {
    cubit.internetStream.listen((status) {
      _isConnected.value = status;
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollCtrl.hasClients) return;
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = ChatCubit(
          accessToken: widget.accessToken,
          isNewSession: (widget.accessToken.isEmpty),
          existingSessionId: widget.sessionId,
        );
        _listenToInternet(cubit);
        return cubit;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: 'AskWILCO',
          leftButton: widget.isComeFromTab == true
              ? const SizedBox()
              : IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Color(0xFF32377D),
                  ),
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
          rightButton: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChatHistoryScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F7),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      CommonUi.setSvgImage(AssetsPath.chatHistoryicon),
                      height: 18,
                      width: 18,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF3F3D56),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'History',
                      style: TextStyle(
                        color: Color(0xFF3F3D56),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: BlocListener<ChatCubit, List<Map<String, String>>>(
          listener: (_, _) => _scrollToBottom(),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1500),
              child: Column(
                children: [
                  Expanded(
                    child: BlocBuilder<ChatCubit, List<Map<String, String>>>(
                      builder: (context, messages) {
                        final screenWidth = MediaQuery.of(context).size.width;
                        return ListView.builder(
                          controller: _scrollCtrl,
                          padding: const EdgeInsets.all(16),
                          itemCount: messages.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Column(
                                children: [
                                  const SizedBox(height: 18),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 12,
                                      ),
                                      child: Container(
                                        width:
                                            screenWidth *
                                            (kIsWeb ?  0.06 : 0.25),
                                        height:
                                            screenWidth *
                                            (kIsWeb ?  0.06 : 0.25),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.transparent,
                                        ),
                                        child: ClipOval(
                                          child: SvgPicture.asset(
                                            CommonUi.setSvgImage(
                                              AssetsPath.ChatIcon,
                                            ),
                                            width:
                                                screenWidth *
                                                (kIsWeb ? 0.025 : 0.25),
                                            height:
                                                screenWidth *
                                                (kIsWeb ?  0.025 : 0.025),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                            final message = messages[index - 1];

                            if (message['type'] == 'analyzing') {
                              return const _AnalyzingIndicator();
                            }

                            final isUser = message['type'] == 'user';
                            return Align(
                              alignment: isUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.fromLTRB(
                                  isUser ? 0 : 24,
                                  isUser ? 8 : 7,
                                  isUser ? 10 : 0,
                                  isUser ? 8 : 7,
                                ),
                                padding: EdgeInsets.all(isUser ? 12 : 7),
                                constraints: BoxConstraints(
                                  maxWidth: screenWidth * 0.8,
                                ),
                                decoration: BoxDecoration(
                                  color: isUser
                                      ? const Color(0xFF3F3D56)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  message['text'] ?? '',
                                  style: TextStyle(
                                    color: isUser ? Colors.white : Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Builder(builder: (innerCtx) => _chatInput(innerCtx)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _chatInput(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(height: 1, thickness: 1, color: Color(0xFFE0E0E0)),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 16, 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: BlocListener<ChatCubit, List<Map<String, String>>>(
                    listener: (ctx, messages) {
                      if (messages.isNotEmpty &&
                          messages.last['type'] == 'user') {
                        _controller.clear();
                        _scrollToBottom();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 13,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F8F9),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: _controller,
                        minLines: 1,
                        maxLines: 5,
                        style: const TextStyle(fontSize: 14),
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          isCollapsed: true,
                          hintText: 'Type your message here…',
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                BlocBuilder<ChatCubit, List<Map<String, String>>>(
                  builder: (context, state) {
                    final isAnalyzing = state.any(
                      (msg) => msg['type'] == 'analyzing',
                    );
                    return ValueListenableBuilder<bool>(
                      valueListenable: _isConnected,
                      builder: (_, isConnected, __) {
                        final hasText = _controller.text.trim().isNotEmpty;
                        final showSendButton = hasText || isAnalyzing;

                        return GestureDetector(
                          onLongPressStart: !showSendButton && isConnected
                              ? (_) => _startListening(context)
                              : null,
                          onLongPressEnd: !showSendButton && isConnected
                              ? (_) => _stopListening(context)
                              : null,
                          onTap: showSendButton && isConnected
                              ? () {
                                  if (isAnalyzing) return;
                                  final text = _controller.text.trim();
                                  if (text.isNotEmpty) {
                                    context.read<ChatCubit>().sendMessage(text);
                                    _controller.clear();
                                    _scrollToBottom();
                                    AnalyticsService.instance.buttonPressed(FirebaseEvents.chatSendButton,FirebaseEvents.askChatScreen);
                                  }
                                }
                              : null,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 44,
                            width: 44,
                            decoration: BoxDecoration(
                              color: isConnected
                                  ? const Color(0xFF3F3D56)
                                  : const Color(0xFF9E9E9E),
                              shape: BoxShape.circle,
                              boxShadow: _isListening
                                  ? [
                                      BoxShadow(
                                        color: Colors.purple.withOpacity(0.4),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Center(
                              child: showSendButton
                                  ? (isAnalyzing
                                        ? const Icon(
                                            Icons.stop,
                                            color: Colors.white,
                                            size: 22,
                                          )
                                        : SvgPicture.asset(
                                            CommonUi.setSvgImage(
                                              AssetsPath.SendIcon,
                                            ),
                                          ))
                                  : Icon(
                                      _isListening
                                          ? Icons.mic_none_rounded
                                          : Icons.mic_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AnalyzingIndicator extends StatefulWidget {
  const _AnalyzingIndicator();

  @override
  State<_AnalyzingIndicator> createState() => _AnalyzingIndicatorState();
}

class _AnalyzingIndicatorState extends State<_AnalyzingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    duration: const Duration(milliseconds: 900),
    vsync: this,
  )..repeat();
  late final Animation<int> _dots = StepTween(begin: 1, end: 3).animate(_ctrl);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _dots,
      builder: (_, _) {
        final dots = '.' * _dots.value;
        return Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.fromLTRB(24, 6, 12, 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Analyzing$dots',
              style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
            ),
          ),
        );
      },
    );
  }
}
