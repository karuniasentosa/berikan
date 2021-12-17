import 'dart:async';

import 'package:berikan/api/model/chat.dart';
import 'package:berikan/api/model/extensions/chat_extensions.dart';
import 'package:berikan/api/model/message.dart';
import 'package:berikan/provider/provider_result_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatDetailPageProvider extends ChangeNotifier
{
  ProviderResultState _state = ProviderResultState.noData;
  Stream<List<Message>>? _messageListStream;
  String _errorMessage = "";

  ProviderResultState get state => _state;
  Stream<List<Message>> get messages => _messageListStream!;
  String get errorMessage => _errorMessage;

  Future _getMessage(Chat chat) async
  {
    try {
      _messageListStream = chat.messages.transform(_MyStreamTransformer());
      _state = ProviderResultState.hasData;
    } catch (e) {
      _state = ProviderResultState.error;
      _errorMessage = e.toString();
      rethrow;
    }
  }

  void getMessage(Chat chat) {
    _state = ProviderResultState.loading;
    notifyListeners();
    _getMessage(chat);
  }
}

// grabbed from https://stackoverflow.com/a/63982248/
class _MyStreamTransformer implements StreamTransformer<QuerySnapshot<Message>, List<Message>>
{
  final StreamController<List<Message>> _controller = StreamController();
  StreamSubscription<QuerySnapshot<Message>>? streamSubscription;

  @override
  Stream<List<Message>> bind(Stream<QuerySnapshot<Message>> stream) {
    streamSubscription = stream.listen((event) {
      final qdsList = event.docs;
      _controller.add(qdsList.map((e) => e.data()).toList());
    });

    return _controller.stream;
  }

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() {
    return StreamTransformer.castFrom(this);
  }
}