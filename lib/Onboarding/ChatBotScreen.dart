import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Constants/constantImages.dart';
import '../bloc/ChatBot/ChatCubit.dart';

class AskWilcoScreen extends StatelessWidget {
  AskWilcoScreen({super.key});
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (_) => ChatCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: const Text(
            "Ask WILCO",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatCubit, List<Map<String, String>>>(
                builder: (context, messages) {
                  return ListView.builder(
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
                              _optionButton("Take a Quiz"),
                              _optionButton("Ask a Question"),
                              _optionButton("Learn Aviation"),
                            ],
                          ),
                        );
                      }

                      final isUser = message['type'] == 'user';
                      return Align(
                        alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
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
                            message['text']!,
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
            _chatInput(context),
          ],
        ),
      ),
    );
  }

  Widget _optionButton(String text) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.black),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onPressed: () {},
      child: Text(
        text,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _chatInput(BuildContext context) {
    return Padding(
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
                hintText: "Type your message here...",
                hintStyle: TextStyle(color: Colors.grey.shade500),
                filled: true,
                fillColor: const Color(0xF5F8F9FF),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
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
}
