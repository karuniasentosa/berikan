import 'package:berikan/provider/chat_page_provider.dart';
import 'package:berikan/provider/provider_result_state.dart';
import 'package:berikan/ui/chat_detail_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatelessWidget {
  static const routeName = '/chatPage';

  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ChatPageProvider>(context, listen: false).getMyChats();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatPageProvider>(
              builder: (context, provider, widget) {
                if (provider.state == ProviderResultState.hasData) {
                  final chatDatas = provider.chatDatas;
                  final chats = provider.chats;

                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                                context, ChatDetailPage.routeName,
                                arguments: chats[index],
                            );
                          },
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.memory(chatDatas[index].theirImageData, width: 55, height: 55, fit: BoxFit.cover,),
                          ),
                          title: Text(chatDatas[index].theirName),
                          subtitle: RichText(
                              text: TextSpan(
                                style: const TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                      text: chatDatas[index].lastSentId ==
                                            FirebaseAuth.instance.currentUser!.uid ?
                                            'Anda: ' : '',
                                      style: const TextStyle(fontWeight: FontWeight.bold)
                                  ),
                                  TextSpan(
                                      text: chatDatas[index].lastMessage ?? 'Mengirim gambar'
                                  )
                                ]
                              ),
                          )
                        ),
                      );
                    },
                    itemCount: chatDatas.length,
                  );
                } else if (provider.state == ProviderResultState.noData) {
                  return const Text('no chat');
                } else if (provider.state == ProviderResultState.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (provider.state == ProviderResultState.error) {
                  return Text(provider.errorMessage);
                } else {
                  return const Placeholder();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
