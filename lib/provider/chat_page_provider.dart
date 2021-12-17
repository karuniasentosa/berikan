import 'package:berikan/api/chat_service.dart';
import 'package:berikan/api/model/chat.dart';
import 'package:berikan/api/model/chat_data.dart';
import 'package:berikan/provider/provider_result_state.dart';
import 'package:flutter/foundation.dart';

class ChatPageProvider extends ChangeNotifier
{
  ProviderResultState _state = ProviderResultState.noData;
  List<Chat> _chat = [];
  List<ChatData> _chatData = [];
  String _errorMessage = "";

  List<Chat> get chats => _chat;
  List<ChatData> get chatDatas => _chatData;
  String get errorMessage => _errorMessage;
  ProviderResultState get state => _state;

  Future _getChats() async {
    _state = ProviderResultState.loading;
    _errorMessage = "";
    notifyListeners();
    try {
      final chats = await ChatService.getMyChats();
      if (chats == null) {
        _chat = [];
        _chatData = [];
        _state = ProviderResultState.noData;
        _errorMessage = "List is empty";
        notifyListeners();
        return;
      }
      _chat.clear();
      for (final c in chats) {
        _chat.add(c);
        _chatData.add(await ChatData.of(c));
      }
      _state = ProviderResultState.hasData;
      notifyListeners();
    } catch (e) {
      _state = ProviderResultState.error;
      _errorMessage = e.toString();
      notifyListeners();
      // TODO: delete this later.
      rethrow;
    }
  }
  
  void getMyChats() {
    _chat = [];
    _chatData = [];
    _getChats();
  }
}