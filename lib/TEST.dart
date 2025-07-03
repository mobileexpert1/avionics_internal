// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:just_audio/just_audio.dart';
// import 'package:english_app/business_logic/models/ai_writing_speaking_modles/ai_speaking_history_model.dart';
// import 'package:http/http.dart' as http;
// import 'package:permission_handler/permission_handler.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:web_socket_channel/web_socket_channel.dart';
// import '../../../../common/common_export.dart';
// import '../../../business_logic/http_service/api_service.dart';
// import '../../../utils/services/store_services.dart';
// import 'mic_visualizer_screen.dart';
//
// class AiSpeakingChatScreen extends StatefulWidget {
//   final int? conversationId;
//   const AiSpeakingChatScreen({super.key, this.conversationId});
//   @override
//   State<AiSpeakingChatScreen> createState() => _AiSpeakingChatScreenState();
// }
//
// class _AiSpeakingChatScreenState extends State<AiSpeakingChatScreen> {
//   late stt.SpeechToText _speech;
//   late WebSocketChannel _chatChannel;
//   late WebSocketChannel _elevenLabChannel;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   final ScrollController _scrollController = ScrollController();
//   List<Message> messages = [];
//   bool _isListening = false;
//   bool _isRunning = false;
//   bool isTyping = false;
//   @override
//   void initState() {
//     super.initState();
//     _speech = stt.SpeechToText();
//     fetchSpeakMessagesHistory();
//     _initChatWebSocket();
//   }
//
//   void _initChatWebSocket() async {
//     final int id = widget.conversationId ?? 0;
//     final token = await StoreServices.getAccessToken();
//     if (token == null || token.isEmpty) return;
//     final uri = Uri.parse(
//       'wss://englishai.csdevhub.com/api/v1/websocket/ws/speak/$id?token=$token',
//     );
//     _chatChannel = WebSocketChannel.connect(uri);
//     _chatChannel.stream.listen((data) async {
//       final decoded = json.decode(data);
//       setState(() => isTyping = false);
//       String text = decoded['content'] ?? '';
//       final msg = Message(
//         sender: 'ai',
//         content: capitalizeFirst(text),
//         msgId: 0,
//       );
//       setState(() => messages.add(msg));
//       _scrollToBottom();
//       if (decoded['audio'] != null) {
//         final audioBytes = base64Decode(decoded['audio']);
//         await _playTtsAudio(audioBytes);
//       }
//     });
//   }
//
//   Future<void> _playTtsAudio(Uint8List audioBytes) async {
//     try {
//       await _audioPlayer.stop();
//       final audioSource = AudioSource.uri(
//         Uri.dataFromBytes(audioBytes, mimeType: 'audio/mpeg'),
//       );
//       await _audioPlayer.setAudioSource(audioSource);
//       await _audioPlayer.play();
//       _audioPlayer.playerStateStream
//           .firstWhere(
//             (state) => state.processingState == ProcessingState.completed,
//           )
//           .then((_) async {
//             print("TTS finished");
//             await Future.delayed(const Duration(milliseconds: 400));
//             if (_isRunning) _startListening();
//           });
//     } catch (e) {
//       print('Error playing audio: $e');
//     }
//   }
//
//   Future<void> _startListening() async {
//     final micStatus = await Permission.microphone.request();
//     if (micStatus != PermissionStatus.granted) return;
//     try {
//       bool available = await _speech.initialize(
//         onStatus: (status) {
//           print('status: $status');
//           if (status == "done" || status == "notListening") {
//             _speech.stop();
//             setState(() => _isListening = false);
//           }
//         },
//         onError: (error) async {
//           print('Speech error: ${error.errorMsg}');
//           if (error.errorMsg.contains("error_no_match")) {
//             print("No speech detected. Restarting...");
//             await _speech.stop();
//             await _speech.cancel();
//             setState(() => _isListening = false);
//             await Future.delayed(const Duration(milliseconds: 500));
//             if (_isRunning) _startListening();
//           }
//         },
//       );
//       if (available) {
//         setState(() => _isListening = true);
//         bool visualizerShown = false;
//         _speech.listen(
//           pauseFor: const Duration(seconds: 4),
//           listenMode: stt.ListenMode.confirmation,
//           partialResults: true,
//           cancelOnError: true,
//           onResult: (val) async {
//             if (!visualizerShown && val.recognizedWords.trim().isNotEmpty) {
//               visualizerShown = true;
//               if (mounted) {
//                 await Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => MicVisualizer(onStartRecording: () {}),
//                   ),
//                 );
//               }
//             }
//             if (val.finalResult && val.recognizedWords.trim().isNotEmpty) {
//               _sendSpeakMessage(val.recognizedWords.trim());
//               await _speech.stop();
//               setState(() => _isListening = false);
//               if (Navigator.canPop(context)) Navigator.pop(context);
//             }
//           },
//         );
//       }
//     } catch (e) {
//       print('Failed to start speech: $e');
//       setState(() => _isListening = false);
//     }
//   }
//
//   void _sendSpeakMessage(String text) {
//     final userMessage = capitalizeFirst(text);
//     setState(() {
//       messages.add(Message(sender: 'user', content: userMessage, msgId: 0));
//       isTyping = true;
//     });
//     _scrollToBottom();
//     _chatChannel.sink.add(jsonEncode({'content': text}));
//   }
//
//   void _toggleConversation() {
//     if (_isRunning) {
//       setState(() => _isRunning = false);
//       _speech.stop();
//       _speech.cancel();
//     } else {
//       setState(() => _isRunning = true);
//       _startListening();
//     }
//   }
//
//   Future<void> fetchSpeakMessagesHistory() async {
//     try {
//       final AiSpeakingHistoryModel? chatList = await ApiService()
//           .fetchSpeakingMessageHistory(convId: widget.conversationId!);
//       if (chatList != null) {
//         setState(() => messages = chatList.message);
//         _scrollToBottom();
//       }
//     } catch (e) {
//       print('Error loading history: $e');
//     }
//   }
//
//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//       }
//     });
//   }
//
//   String capitalizeFirst(String text) {
//     if (text.isEmpty) return text;
//     return text[0].toUpperCase() + text.substring(1);
//   }
//
//   @override
//   void dispose() {
//     _speech.stop();
//     _speech.cancel();
//     _chatChannel.sink.close();
//     _audioPlayer.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorConstants.backGroundColor,
//       body: SafeArea(
//         child: Container(
//           width: double.infinity,
//           padding: const EdgeInsets.only(top: 30),
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage(ImageConstants.bgWelcome),
//               fit: BoxFit.fill,
//             ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     arrowBackButton(
//                       text: 'Back',
//                       onTap: () => NavigationService().goBack(),
//                     ),
//                     10.0.spaceY,
//                     Text(
//                       'AI Speaking',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 32,
//                         fontFamily: Fonts.poppinsMedium,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               40.0.spaceY,
//               Expanded(
//                 child: Container(
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.vertical(
//                       top: Radius.circular(30),
//                     ),
//                   ),
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Column(
//                     children: [
//                       20.0.spaceY,
//                       Expanded(
//                         child: ListView.builder(
//                           controller: _scrollController,
//                           itemCount: messages.length + (isTyping ? 1 : 0),
//                           itemBuilder: (context, index) {
//                             if (isTyping && index == messages.length) {
//                               return typingBubble();
//                             }
//                             final message = messages[index];
//                             final isMe = message.sender == 'user';
//                             return Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 vertical: 6.0,
//                               ),
//                               child: Align(
//                                 alignment: isMe
//                                     ? Alignment.centerRight
//                                     : Alignment.centerLeft,
//                                 child: Row(
//                                   mainAxisAlignment: isMe
//                                       ? MainAxisAlignment.end
//                                       : MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     if (!isMe)
//                                       Padding(
//                                         padding: const EdgeInsets.only(
//                                           right: 8.0,
//                                         ),
//                                         child: CircleAvatar(
//                                           radius: 16,
//                                           backgroundColor:
//                                               ColorConstants.blueColor,
//                                           backgroundImage: AssetImage(
//                                             ImageConstants.aiChat,
//                                           ),
//                                         ),
//                                       ),
//                                     Flexible(
//                                       child: Container(
//                                         decoration: BoxDecoration(
//                                           color: isMe
//                                               ? ColorConstants.blueColor
//                                               : ColorConstants.bgQuoteCard,
//                                           borderRadius: BorderRadius.only(
//                                             topLeft: const Radius.circular(12),
//                                             topRight: const Radius.circular(12),
//                                             bottomLeft: isMe
//                                                 ? const Radius.circular(12)
//                                                 : const Radius.circular(0),
//                                             bottomRight: isMe
//                                                 ? const Radius.circular(0)
//                                                 : const Radius.circular(12),
//                                           ),
//                                         ),
//                                         padding: const EdgeInsets.all(12),
//                                         child: Text(
//                                           message.content,
//                                           style: TextStyle(
//                                             color: isMe
//                                                 ? ColorConstants.whiteColor
//                                                 : ColorConstants.blackColor,
//                                             fontSize: 14,
//                                             fontFamily: Fonts.poppinsMedium,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                       Center(
//                         child: Column(
//                           children: [
//                             GestureDetector(
//                               onTap: _toggleConversation,
//                               child: SvgPicture.asset(
//                                 _isRunning
//                                     ? ImageConstants.stop
//                                     : ImageConstants.micBlue,
//                                 height: 84,
//                                 width: 84,
//                               ),
//                             ),
//                             const SizedBox(height: 15),
//                             Text(
//                               _isRunning
//                                   ? "Tap to stop the conversation"
//                                   : "Tap to start the conversation",
//                               style: TextStyle(
//                                 color: ColorConstants.greyColor,
//                                 fontSize: 14,
//                                 fontFamily: Fonts.poppinsRegular,
//                                 fontWeight: FontWeight.w400,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       30.0.spaceY,
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget typingBubble() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(right: 8.0),
//             child: CircleAvatar(
//               radius: 16,
//               backgroundColor: ColorConstants.blueColor,
//               backgroundImage: AssetImage(ImageConstants.aiChat),
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//             decoration: BoxDecoration(
//               color: ColorConstants.bgQuoteCard,
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(8),
//                 topRight: Radius.circular(8),
//                 bottomRight: Radius.circular(8),
//               ),
//             ),
//             child: const Text(
//               "Typing...",
//               style: TextStyle(
//                 fontSize: 14,
//                 fontFamily: Fonts.poppinsMedium,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
