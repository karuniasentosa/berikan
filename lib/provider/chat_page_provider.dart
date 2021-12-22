import 'package:berikan/api/chat_service.dart';
import 'package:berikan/api/model/chat_data.dart';
import 'package:berikan/provider/provider_result_state.dart';
import 'package:flutter/foundation.dart';

class ChatPageProvider extends ChangeNotifier
{
  ProviderResultState _state = ProviderResultState.noData;
  List<ChatData> _chatList = [];
  String _errorMessage = "";

  List<ChatData> get chats => _chatList;
  String get errorMessage => _errorMessage;
  ProviderResultState get state => _state;

  Future _getChats() async {
    _state = ProviderResultState.loading;
    _errorMessage = "";
    notifyListeners();
    try {
      final chats = await ChatService.getMyChats();
      if (chats == null) {
        // provide empty chat list
        _chatList = [];
        _state = ProviderResultState.noData;
        _errorMessage = "List is empty";
        notifyListeners();
        return;
      }
      _chatList.clear();
      for (final c in chats) {
        _chatList.add(await ChatData.of(c));
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
    _getChats();
  }
}