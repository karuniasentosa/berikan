import 'package:berikan/common/style.dart';
import 'package:berikan/ui/add_item_page.dart';
import 'package:berikan/ui/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:berikan/common/constant.dart';

class MainPage extends StatelessWidget {
  static const routeName = '/mainPage';

  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: OurSearchDelegate());
            },
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(
                Icons.perm_identity,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ),
          IconButton(
            onPressed: (){
              Navigator.pushNamed(context, ChatPage.routeName);
            },
            icon: const Icon(
              Icons.chat_outlined
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colorPrimary,
        onPressed: () {
          Navigator.pushNamed(context, AddItemPage.routeName);
        },
        label: Text(
          '+ Tambah',
          style: Theme.of(context).textTheme.button,
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('REKOMENDASI',
                      style:
                          blackTitle.copyWith(fontSize: 32, letterSpacing: 5)),
                  SizedBox(
                    height: 525,
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 5,
                          child: Column(
                            children: [
                              SizedBox(
                                child: Image.network(
                                  'https://caps.team/assets/img/merchandise/test1.png',
                                  fit: BoxFit.cover,
                                ),
                                height: 200,
                                width: 200,
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              Align(
                                child: Text(myProducts[index]['name']),
                                alignment: Alignment.centerLeft,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('JAKARTA BARAT'),
                                  Text('3 HARI LALU')
                                ],
                              )
                            ],
                          ),
                        );
                      },
                      itemCount: myProducts.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('BARU DILIHAT',
                      style:
                          blackTitle.copyWith(fontSize: 32, letterSpacing: 3)),
                  SizedBox(
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 225,
                          child: Card(
                            elevation: 5,
                            child: Column(
                              children: [
                                Container(
                                  child: Image.network(
                                    'https://caps.team/assets/img/merchandise/test1.png',
                                    fit: BoxFit.cover,
                                  ),
                                  height: 200,
                                  width: 200,
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Align(
                                  child: Text(myProducts[index]['name']),
                                  alignment: Alignment.centerLeft,
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('JAKARTA BARAT'),
                                    Text('3 HARI LALU')
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: myProducts.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('FAVORITKU',
                      style:
                          blackTitle.copyWith(fontSize: 32, letterSpacing: 5)),
                  SizedBox(
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 225,
                          child: Card(
                            elevation: 5,
                            child: Column(
                              children: [
                                Container(
                                  child: Image.network(
                                    'https://caps.team/assets/img/merchandise/test1.png',
                                    fit: BoxFit.cover,
                                  ),
                                  height: 200,
                                  width: 200,
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Align(
                                  child: Text(myProducts[index]['name']),
                                  alignment: Alignment.centerLeft,
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('JAKARTA BARAT'),
                                    Text('3 HARI LALU')
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: myProducts.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OurSearchDelegate extends SearchDelegate<String> {
  final dummyBarangBekas = [
    'Botol',
    'Mainan',
    'Koran',
    'Plastik',
    'Baju',
    'Celana'
  ];

  @override
  String? get searchFieldLabel => 'Cari di sini';

  @override
  TextStyle? get searchFieldStyle => GoogleFonts.roboto(
        fontSize: 18,
      );

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final dummySuggestion = query.isEmpty
        ? dummyBarangBekas
        : dummyBarangBekas
            .where((element) => element.startsWith(query))
            .toList();

    return ListView.builder(
        itemCount: dummySuggestion.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.search),
            title: RichText(
              text: TextSpan(
                  text: dummySuggestion[index].substring(0, query.length),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                        text: dummySuggestion[index].substring(query.length),
                        style: Theme.of(context).textTheme.bodyText2),
                  ]),
            ),
            onTap: () {
              query = dummySuggestion[index];
            },
          );
        });
  }
}
