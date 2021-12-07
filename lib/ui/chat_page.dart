import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  static const routeName = '/chatPage';
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            child: ListView.builder(itemBuilder: (context, index){
              return Card(
                child: ListTile(
                  leading: Image.network('https://asset.kompas.com/crops/1g9P4L73NLmOshdRUptmBe_oQgQ=/0x0:698x465/750x500/data/photo/2020/12/07/5fce3837c4f6d.jpg'),
                  title: Text('John Doe'),
                  subtitle: Text('Siap, saya segera kesana!'),
                ),
              );
            }, itemCount: 8,),
          ),
        ],
      ),
    );
  }
}
