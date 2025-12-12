import 'package:avionics_internal/Constants/ConstantStrings.dart';
import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../Constants/ApiClass/ApiErrorModel.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../../../CustomFiles/Custom_SnackBar.dart';
import '../../../../bloc/home/chatSection/ChatHistory/chat_history_cubit.dart';
import '../../../../bloc/home/chatSection/ChatHistory/chat_history_state.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatHistoryCubit>().loadChatHistory(context: context);
    });
    AnalyticsService.instance.logVisibleScreen(
      FirebaseEvents.chatHistoryScreen,
    );
  }


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
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Slidable(
                  key: ValueKey(item.id),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (_) async {
                          AnalyticsService.instance.buttonPressed(
                            FirebaseEvents.chatHistoryEditButton,
                            FirebaseEvents.chatHistoryScreen,
                          );
                          final updatedTitle = await showDialog<String>(
                            context: context,
                            builder: (context) {
                              final TextEditingController controller =
                              TextEditingController(text: item.title);

                              return AlertDialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: const Text(
                                  "Edit Title",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                content: TextField(
                                  controller: controller,
                                  decoration: const InputDecoration(
                                    hintText: "Enter title",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Cancel"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context, controller.text.trim());
                                    },
                                    child: const Text("Update"),
                                  ),
                                ],
                              );
                            },
                          );

                          if (updatedTitle != null && updatedTitle.isNotEmpty) {
                            final cubit = context.read<ChatHistoryCubit>();
                            await cubit.updateSessionTitle(
                              context,
                              sessionId: item.id,
                              newTitle: updatedTitle,
                            );
                            AppSnackBar.custom(
                              context,
                              message: "Title Updated Successfully",
                              svgAsset: "",
                            );
                          }
                        },
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        icon: Icons.edit_note,
                        label: 'Edit',
                      ),

                      SlidableAction(
                        onPressed: (_) {
                          AnalyticsService.instance.buttonPressed(
                            FirebaseEvents.chatHistoryDeleteButton,
                            FirebaseEvents.chatHistoryScreen,
                          );
                          final chatId = item.id;
                          context.read<ChatHistoryCubit>().deleteSession(context, chatId);
                          AppSnackBar.custom(
                            context,
                            message: "Delete Successfully",
                            svgAsset: "",
                          );
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey, width: 0.2),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        item.title,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 15.0),
                      onTap: () async {
                        final token =
                            await SharedPrefsHelper.getUserAccessToken() ?? '';
                        AnalyticsService.instance.buttonPressed(
                          FirebaseEvents.openAskWilcoChatButton,
                          FirebaseEvents.chatHistoryScreen,
                        );
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AskWilcoScreen(
                              accessToken: token,
                              isComeFromTab: false,
                              sessionId: item.id,
                              title: item.title,
                            ),
                          ),
                              (route) =>
                          route.settings.name == 'HomeScreen' ||
                              route.isFirst,
                        );
                      },
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
