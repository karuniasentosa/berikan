import 'package:berikan/common/style.dart';
import 'package:berikan/utills/arguments.dart';
import 'package:berikan/widget/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:berikan/common/constant.dart';

class ChatDetailPage extends StatelessWidget {
  static const routeName = '/chatDetailPage';

  const ChatDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Arguments;

    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(args.imageUrl),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Text(args.name),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: dummyChat2.length,
                itemBuilder: (BuildContext context, int index) {
                  return MessageBubble(sender: dummyChat2[index]['sender'], text: dummyChat2[index]['message'], isMyChat: dummyChat2[index]['sender'] == 'Me');
                },
              ),
            ),
            const SizedBox(height: 8,),
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
                      icon: const Icon(Icons.photo_camera_outlined, color: Colors.white), onPressed: () {  },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0, top: 8, bottom: 8),
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
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
                      icon: const Icon(Icons.send, color: Colors.white,), onPressed: () {  },
                    ),
                  ),
                ),
              ],
            ),


          ],
        ));
  }
}
