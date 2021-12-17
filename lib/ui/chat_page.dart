import 'package:berikan/provider/chat_page_provider.dart';
import 'package:berikan/provider/provider_result_state.dart';
import 'package:berikan/ui/chat_detail_page.dart';
import 'package:berikan/utills/arguments.dart';
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
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Stack(alignment: Alignment.centerRight, children: [
              TextField(
                style: Theme.of(context).textTheme.overline,
                decoration: InputDecoration(
                    hintText: 'Cari orang',
                    hintStyle: Theme.of(context).textTheme.subtitle1),
              ),
              const Icon(
                Icons.search,
              ),
            ]),
          ),
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
                            child: Image.memory(chatDatas[index].theirImageData),
                          ),
                          title: Text(chatDatas[index].theirName),
                          subtitle: RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.black),
                                children: [
                                  // sorry for the long line :((
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
                  // TODO: Add no chat widget(?)
                  return Text('no chat');
                } else if (provider.state == ProviderResultState.loading) {
                  return CircularProgressIndicator();
                } else if (provider.state == ProviderResultState.error) {
                  // TODO: Add error widget(?)
                  return Text(provider.errorMessage);
                } else {
                  // TODO: handle no connectyion
                  return Placeholder();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
