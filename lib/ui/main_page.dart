import 'dart:async';

import 'package:berikan/api/account_service.dart';
import 'package:berikan/api/item_service.dart';
import 'package:berikan/api/location_api.dart';
import 'package:berikan/api/model/account.dart';
import 'package:berikan/api/model/item.dart';
import 'package:berikan/common/constant.dart';
import 'package:berikan/common/style.dart';
import 'package:berikan/ui/add_item_page.dart';
import 'package:berikan/ui/chat_page.dart';
import 'package:berikan/widget/button/primary_button.dart';
import 'package:berikan/widget/main_gridview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;

class MainPage extends StatelessWidget {
  static const routeName = '/mainPage';

  final _fireStore = FirebaseFirestore.instance;

  MainPage({Key? key}) : super(key: key);

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
            onPressed: () {
              Navigator.pushNamed(context, ChatPage.routeName);
            },
            icon: const Icon(Icons.chat_outlined),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colorPrimary,
        onPressed: () async {
          final uid = AccountService.getCurrentUser()!.uid;
          // check if this user already filled the location
          final locationSet = await AccountService.isLocationSet(uid);

          if (!locationSet) {
            final result = await showDialog(
                context: context,
                builder: (context) {
                  String _adm1 = "";
                  String _adm2 = "";
                  String _adm3 = "";
                  return Dialog(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Isi lokasi dulu!',
                              style: Theme.of(context).textTheme.headline4,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                                'Kami perlu mengetahui lokasi kamu agar orang dapat mengetahui letak kamu berada'),
                            Expanded(
                              child: DropdownButtonsLocation(
                                  onAdm1Selected: (adm1) {
                                    _adm1 = adm1;
                                  },
                                  onAdm2Selected: (adm2) {
                                    _adm2 = adm2;
                                  },
                                  onAdm3Selected: (adm3) {
                                    _adm3 = adm3;
                                  }
                              ),
                            ),
                            Text('Lokasi yang sudah diatur tidak dapat diubah. Pastikan sudah memasukkan dengan benar!',
                                  style: TextStyle(color: Colors.red)),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          child: Text('Cancel')
                                      ),
                                      PrimaryButton(
                                          text: 'Lanjut',
                                          onPressed: () {
                                            Navigator.pop(context, {
                                              'adm1': _adm1,
                                              'adm2': _adm2,
                                              'adm3': _adm3,
                                            });
                                          }
                                      ),
                                    ]
                                )
                            )
                          ]
                      ),
                    ),
                  );
                }
            );
            if (result == false) {
              return;
            } else {
              AccountService.setLocation(uid, adm1: result['adm1'], adm2: result['adm2'], adm3: result['adm3']);
            }
          }
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
                    height: 500,
                    child: FutureBuilder<List<Item>>(
                      future: ItemService.getAllItems(_fireStore),
                      builder: (BuildContext context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return MainGridView(
                            snapshot: snapshot,
                          );
                        }
                      },
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
                                    Text('3 HARI LALU'),
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

class DropdownButtonsLocation extends StatefulWidget {
  final Function(String) onAdm1Selected;
  final Function(String) onAdm2Selected;
  final Function(String) onAdm3Selected;

  DropdownButtonsLocation(
      {required this.onAdm1Selected,
      required this.onAdm2Selected,
      required this.onAdm3Selected});

  @override
  State<StatefulWidget> createState() => _DropdownButtonsLocationState();
}

class _DropdownButtonsLocationState extends State<DropdownButtonsLocation> {
  ProvinceResponse? province;
  RegencyResponse? regency;
  DistrictResponse? district;

  final http.Client client = http.Client();

  final provinceValueNotifier = ValueNotifier<ProvinceResponse?>(null);
  final regencyValueNotifier = ValueNotifier<RegencyResponse?>(null);
  final districtValueNotifier = ValueNotifier<DistrictResponse?>(null);

