import 'dart:async';

import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../Constants/ApiClass/alertHelperForSubsPopup.dart';
import '../../Constants/AppColors.dart';
import '../../Constants/constantImages.dart';
import '../../Helpers/AppNavigator.dart';
import '../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../Helpers/ChatAnalyzingIndicator/ChatAnalyzingIndicator.dart';
import '../../Helpers/FormattedText/FormattedText.dart';
import '../../bloc/home/chatSection/ChatBot/ChatCubit.dart';
import '../../bloc/home/chatSection/ChatBot/chat_implementation.dart';
import '../Onboarding/Login/LoginScreen.dart';
import '../Onboarding/Subscription/SubscriptionPlanDetailScreen.dart';
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

  Timer? _inactivityTimer;
  Timer? _maxListeningTimer;

  bool isReceivedTokenFullWarning = false;

  final _selectableFocusNode = FocusNode();

  StreamSubscription<bool>? _internetSub;

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
    _isConnected.dispose();
    _internetSub?.cancel();
    _inactivityTimer?.cancel();
    _maxListeningTimer?.cancel();
    _controller.dispose();
    _scrollCtrl.dispose();
    _speech.stop();
    _selectableFocusNode.dispose();
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

    if (!mounted) return;

    if (!available) return;

    setState(() => _isListening = true);

    _speech.listen(
      onResult: (result) {
        if (!_isListening) return;

        setState(() {
          _controller.text = result.recognizedWords;

          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
        });

        _inactivityTimer?.cancel();

        _inactivityTimer = Timer(const Duration(seconds: 5), () async {
          if (_isListening) {
            debugPrint("Auto-stopping mic after inactivity");
            await _stopListening(context);
          }
        });
      },
    );

    _maxListeningTimer?.cancel();

    _maxListeningTimer = Timer(const Duration(seconds: 60), () async {
      if (_isListening) {
        await _stopListening(context);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mic automatically stopped.')),
          );
        }
      }
    });
  }

  Future<void> _stopListening(BuildContext context) async {
    if (!_isListening) return;
    _inactivityTimer?.cancel();
    _maxListeningTimer?.cancel();

    _inactivityTimer = null;
    _inactivityTimer = null;
    if (mounted) setState(() => _isListening = false);
    await _speech.stop();
  }

  void _listenToInternet(ChatCubit cubit) {
    _internetSub = cubit.internetStream.listen((status) {
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
          isNewSession: widget.accessToken.isEmpty,
          existingSessionId: widget.sessionId,
          context: context
        );

        _listenToInternet(cubit);

        cubit.onResponse = (status) {
          switch (status) {
            case ChatResponseStatus.tokenLimitExpired:
              setState(() => isReceivedTokenFullWarning = true);

              AlertHelperForSubsPopup.showSubscriptionEndAlert(
                context: context,
                title: "Token limit exhausted",
                message:
                    "Your token limit has been exhausted. Please purchase a subscription.",
                navigateTo: SubscriptionPlanDetailScreen(
                  isComeFromSignup: false,
                ),
              );

              break;

            case ChatResponseStatus.creditLimitExpired:
              AlertHelperForSubsPopup.showSubscriptionEndAlert(
                context: context,
                title: "Credit limit exhausted",
                message:
                    "Your credit limit has been exhausted. Please purchase a subscription.",
                navigateTo: SubscriptionPlanDetailScreen(
                  isComeFromSignup: true,
                ),
              );

              break;

            case ChatResponseStatus.accessTokenExpired:
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Session expired. Please login again.'),
                ),
              );

              Future.delayed(const Duration(seconds: 1), () {
                AppNavigator.pushAndRemoveUntil(
                  context,
                  LoginScreen(),
                  disableSwipeBack: true,
                );
              });

              break;

            default:
              break;
          }
        };

        return cubit;
      },

      child: Scaffold(
        backgroundColor: Colors.white,

        appBar: CustomAppBar(
          title: 'WILCO',

          leftButton: widget.isComeFromTab
              ? const SizedBox()
              : IconButton(
                  icon: SvgPicture.asset(
                    CommonUi.setSvgImage(AssetsPath.backArrowButton),
                    fit: BoxFit.cover,
                  ),
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),

          rightButton: InkWell(
            borderRadius: BorderRadius.circular(30),

            onTap: () {
              AppNavigator.push(
                context,
                ChatHistoryScreen(),
                disableSwipeBack: true,
              );
            },

            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),

              child: Row(
                children: [
                  SvgPicture.asset(
                    CommonUi.setSvgImage(AssetsPath.chatHistoryIcon),
                    height: 18,
                    width: 18,
                  ),

                  const SizedBox(width: 6),

                  const Text(
                    'History',
                    style: TextStyle(
                      color: Color(0xFF1A1A1A),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: kIsWeb ? 900 : double.infinity,
            ),
            child: BlocListener<ChatCubit, List<Map<String, String>>>(
              listener: (_, _) => _scrollToBottom(),
              child: Column(
                children: [
                  Expanded(
                    child: BlocBuilder<ChatCubit, List<Map<String, String>>>(
                      builder: (context, messages) {
                        return SelectableRegion(
                          focusNode: _selectableFocusNode,

                          selectionControls: MaterialTextSelectionControls(),

                          child: ListView.builder(
                            controller: _scrollCtrl,

                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),

                            itemCount: messages.length + 1,

                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return _buildTopSection();
                              }

                              final message = messages[index - 1];

                              if (message['type'] == 'analyzing') {
                                return const Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: ChatAnalyzingIndicator(),
                                );
                              }

                              final isUser = message['type'] == 'user';

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),

                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  mainAxisAlignment: isUser
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,

                                  children: [
                                    if (!isUser)
                                      _buildBotAvatarOrUser(
                                        true,
                                        message['text'] ?? "",
                                      ),

                                    Flexible(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 10,
                                        ),

                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context).size.width ,
                                        ),

                                        decoration: isUser
                                            ? BoxDecoration(
                                                color: AppColors.primaryDark,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomLeft: Radius.circular(
                                                    10,
                                                  ),
                                                  bottomRight: Radius.circular(
                                                    10,
                                                  ),
                                                ),

                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withValues(
                                                          alpha: 0.04,
                                                        ),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              )
                                            : null,

                                        child: isUser
                                            ? SelectableText(
                                                // user message as-is rehne do
                                                message['text'] ?? '',
                                                style: AppTextStyles.regular(15)
                                                    .copyWith(
                                                      height: 1.5,
                                                      color: Colors.white,
                                                    ),
                                              )
                                            : FormattedText(
                                                text: message['text'] ?? '',
                                                fontSize: 15,
                                                normalColor: Colors.black87,
                                                boldColor: Colors.black,
                                                lineHeight: 1.5,
                                              ),

                                        // SelectableText(
                                        //   message['text'] ?? '',
                                        //   style: AppTextStyles.regular(15).copyWith(
                                        //     height: 1.5,
                                        //     color: isUser
                                        //         ? Colors.white
                                        //         : Colors.black87,
                                        //   ),
                                        // ),
                                      ),
                                    ),

                                    if (isUser)
                                      _buildBotAvatarOrUser(
                                        false,
                                        message['text'] ?? "",
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  _chatInput(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),

      child: Column(
        children: [
          SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.wilcoChatLogo),
            height: kIsWeb ? 180 : 140,
            width: kIsWeb ? 300 : null,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 10),
          Text(
            "Hey there!",
            style: AppTextStyles.bold(
              30,
            ).copyWith(height: 1.0, color: AppColors.black),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildBotAvatarOrUser(bool isForBoat, String responseMessage) {
    final isUnexpectedError = responseMessage.contains("Unexpected");
    return Padding(
      padding: EdgeInsets.only(left: isForBoat ? 0 : 8, bottom: 2),
      child: SvgPicture.asset(
        CommonUi.setSvgImage(
          isUnexpectedError
              ? AssetsPath.wilcoAttention
              : (isForBoat
                    ? AssetsPath.wilcoChatBoat
                    : AssetsPath.wilcoChatUser),
        ),
        height: 40,
      ),
    );
  }

  Widget _chatInput(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: AppColors.primaryDark),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),

          child: Row(
            children: [
              Expanded(
                child: BlocListener<ChatCubit, List<Map<String, String>>>(
                  listener: (ctx, messages) {
                    if (messages.isNotEmpty &&
                        messages.last['type'] == 'user') {
                      _controller.clear();
                      //_scrollToBottom(); New
                      _stopListening(context);
                    }
                  },

                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 5,
                    style: AppTextStyles.regular(
                      16,
                    ).copyWith(height: 1.0, color: AppColors.black),

                    textInputAction: TextInputAction.done,

                    onSubmitted: (val) {
                      if (!kIsWeb) return;

                      final text = val.trim();

                      if (text.isEmpty) return;

                      final cubit = context.read<ChatCubit>();

                      final isAnalyzing = cubit.state.any(
                        (msg) => msg['type'] == 'analyzing',
                      );

                      if (!isAnalyzing) {
                        cubit.sendMessage(
                          text,
                          context,
                          isReceivedTokenFullWarning,
                        );

                        _controller.clear();

                        _stopListening(context);

                        _scrollToBottom();
                      }
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Type your message here...',
                      hintStyle: AppTextStyles.regular(16).copyWith(
                        height: 1.0,
                        color: AppColors.greyFlightDetailText,
                      ),
                    ),
                  ),
                ),
              ),

              BlocBuilder<ChatCubit, List<Map<String, String>>>(
                builder: (context, state) {
                  final isAnalyzing = state.any(
                    (msg) => msg['type'] == 'analyzing',
                  );

                  return ValueListenableBuilder<bool>(
                    valueListenable: _isConnected,

                    builder: (_, isConnected, _) {
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
                                if (isAnalyzing) {
                                  context.read<ChatCubit>().stopResponse();

                                  return;
                                }

                                final text = _controller.text.trim();

                                if (text.isNotEmpty) {
                                  context.read<ChatCubit>().sendMessage(
                                    text,
                                    context,
                                    isReceivedTokenFullWarning,
                                  );

                                  _controller.clear();

                                  _scrollToBottom();

                                  _stopListening(context);

                                  AnalyticsService.instance.buttonPressed(
                                    FirebaseEvents.chatSendButton,
                                    FirebaseEvents.askChatScreen,
                                  );
                                }
                              }
                            : null,

                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isListening
                                ? const Color(0xFFF3F4F6)
                                : Colors
                                      .transparent, // ← null ki jagah transparent
                          ),

                          child: Center(
                            child: showSendButton
                                ? (isAnalyzing
                                      ? const Icon(
                                          Icons.stop,
                                          size: 40,
                                          //color: Color(0xFF2D235A),
                                        )
                                      : SvgPicture.asset(
                                          CommonUi.setSvgImage(
                                            AssetsPath.chatSendIcon,
                                          ),
                                        ))
                                : Icon(
                                    _isListening
                                        ? Icons.mic_rounded
                                        : Icons.mic_none_rounded,
                                    color: AppColors.primaryDark,
                                    size: 40,
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
    );
  }
}
