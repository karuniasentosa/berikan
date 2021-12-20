import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:berikan/api/account_service.dart';
import 'package:berikan/api/model/chat.dart';
import 'package:berikan/api/model/extensions/chat_extensions.dart';
import 'package:berikan/api/model/chat_data.dart';
import 'package:berikan/api/model/message.dart';
import 'package:berikan/api/storage_service.dart';
import 'package:berikan/common/style.dart';
import 'package:berikan/provider/chat_detail_page_provider.dart';
import 'package:berikan/provider/provider_result_state.dart';
import 'package:berikan/utils/related_to_strings.dart';
import 'package:berikan/widget/icon_with_text.dart';
import 'package:berikan/widget/message_bubble.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChatDetailPage extends StatelessWidget {
  static const routeName = '/chatDetailPage';

  final Chat chat;
  ChatDetailPage({Key? key, required this.chat}) : super(key: key);

  final _textEditingController = TextEditingController();
  final _chatScrollingController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Provider.of<ChatDetailPageProvider>(context, listen: false)
        .getMessage(chat);
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: FutureBuilder<ChatData>(
                      future: ChatData.of(chat),
                      builder: (context, AsyncSnapshot<ChatData> snapshot) {
                        if (snapshot.hasData) {
                          return Image.memory(snapshot.data!.theirImageData);
                        } else {
                          return Container(color: Colors.grey);
                        }
                      }),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              FutureBuilder<ChatData>(
                  future: ChatData.of(chat),
                  builder: (context, AsyncSnapshot<ChatData> snapshot) {
                    if (snapshot.hasData) {
                      return Text(snapshot.data!.theirName);
                    } else {
                      return Text('...');
                    }
                  }),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Consumer<ChatDetailPageProvider>(
                builder: (context, provider, _) {
                  if (provider.state == ProviderResultState.loading) {
                    return CircularProgressIndicator();
                  } else if (provider.state == ProviderResultState.noData) {
                    return Text('no data');
                  } else if (provider.state == ProviderResultState.hasData) {
                    return StreamBuilder<List<Message>>(
                      stream: provider.messages,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final messageList = snapshot.requireData;
                          return ListView.builder(
                            reverse: true,
                            controller: _chatScrollingController,
                            itemCount: messageList.length,
                            itemBuilder: (BuildContext context, int index) {
                              final message = messageList[index];
                              if (message.attachment != null) {
                                // TODO: bagian ini jelek banget ::(
                                return FutureBuilder<Uint8List?>(
                                    future: StorageService.getData(FirebaseStorage.instance.ref(message.attachment!)),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return MessageBubble.attachment(
                                            time: TimeOfDay.fromDateTime(message.when),
                                            imageFile: snapshot.requireData!,
                                            isMyChat: AccountService.getCurrentUser()!.uid == message.accountId);
                                      } else {
                                          return Placeholder();
                                      }
                                    }
                                );
                              } else {
                                return MessageBubble.text(
                                    time: TimeOfDay.fromDateTime(message.when),
                                    text: message.content!,
                                    isMyChat:
                                        AccountService.getCurrentUser()!.uid ==
                                            message.accountId);
                              }
                            },
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    );
                  } else {
                    return Text('error: ${provider.errorMessage}');
                  }
                },
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    width: 50,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorPrimary,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.photo_camera_outlined,
                          color: Colors.white),
                      onPressed: () async {
                        final file = await _showImagePickerDialog(context);
                        if (file != null) {
                          final random = Random(DateTime.now().millisecond);
                          final _storageInstance = FirebaseStorage.instance;
                          final ref = _storageInstance.ref('chat_attachment')
                                              .child(chat.id)
                                              .child(randomString(random, length: 7));
                          StorageService.putData(ref, file.readAsBytesSync());
                          final message = Message.attachment(
                              accountId: AccountService.getCurrentUser()!.uid,
                              imageRef: ref.fullPath
                          );
                          chat.pushMessage(message);
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: 8.0, top: 8, bottom: 8),
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      controller: _textEditingController,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    height: 40,
                    width: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorPrimary
                    ),
                    child: IconButton(
                      disabledColor: Colors.grey,
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      onPressed: _sendMessage,
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
    );
  }

  void _sendMessage() {
    if (_textEditingController.text.isNotEmpty) {
      final message = Message.text(
          accountId: AccountService.getCurrentUser()!.uid,
          content: _textEditingController.text
      );
      chat.pushMessage(message);
      _textEditingController.clear();

      Future.delayed(Duration(milliseconds: 500), () {
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    _chatScrollingController.animateTo(
        _chatScrollingController.position.minScrollExtent,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeIn
    );
  }

  Future<File?> _showImagePickerDialog(BuildContext context) async {
    File? _file;

    Future<File?> chooseImageCamera() async {
      final XFile? file = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (file != null) {
        return File(file.path);
      }
      return null;
    }

    Future<File?> chooseImageGallery() async {
      final XFile? file = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (file != null) {
        return File(file.path);
      }
      return null;
    }

    await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(title: Text('Ambil gambar dari...'), children: [
            SimpleDialogOption(
              child:
              IconWithText(icon: const Icon(Icons.image), text: 'Galeri'),
              onPressed: () async {
                _file = await chooseImageGallery();
                Navigator.pop(context);
              },
            ),
            SimpleDialogOption(
                child: IconWithText(
                    icon: const Icon(Icons.camera), text: 'Kamera'),
                onPressed: () async {
                  _file = await chooseImageCamera();
                  Navigator.pop(context);
                })
          ]);
        });
    return _file;
  }
}
