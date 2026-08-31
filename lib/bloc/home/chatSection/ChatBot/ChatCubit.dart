import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../../Constants/ApiClass/alertHelperForSubsPopup.dart';
import '../../../../Helpers/CreditManager/CreditManager.dart';
import '../../../../Helpers/GreetingHelpers/GreetingHelper.dart';
import '../../../../Helpers/GreetingHelpers/GreetingStorage.dart';
import '../../../../Helpers/NoInternetDialog.dart';
import '../../../../Screens/Profile/SettingScreen/SettingMenuScreen/3_AddOnPacks/AddOnPacksScreen.dart';
import 'chat_implementation.dart';
import 'chat_model.dart';

class ChatCubit extends Cubit<List<Map<String, String>>> {
  void Function(ChatResponseStatus status)? onResponse;
  VoidCallback? onInternetLost;
  StreamSubscription? _internetSub;
  bool _isHistoryLoading = false;
  bool _needFreshSession = false;
  final ValueNotifier<bool> historyLoadingNotifier = ValueNotifier(false);
  ChatCubit({
    required String accessToken,
    required String existingSessionId,
    required bool isNewSession,
    required BuildContext context,
  }) : _repo = ChatRepositoryImpl(),
       super(_initialMessages()) {
    currentGreeting = _initialGreeting;
    _repo.setInitialGreeting(currentGreeting);
    _init(accessToken, existingSessionId, isNewSession, context);
    _startInternetListener();
  }

  final ChatRepositoryImpl _repo;
  StreamSubscription? _sub;
  // dynamic _internetSub;
  final _internetStatusController = StreamController<bool>.broadcast();
  bool _isConnected = true;

  Timer? _responseTimer;
  bool _isStopped = false;

  bool get isConnected => _isConnected;

  Stream<bool> get internetStream => _internetStatusController.stream;
  String currentGreeting = "";

  static String _initialGreeting = "";

  static List<Map<String, String>> _initialMessages() {
    _initialGreeting = GreetingHelper.getRandomGreeting();

    // return [
    //   {'type': 'bot', 'text': "I’m your WILCO."},
    //   {'type': 'bot', 'text': _initialGreeting},
    // ];

    return [
      {'type': 'bot', 'text': "I’m your WILCO.\n\n$_initialGreeting"},
    ];
  }

  Future<void> _init(
    String token,
    String sessionId,
    bool isNewSession,
    BuildContext context,
  ) async {
    if (await InternetConnection().hasInternetAccess) {
      _repo.setResponseCallback((event) {
        switch (event.status) {
          case ChatResponseStatus.tokenLimitExpired:
            final next = List<Map<String, String>>.from(state)
              ..removeWhere((m) => m['type'] == 'analyzing');
            emit(next);
            onResponse?.call(ChatResponseStatus.tokenLimitExpired);
            break;
          case ChatResponseStatus.creditLimitExpired:
            final next = List<Map<String, String>>.from(state)
              ..removeWhere((m) => m['type'] == 'analyzing');
            emit(next);
            onResponse?.call(ChatResponseStatus.creditLimitExpired);
            break;

          case ChatResponseStatus.accessTokenExpired:
            final next = List<Map<String, String>>.from(state)
              ..removeWhere((m) => m['type'] == 'analyzing');
            emit(next);
            onResponse?.call(ChatResponseStatus.accessTokenExpired);
            break;
          case ChatResponseStatus.subscriptionExpired:
            final next = List<Map<String, String>>.from(state)
              ..removeWhere((m) => m['type'] == 'analyzing');
            emit(next);
            onResponse?.call(ChatResponseStatus.subscriptionExpired);
            break;
          default:
            break;
        }
      });

      // _repo.onSocketConnected = () async {
      //   if (sessionId.isNotEmpty) {
      //     await _loadCompleteHistory(sessionId);
      //   }
      // };

      // _repo.onSocketConnected = () async {
      //   final currentSessionId = _repo.currentSessionId;
      //   if (currentGreeting.isNotEmpty &&
      //       currentSessionId != null &&
      //       currentSessionId.isNotEmpty) {
      //     await GreetingStorage.save(currentSessionId, currentGreeting);
      //   }
      //
      //   if (_isHistoryLoading) return;
      //
      //   if (currentSessionId != null && currentSessionId.isNotEmpty) {
      //     _isHistoryLoading = true;
      //
      //     try {
      //       await _loadCompleteHistory(currentSessionId);
      //     } finally {
      //       _isHistoryLoading = false;
      //     }
      //   }
      // };

      _repo.onSocketConnected = () async {
        final currentSessionId = _repo.currentSessionId;

        if (currentSessionId != null && currentSessionId.isNotEmpty) {
          final savedGreeting = await GreetingStorage.get(currentSessionId);

          if (savedGreeting != null && savedGreeting.isNotEmpty) {
            currentGreeting = savedGreeting;
          } else {
            currentGreeting = GreetingHelper.getRandomGreeting();

            await GreetingStorage.save(currentSessionId, currentGreeting);
          }

          if (_isHistoryLoading) return;

          _isHistoryLoading = true;

          try {
            await _loadCompleteHistory(currentSessionId);
          } finally {
            _isHistoryLoading = false;
          }
        }
      };

      if (_isConnected) {
        await _repo.connect(accessToken: token, existingSessionId: sessionId);
      }
      _sub = _repo.messages.listen(_onSocketMessage);
    } else {
      NoInternetDialog.show(
        context,
        onRetry: () => _init(token, sessionId, isNewSession, context),
      );
      return;
    }
  }

