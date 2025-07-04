import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../Constants/constantImages.dart';
import '../../../bloc/ChatBot/ChatCubit.dart';

class AskWilcoScreen extends StatefulWidget {
  const AskWilcoScreen({
    super.key,
    required this.accessToken,
  });

  final String accessToken;

  @override
  State<AskWilcoScreen> createState() => _AskWilcoScreenState();
}

class _AskWilcoScreenState extends State<AskWilcoScreen> {
  final _controller = TextEditingController();
  final _scrollCtrl = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollCtrl.dispose();
    super.dispose();
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
      create: (_) => ChatCubit(accessToken: widget.accessToken),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: BlocListener<ChatCubit, List<Map<String, String>>>(
          listener: (_, __) => _scrollToBottom(),
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
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: CircleAvatar(
                              radius: screenWidth * 0.1,
                              backgroundColor: Colors.grey.shade200,
                              child: SvgPicture.asset(
                                CommonUi.setSvgImage(AssetsPath.ChatIcon),
                                height: screenWidth * 0.1,
                              ),
                            ),
                          );
                        }
                        final message = messages[index - 1];
                        if (message['type'] == 'button') {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                _optionButton('Take a Quiz'),
                                _optionButton('Ask a Question'),
                                _optionButton('Learn Aviation'),
                              ],
                            ),
                          );
                        }

                        if (message['type'] == 'analizing') {
                          return const _AnalizingIndicator();
                        }

                        final isUser = message['type'] == 'user';
                        return Align(
                          alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.all(12),
                            constraints: BoxConstraints(maxWidth: screenWidth * 0.8),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? const Color(0xFF3F3D56)
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              message['text'] ?? '',
                              style: TextStyle(
                                color: isUser ? Colors.white : Colors.black,
                                fontSize: 14,
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

  AppBar _buildAppBar() => AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF32377D)),
      onPressed: () => Navigator.pop(context),
    ),
    centerTitle: true,
    title: const Text(
      'Ask WILCO',
      style: TextStyle(color: Color(0xFF3F3D56), fontWeight: FontWeight.w600),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 12),
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {},
          child: Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
    ],
  );

  Widget _optionButton(String text) => OutlinedButton(
    style: OutlinedButton.styleFrom(
      side: const BorderSide(color: Colors.black),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    onPressed: () => context.read<ChatCubit>().sendMessage(text),
    child: Text(text, style: const TextStyle(color: Colors.black)),
  );

  Widget _chatInput(BuildContext context) {
    const double _iconSize = 26;
    const double _vPad = 10;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: _iconSize + _vPad * 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: _iconSize,
                height: _iconSize,
                child: SvgPicture.asset(
                  CommonUi.setSvgImage(AssetsPath.AttachFileIcon),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _controller,
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Type your message here…',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    filled: true,
                    fillColor: const Color(0xFFF5F8F9),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: _vPad),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints:
                BoxConstraints.tight(Size(_iconSize + 18, _iconSize + 18)),
                icon: SvgPicture.asset(
                  CommonUi.setSvgImage(AssetsPath.SendIcon),
                  height: _iconSize,
                  width: _iconSize,
                ),
                onPressed: () {
                  final text = _controller.text.trim();
                  if (text.isNotEmpty) {
                    context.read<ChatCubit>().sendMessage(text);
                    _controller.clear();
                    _scrollToBottom();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _AnalizingIndicator extends StatefulWidget {
  const _AnalizingIndicator();
  @override
  State<_AnalizingIndicator> createState() => _AnalizingIndicatorState();
}

class _AnalizingIndicatorState extends State<_AnalizingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    duration: const Duration(milliseconds: 900),
    vsync: this,
  )..repeat();
  late final Animation<int> _dots = StepTween(begin: 1, end: 3).animate(_ctrl);

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _dots,
      builder: (_, __) {
        final dots = '.' * _dots.value;
        return Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'analizing$dots',                 // ← updated text
              style:
              const TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
            ),
          ),
        );
      },
    );
  }
}



