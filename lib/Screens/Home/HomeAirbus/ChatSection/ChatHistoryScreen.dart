import 'package:avionics_internal/Constants/ConstantStrings.dart';
import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:avionics_internal/bloc/ChatHistory/chat_history_cubit.dart';
import 'package:avionics_internal/bloc/ChatHistory/chat_history_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../../Constants/ApiClass/shared_prefs_helper.dart';
import 'ChatBotScreen.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({Key? key}) : super(key: key);

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ChatHistoryCubit>(context).fetchChatHistory(context);
  }

  // class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  // @override
  // void initState() {
  // super.initState();
  // WidgetsBinding.instance.addPostFrameCallback((_) {
  // BlocProvider.of<ChatHistoryCubit>(context).loadChatHistory(context, fromLocal: true);
  // });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: ConstantStrings.chatHistoryTitle,
        leftButton: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<ChatHistoryCubit, ChatHistoryState>(
        builder: (context, state) {
          if (state.status == CommonApiStatus.submitting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.chatList.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("No chat sessions yet.")],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(15),
            children: state.chatList.map((item) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text(
                    item.title ?? '',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),

                  trailing: const Icon(Icons.arrow_forward_ios, size: 15),
                  onTap: () async {
                    final token = await SharedPrefsHelper.getUserAccessToken() ?? '';
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AskWilcoScreen(
                          accessToken: token,
                          isComeFromTab: false,
                          sessionId: item.id,
                          title: item.title,
                        ),
                      ),
                    );
                  },

                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