  Future<void> startFreshChat() async {
    print("🔥 startFreshChat called");
    currentGreeting = GreetingHelper.getRandomGreeting();
    _repo.setInitialGreeting(currentGreeting);
    print("CURRENT GREETING => $currentGreeting");
    // emit([
    //   {'type': 'bot', 'text': "I’m your WILCO."},
    //   {'type': 'bot', 'text': currentGreeting},
    // ]);

    emit([
      {'type': 'bot', 'text': "I’m your WILCO.\n\n$currentGreeting"},
    ]);
    await _repo.resetSession();
    await _repo.reconnect();
  }

  Future<void> _loadCompleteHistory(String sessionId) async {
    historyLoadingNotifier.value = true;

    final List<Map<String, String>> greeting = [
      {'type': 'bot', 'text': "I’m your WILCO."},
    ];

    emit(greeting);

    try {
      final isConnected = await InternetConnection().hasInternetAccess;

      if (!isConnected) {
        print("No internet connection. Cannot load chat history.");
        return;
      }

      final serverMessages = await _repo.fetchFullServerHistory(sessionId);

      final uiList = serverMessages.asMap().entries.map((entry) {
        final index = entry.key;
        final msg = entry.value;

        final role = msg.role.toLowerCase();

        return {
          'type': index == 0 && role == 'assistant'
              ? 'initial_greeting'
              : role == 'user'
              ? 'user'
              : 'bot',
          'text': msg.content,
        };
      }).toList();

      emit([...greeting, ...uiList]);
    } catch (e) {
      print("History Error => $e");
    } finally {
      historyLoadingNotifier.value = false;
    }
  }

