import 'package:avionics_internal/Constants/AppColors.dart';
import 'package:avionics_internal/Constants/ConstantStrings.dart';
import 'package:avionics_internal/CustomFiles/CustomAppBar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Constants/ApiClass/ApiErrorModel.dart';
import '../../Constants/ApiClass/FirebaseAnalytics/analytics_service.dart';
import '../../Constants/ApiClass/FirebaseAnalytics/event_names.dart';
import '../../Constants/ApiClass/shared_prefs_helper.dart';
import '../../Constants/constantImages.dart';
import '../../CustomFiles/Custom_SnackBar.dart';
import '../../Helpers/AppTextStyles/AppTextStyles.dart';
import '../../bloc/home/chatSection/ChatHistory/chat_history_cubit.dart';
import '../../bloc/home/chatSection/ChatHistory/chat_history_state.dart';
import 'ChatBotScreen.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  final _primaryColor = AppColors.primaryDark;
  final _deleteColor = AppColors.blackBoxColorForGame;
  final BorderRadius _borderRadius = BorderRadius.circular(10);

  bool _isDialogOpen = false;

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

  void _hideDialogIfNeeded() {
    if (_isDialogOpen && mounted) {
      Navigator.of(context, rootNavigator: true).pop();
      _isDialogOpen = false;
    }
  }

  Future<void> _openChat(dynamic item) async {
    if (item.id == null) return;

    _hideDialogIfNeeded();

    final token = await SharedPrefsHelper.getUserAccessToken() ?? "";

    if (!mounted) return;

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
          sessionId: item.id!,
          title: item.title,
        ),
      ),
      (route) => route.settings.name == 'HomeScreen' || route.isFirst,
    );
  }

  Future<void> _renameChat({
    required String sessionId,
    required String currentTitle,
  }) async {
    final controller = TextEditingController(text: currentTitle);
    _isDialogOpen = true;
    final updatedTitle = await showDialog<String>(
      context: context,
      barrierDismissible: true,
      useRootNavigator: false,
      builder: (dialogContext) => PopScope(
        canPop: true,
        onPopInvokedWithResult: (_, _) {
          _isDialogOpen = false;
        },
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(dialogContext).size.width * (kIsWeb ? 0.3 : 1),
            child: CustomDialog(
              title: 'Rename Chat',
              content: TextField(
                controller: controller,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: _primaryColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: _primaryColor, width: 1),
                  ),
                ),
              ),
              positiveButtonText: 'Save',
              onPositiveTap: () {
                _isDialogOpen = false;
                Navigator.pop(dialogContext, controller.text.trim());
              },
            ),
          ),
        ),
      ),
    );

    _isDialogOpen = false;

    if (updatedTitle == null ||
        updatedTitle.isEmpty ||
        updatedTitle == currentTitle) {
      return;
    }

    await context.read<ChatHistoryCubit>().updateSessionTitle(
      context,
      sessionId: sessionId,
      newTitle: updatedTitle,
    );

    if (!mounted) return;

    AppSnackBar.custom(
      context,
      message: "Title Updated Successfully",
      svgAsset: "",
    );
  }

  Future<void> _deleteChat(String sessionId) async {
    _isDialogOpen = true;

    final shouldDelete = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      useRootNavigator: false,
      builder: (dialogContext) => PopScope(
        canPop: true,
        onPopInvokedWithResult: (_, _) {
          _isDialogOpen = false;
        },
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(dialogContext).size.width * (kIsWeb ? 0.3 : 1),
            child: CustomDialog(
              title: 'Delete chat',
              description: 'Are you sure you want to delete this chat?',
              positiveButtonText: 'Delete',
              positiveColor: _deleteColor,
              onPositiveTap: () {
                _isDialogOpen = false;
                Navigator.pop(dialogContext, true);
              },
            ),
          ),
        ),
      ),
    );
    _isDialogOpen = false;
    if (shouldDelete != true) return;
    await context.read<ChatHistoryCubit>().deleteSession(context, sessionId);
    if (!mounted) return;
    AppSnackBar.custom(context, message: "Delete Successfully", svgAsset: "");
  }

  PopupMenuButton<String> _popupMenu(dynamic item) {
    return PopupMenuButton<String>(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 3,
      offset: const Offset(-25, 5),
      shape: RoundedRectangleBorder(borderRadius: _borderRadius),

      onSelected: (value) async {
        if (item.id == null) return;

        switch (value) {
          case 'rename':
            AnalyticsService.instance.buttonPressed(
              FirebaseEvents.chatHistoryEditButton,
              FirebaseEvents.chatHistoryScreen,
            );

            await _renameChat(sessionId: item.id!, currentTitle: item.title);

            break;

          case 'delete':
            AnalyticsService.instance.buttonPressed(
              FirebaseEvents.chatHistoryDeleteButton,
              FirebaseEvents.chatHistoryScreen,
            );

            await _deleteChat(item.id!);

            break;
        }
      },

      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'rename',

          child: _PopupMenuTile(
            title: 'Rename',
            iconName: AssetsPath.editForChat,
          ),
        ),

        PopupMenuItem(
          value: 'delete',

          child: _PopupMenuTile(
            title: 'Delete',
            iconName: AssetsPath.deleteForChat,
            textColor: _deleteColor,
          ),
        ),
      ],

      child: Padding(
        padding: const EdgeInsets.all(5),

        child: Icon(Icons.more_vert, color: _primaryColor),
      ),
    );
  }

  @override
  void dispose() {
    _hideDialogIfNeeded();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (_, _) {
        _hideDialogIfNeeded();
      },

      child: Scaffold(
        backgroundColor: Colors.white,

        appBar: CustomAppBar(
          title: ConstantStrings.chatHistoryTitle,
          centerTitle: false,

          leftButton: IconButton(
            onPressed: () {
              _hideDialogIfNeeded();
              Navigator.pop(context);
            },

            icon: SvgPicture.asset(
              CommonUi.setSvgImage(AssetsPath.backArrowButton),
            ),
          ),
        ),

        body: BlocBuilder<ChatHistoryCubit, ChatHistoryState>(
          builder: (context, state) {
            if (state.status == CommonApiStatus.submitting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.chatList.isEmpty) {
              return const Center(child: Text("No chat sessions yet."));
            }

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1500),

                child: ListView.separated(
                  padding: const EdgeInsets.all(14),

                  itemCount: state.chatList.length,

                  separatorBuilder: (_, _) => const SizedBox(height: 16),

                  itemBuilder: (context, index) {
                    final item = state.chatList[index];

                    return InkWell(
                      borderRadius: _borderRadius,

                      onTap: () => _openChat(item),

                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: _borderRadius,

                          border: Border.all(color: Colors.grey.shade300),

                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),

                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    item.title,

                                    style: AppTextStyles.semiBold(16).copyWith(
                                      height: 1.0,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  Text(
                                    item.createdAt,

                                    style: AppTextStyles.regular(14).copyWith(
                                      height: 1.0,
                                      color: AppColors.grayMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            _popupMenu(item),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PopupMenuTile extends StatelessWidget {
  final String title;
  final String iconName;
  final Color? textColor;

  const _PopupMenuTile({
    required this.title,
    required this.iconName,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(CommonUi.setSvgImage(iconName), fit: BoxFit.cover),
        const SizedBox(width: 10),
        Text(title, style: TextStyle(color: textColor)),
      ],
    );
  }
}

class CustomDialog extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? content;
  final String positiveButtonText;
  final VoidCallback onPositiveTap;
  final Color positiveColor;

  const CustomDialog({
    required this.title,
    this.description,
    this.content,
    required this.positiveButtonText,
    required this.onPositiveTap,
    this.positiveColor = _primaryColor,
  });

  static const _primaryColor = Color(0xff1B174D);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: AppTextStyles.bold(
                22,
              ).copyWith(height: 1.0, color: AppColors.primaryDark),
            ),

            if (description != null) ...[
              const SizedBox(height: 14),
              Text(
                description!,
                textAlign: TextAlign.center,
                style: AppTextStyles.regular(
                  18,
                ).copyWith(height: 1.0, color: AppColors.grayMedium),
              ),
            ],

            if (content != null) ...[const SizedBox(height: 20), content!],

            const SizedBox(height: 17),

            Row(
              children: [
                Expanded(
                  child: _DialogButton(
                    title: 'Cancel',
                    color: AppColors.dividerLineColour,
                    textColor: Colors.black,
                    onTap: () => Navigator.pop(context),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _DialogButton(
                    title: positiveButtonText,
                    color: positiveButtonText == "Save"
                        ? AppColors.primaryDark
                        : AppColors.blackBoxColorForGame,
                    textColor: Colors.white,
                    onTap: onPositiveTap,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  final String title;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const _DialogButton({
    required this.title,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,

      child: Container(
        height: 46,
        alignment: Alignment.center,

        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),

        child: Text(
          title,
          style: AppTextStyles.regular(
            18,
          ).copyWith(height: 1.0, color: textColor),
        ),
      ),
    );
  }
}
