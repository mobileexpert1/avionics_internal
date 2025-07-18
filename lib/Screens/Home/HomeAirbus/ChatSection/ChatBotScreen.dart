import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../Constants/constantImages.dart';
import '../../../../bloc/ChatBot/ChatCubit.dart';
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

  @override
  void dispose() {
    _controller.dispose();
    _scrollCtrl.dispose();
    super.dispose();
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
    final screenWidth = MediaQuery.of(context).size.width;

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
                  // onPressed: () => Navigator.pop(context),
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
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<ChatCubit, List<Map<String, String>>>(
                  builder: (context, messages) {
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
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Container(
                                    width: screenWidth * 0.25,
                                    height: screenWidth * 0.25,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.transparent,
                                    ),
                                    child: ClipOval(
                                      child: SvgPicture.asset(
                                        CommonUi.setSvgImage(
                                          AssetsPath.ChatIcon,
                                        ),
                                        width: screenWidth * 0.25,
                                        height: screenWidth * 0.25,
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
    );
  }

  Widget _chatInput(BuildContext context) {
    const double iconSize = 22;

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
                // Text field
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
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
                const SizedBox(width: 10),

                // Reactive send button
                ValueListenableBuilder<bool>(
                  valueListenable: _isConnected,
                  builder: (_, isConnected, __) {
                    return InkWell(
                      onTap: isConnected
                          ? () {
                        final text = _controller.text.trim();
                        if (text.isNotEmpty) {
                          context.read<ChatCubit>().sendMessage(text);
                          _controller.clear();
                          _scrollToBottom();
                        }
                      }
                          : null,
                      borderRadius: BorderRadius.circular(22),
                      child: Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          color: isConnected
                              ? const Color(0xFF3F3D56) // enabled color
                              : const Color(0xFF9E9E9E), // slightly lighter for disabled
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(0),
                        child: SvgPicture.asset(
                          CommonUi.setSvgImage(AssetsPath.SendIcon),
                          height: iconSize,
                          width: iconSize,
                          // keep icon same in both states
                        ),
                      ),
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

/* ───────────────────────── Typing indicator ───────────────────────── */
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
            // ⬅️ More space on the left
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