  Future<void> openAddOnPacksBottomSheet(
    BuildContext context,
    AddOnPackType packType,
  ) async {
    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return FractionallySizedBox(
          heightFactor: 0.80,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: AddOnPacksScreen(packType: packType),
          ),
        );
      },
    );
  }

  Future<void> sendMessage(
    String text,
    BuildContext context,
    bool isReceivedTokenFullWarning,
  ) async {
    if (await InternetConnection().hasInternetAccess) {
      if (CreditManager().remainingToken <= 0 ||
          isReceivedTokenFullWarning == true) {
        Future.microtask(() {
          AlertHelperForSubsPopup.showSubscriptionEndAlert(
            isFromTrackingClass: false,
            context: context,
            title: "Token limit exhausted",
            isFromWilcoAndTrackingScreen: true,
            buttonText: "Buy Token",
            message:
                "Your token limit has been exhausted. Please purchase a extra tokens.",
            onGoToActionBlock: () {
              openAddOnPacksBottomSheet(context, AddOnPackType.tokensOnly);
            },
          );
        });
        return;
      }

      _isStopped = false;
      final next = List<Map<String, String>>.from(state)
        ..removeWhere((m) => m['type'] == 'analyzing');

      next.add({'type': 'user', 'text': text});

      if (!_isConnected) {
        next.add({'type': 'bot', 'text': 'Message not sent. No internet'});
        emit(next);
        return;
      }

      next.add({'type': 'analyzing', 'text': ''});
      emit(next);

      _responseTimer?.cancel();
      _responseTimer = Timer(const Duration(seconds: 15), () {
        // _handleNoResponse();
      });

      _repo.send(text);
    } else {
      NoInternetDialog.show(
        context,
        onRetry: () async {
          final hasInternet = await InternetConnection().hasInternetAccess;

          if (hasInternet) {
            await _repo.reconnect();
          } else {
            NoInternetDialog.show(context, onRetry: () async {});
          }
        },
      );
      return;
    }
  }

  void _handleNoResponse() {
    final next = List<Map<String, String>>.from(state);

    next.removeWhere((m) => m['type'] == 'analyzing');

    next.add({
      'type': 'bot',
      'text': 'Sorry, an error occurred while processing your request.',
    });

    emit(next);
  }

  List<Map<String, String>> removeDuplicates(List<Map<String, String>> items) {
    final seen = <String>{};
    final filtered = <Map<String, String>>[];

    for (final m in items) {
      final key = "${m['type']}|${m['text']?.trim()}";
      if (!seen.contains(key)) {
        seen.add(key);
        filtered.add(m);
      }
    }
    return filtered;
  }

  void _onSocketMessage(ChatMessage msg) {
    if (msg.text == "__SESSION_EXPIRED__") {
      emit(List<Map<String, String>>.from(state));
      return;
    }

    if (msg.text.contains("token")) {
      emit(List<Map<String, String>>.from(state));
      return;
    }

    _responseTimer?.cancel();
    if (_isStopped) return;
    final next = List<Map<String, String>>.from(state);

    if (msg.author == ChatAuthor.bot) {
      next.removeWhere((m) => m['type'] == 'analyzing');
    }

    final mapped = {
      'type': msg.author == ChatAuthor.user ? 'user' : 'bot',
      'text': msg.text.trim(),
    };
    // final isDuplicate = next.any(
    //       (m) =>
    //   m['type'] == mapped['type'] &&
    //       (m['text'] ?? '').trim() == mapped['text'],
    // );
    //
    // if (!isDuplicate) {
    //   next.add(mapped);
    // }
    //
    // emit(next);
    next.add(mapped);
    emit(next);
  }

  // void _startInternetListener() {
  //   _internetSub = Connectivity().onConnectivityChanged.listen((results) async {
  //     print("Connectivity Changed => $results");
  //
  //     final hasNetwork = !results.contains(ConnectivityResult.none);
  //
  //     if (!hasNetwork) {
  //
  //       if (_repo.currentSessionId == null ||
  //           _repo.currentSessionId!.isEmpty) {
  //         _needFreshSession = true;
  //
  //         print("⚠️ Session not created. Fresh session needed");
  //       }
  //       _repo.updateInternetStatus(false);
  //
  //       if (_isConnected) {
  //         _isConnected = false;
  //
  //         _internetStatusController.add(false);
  //
  //         print('[Internet] No Network');
  //
  //         _responseTimer?.cancel();
  //
  //         final next = List<Map<String, String>>.from(state);
  //         next.removeWhere((m) => m['type'] == 'analyzing');
  //         emit(next);
  //
  //         onInternetLost?.call();
  //       }
  //
  //       return;
  //     }
  //
  //     final hasInternet = await InternetConnection().hasInternetAccess;
  //
  //     print('Network Available: $hasNetwork, Internet Available: $hasInternet');
  //
  //     if (hasInternet) {
  //       if (!_isConnected) {
  //         _isConnected = true;
  //
  //         _repo.updateInternetStatus(true);
  //
  //         _internetStatusController.add(true);
  //         if (_needFreshSession) {
  //           print("🔥 Fresh Chat Triggered");
  //
  //           final next = List<Map<String, String>>.from(state);
  //
  //           next.removeWhere((m) => m['type'] == 'analyzing');
  //           for (int i = next.length - 1; i >= 0; i--) {
  //             if (next[i]['type'] == 'user') {
  //               print(
  //                 "Removing Pending Message => ${next[i]['text']}",
  //               );
  //
  //               next.removeAt(i);
  //               break;
  //             }
  //           }
  //
  //           emit(next);
  //
  //           await startFreshChat();
  //
  //           _needFreshSession = false;
  //         } else {
  //           print("🔥 Normal Reconnect");
  //
  //           await _repo.reconnect();
  //         }
  //       }
  //     } else {
  //       _repo.updateInternetStatus(false);
  //
  //       if (_isConnected) {
  //
  //         if (_repo.currentSessionId == null ||
  //             _repo.currentSessionId!.isEmpty) {
  //           _needFreshSession = true;
  //
  //           print("⚠️ Session not created. Fresh session needed");
  //         }
  //
  //         _isConnected = false;
  //
  //         _internetStatusController.add(false);
  //
  //         print('[Internet] Internet Lost');
  //
  //         _responseTimer?.cancel();
  //
  //         final next = List<Map<String, String>>.from(state);
  //         next.removeWhere((m) => m['type'] == 'analyzing');
  //         emit(next);
  //
  //         onInternetLost?.call();
  //       }
  //     }
  //   });
  // }

  void _startInternetListener() {
    _internetSub = Connectivity().onConnectivityChanged.listen((results) async {
      print("Connectivity Changed => $results");

      final hasNetwork = !results.contains(ConnectivityResult.none);

      // iOS fix: Connectivity kabhi-kabhi false none return karta hai
      if (!hasNetwork) {
        await Future.delayed(const Duration(seconds: 1));

        final hasInternet = await InternetConnection().hasInternetAccess;

        print("iOS None Check => Internet Available: $hasInternet");

        // Internet hai to false connectivity event ignore karo
        if (hasInternet) {
          print("⚡ Ignoring false iOS connectivity event");
          return;
        }

        if (_repo.currentSessionId == null || _repo.currentSessionId!.isEmpty) {
          _needFreshSession = true;
          print("⚠️ Session not created. Fresh session needed");
        }

        _repo.updateInternetStatus(false);

        if (_isConnected) {
          _isConnected = false;

          _internetStatusController.add(false);

          print('[Internet] No Network');

          _responseTimer?.cancel();

          final next = List<Map<String, String>>.from(state);
          next.removeWhere((m) => m['type'] == 'analyzing');

          emit(next);

          onInternetLost?.call();
        }

        return;
      }

      // Actual internet check
      await Future.delayed(const Duration(milliseconds: 500));

      final hasInternet = await InternetConnection().hasInternetAccess;

      print('Network Available: $hasNetwork, Internet Available: $hasInternet');

      if (hasInternet) {
        if (!_isConnected) {
          _isConnected = true;

          _repo.updateInternetStatus(true);

          _internetStatusController.add(true);

          if (_needFreshSession) {
            print("🔥 Fresh Chat Triggered");

            final next = List<Map<String, String>>.from(state);

            next.removeWhere((m) => m['type'] == 'analyzing');

            for (int i = next.length - 1; i >= 0; i--) {
              if (next[i]['type'] == 'user') {
                print("Removing Pending Message => ${next[i]['text']}");

                next.removeAt(i);
                break;
              }
            }

            emit(next);

            await startFreshChat();

            _needFreshSession = false;
          } else {
            print("🔥 Normal Reconnect");

            await _repo.reconnect();
          }
        }
      } else {
        _repo.updateInternetStatus(false);

        if (_isConnected) {
          if (_repo.currentSessionId == null ||
              _repo.currentSessionId!.isEmpty) {
            _needFreshSession = true;

            print("⚠️ Session not created. Fresh session needed");
          }

          _isConnected = false;

          _internetStatusController.add(false);

          print('[Internet] Internet Lost');

          _responseTimer?.cancel();

          final next = List<Map<String, String>>.from(state);
          next.removeWhere((m) => m['type'] == 'analyzing');

          emit(next);

          onInternetLost?.call();
        }
      }
    });
  }

  void stopResponse() {
    _isStopped = true;
    _responseTimer?.cancel();
    final next = List<Map<String, String>>.from(state)
      ..removeWhere((m) => m['type'] == 'analyzing');
    emit(next);
  }

  @override
  Future<void> close() async {
    _responseTimer?.cancel();
    await _sub?.cancel();
    await _internetSub?.cancel();
    await _internetStatusController.close();
    await _repo.dispose();
    return super.close();
  }

  Future<void> clearCurrentChat() async {
    currentGreeting = GreetingHelper.getRandomGreeting();
    _repo.setInitialGreeting(currentGreeting);
    // emit([
    //   {'type': 'bot', 'text': "I’m your WILCO."},
    //   {'type': 'bot', 'text': currentGreeting},
    // ]);

    emit([
      {'type': 'bot', 'text': "I’m your WILCO.\n\n$currentGreeting"},
    ]);

    await _repo.resetSession();
  }
}