  @override
  void initState() {
    RegencyListStream();
    DistrictListStream();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      FutureBuilder<List<ProvinceResponse>>(
          future: LocationApi.getProvinces(client),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            final provinceList = snapshot.requireData;
            return Column(
              children: [
                const Text('Provinsi'),
                ValueListenableBuilder<ProvinceResponse?>(
                  valueListenable: provinceValueNotifier,
                  builder: (context, _value, child) {
                    return DropdownButton<ProvinceResponse>(
                      isExpanded: true,
                      value: _value ?? provinceList[0],
                      onChanged: (ProvinceResponse? response) {
                        // set it to -1 so the stream sends []
                        DistrictListStream().getDistricts(-1);
                        if (response == null) return;
                        RegencyListStream().getRegencies(response.id);
                        widget.onAdm1Selected(response.name);
                        provinceValueNotifier.value = response;
                      },
                      items: provinceList.map((ProvinceResponse e) {
                        return DropdownMenuItem<ProvinceResponse>(
                          value: e,
                          child: Text(e.name,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              maxLines: 1),
                        );
                      }).toList(),
                    );
                  },
                )
              ],
            );
          }),
      StreamBuilder<List<RegencyResponse>>(
        stream: RegencyListStream().stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else if (snapshot.hasData && snapshot.requireData.isEmpty) {
            return Container();
          } else {
            final regencyList = snapshot.requireData.toSet().toList();
            return Column(
              children: [
                const Text('Kota/Kabupaten'),
                ValueListenableBuilder<RegencyResponse?>(
                  valueListenable: regencyValueNotifier,
                  builder: (context, _value, child) {
                    return DropdownButton<RegencyResponse>(
                      isExpanded: true,
                      value: _value ?? regencyList[0],
                      onChanged: (RegencyResponse? response) {
                        if (response == null) return;
                        DistrictListStream().getDistricts(response.id);
                        widget.onAdm2Selected(response.name);
                        regencyValueNotifier.value = response;
                      },
                      items: regencyList.map((RegencyResponse e) {
                        return DropdownMenuItem<RegencyResponse>(
                          value: e,
                          child: Text(e.name,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              maxLines: 1),
                        );
                      }).toList(),
                    );
                  },
                )
              ],
            );
          }
        },
      ),
      StreamBuilder<List<DistrictResponse>>(
          stream: DistrictListStream().stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            } else if (snapshot.hasData && snapshot.requireData.isEmpty) {
              return Container();
            } else {
              final districtList = snapshot.requireData.toSet().toList();
              return Column(
                children: [
                  const Text('Kecamatan'),
                  ValueListenableBuilder<DistrictResponse?>(
                    valueListenable: districtValueNotifier,
                    builder: (context, _value, child) {
                      return DropdownButton<DistrictResponse>(
                        isExpanded: true,
                        value: _value ?? districtList[0],
                        onChanged: (DistrictResponse? response) {
                          if (response == null) return;
                          widget.onAdm3Selected(response.name);
                          districtValueNotifier.value = response;
                        },
                        items: districtList.map((DistrictResponse e) {
                          return DropdownMenuItem<DistrictResponse>(
                            value: e,
                            child: Text(
                              e.name,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              maxLines: 1,
                            ),
                          );
                        }).toList(),
                      );
                    },
                  )
                ],
              );
            }
          }),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    RegencyListStream().stopStream();
    DistrictListStream().stopStream();
  }
}

// stres
class RegencyListStream {
  final http.Client client = http.Client();
  final StreamController<List<RegencyResponse>> _controller;

  static RegencyListStream? _instance;

  RegencyListStream._(this._controller);

  factory RegencyListStream() {
    if (_instance != null) {
      return _instance!;
    }
    return _instance = RegencyListStream._(StreamController());
  }

  Stream<List<RegencyResponse>> get stream => _controller.stream;

  void getRegencies(int provinceId) async {
    if (_controller.isClosed) {
      return;
    }

    if (provinceId == -1) {
      _controller.add([]);
      return;
    }

    _controller.add([]);
    final regencyList = await LocationApi.getRegencies(client, provinceId);
    _controller.add(regencyList);
  }

  void stopStream() {
    _controller.close();
    _instance = null;
  }
}

class DistrictListStream {
  final http.Client client = http.Client();
  final StreamController<List<DistrictResponse>> _controller;

  static DistrictListStream? _instance;

  DistrictListStream._(this._controller);

  factory DistrictListStream() {
    if (_instance != null) {
      return _instance!;
    }
    return _instance = DistrictListStream._(StreamController());
  }

  Stream<List<DistrictResponse>> get stream => _controller.stream;

  void getDistricts(int regencyId) async {
    if (_controller.isClosed) {
      return;
    }
    if (regencyId == -1) {
      _controller.add([]);
      return;
    }

    _controller.add([]);
    final districtList = await LocationApi.getDistricts(client, regencyId);
    _controller.add(districtList);
  }

  void stopStream() {
    _controller.close();
    _instance = null;
  }
}
