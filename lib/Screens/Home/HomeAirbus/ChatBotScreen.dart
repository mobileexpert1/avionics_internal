// lib/screens/chat/ask_wilco_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../Constants/constantImages.dart';
import '../../../bloc/ChatBot/ChatCubit.dart';

class AskWilcoScreen extends StatefulWidget {
  const AskWilcoScreen({
    super.key,
    required this.accessToken,        // <─ pass it when you navigate here
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
    if (!_scrollCtrl.hasClients) return;
    _scrollCtrl.animateTo(
      _scrollCtrl.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (_) => ChatCubit(accessToken: widget.accessToken),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar:AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xFF32377D),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: const Text(
            'Ask WILCO',
            style: TextStyle(
              color: Color(0xFF3F3D56),
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () {
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
                      Text(
                        'History',
                        style: const TextStyle(
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
        ) ,// ─────────────── Chat UI ───────────────
        body: BlocListener<ChatCubit, List<Map<String, String>>>(
          listener: (_, __) => _scrollToBottom(),
          child: Column(
            children: [
              // MESSAGE LIST
              Expanded(
                child: BlocBuilder<ChatCubit, List<Map<String, String>>>(
                  builder: (context, messages) {
                    return ListView.builder(
                      controller: _scrollCtrl,
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length + 1,
                      itemBuilder: (context, index) {
                        // avatar header
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

                        // quick-reply buttons
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

                        final isUser = message['type'] == 'user';
                        return Align(
                          alignment: isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.all(12),
                            constraints: BoxConstraints(
                              maxWidth: screenWidth * 0.8,
                            ),
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

              // INPUT BAR
              // _chatInput(context),
              Builder(
                builder: (innerCtx) => _chatInput(innerCtx),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ───────────────── Widgets ─────────────────

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

  Widget _chatInput(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    child: Row(
      children: [
        SvgPicture.asset(
          CommonUi.setSvgImage(AssetsPath.AttachFileIcon),
          height: 24,
          width: 24,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Type your message here...',
              hintStyle: TextStyle(color: Colors.grey.shade500),
              filled: true,
              fillColor: const Color(0xFFF5F8F9),
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        IconButton(
          icon: SvgPicture.asset(
            CommonUi.setSvgImage(AssetsPath.SendIcon),
            height: 40,
            width: 24,
          ),
          onPressed: () {
            final text = _controller.text.trim();
            if (text.isNotEmpty) {
              context.read<ChatCubit>().sendMessage(text);
              _controller.clear();
            }
          },
        ),
      ],
    ),
  );
}
