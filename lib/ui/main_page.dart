import 'dart:async';
import 'dart:typed_data';

import 'package:berikan/api/account_service.dart';
import 'package:berikan/api/item_service.dart';
import 'package:berikan/api/location_api.dart';
import 'package:berikan/api/model/item.dart';
import 'package:berikan/api/storage_service.dart';
import 'package:berikan/common/style.dart';
import 'package:berikan/ui/add_item_page.dart';
import 'package:berikan/ui/chat_page.dart';
import 'package:berikan/ui/item_detail.dart';
import 'package:berikan/ui/settings_page.dart';
import 'package:berikan/utills/arguments.dart';
import 'package:berikan/utils/datediff_describer.dart';
import 'package:berikan/widget/button/primary_button.dart';
import 'package:berikan/widget/main_gridview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

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
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, ChatPage.routeName);
            },
            icon: const Icon(Icons.chat_outlined),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, SettingsPage.routeName);
            },
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
                      child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Isi lokasi dulu!',
                              style: Theme.of(context).textTheme.headline4,
                              textAlign: TextAlign.center,
                            ),
                            const Text(
                                'Kami perlu mengetahui lokasi kamu agar orang dapat mengetahui letak kamu berada'),
                            Expanded(
                              child: DropdownButtonsLocation(
                                  onAdm1Selected: (adm1) {
                                _adm1 = adm1;
                              }, onAdm2Selected: (adm2) {
                                _adm2 = adm2;
                              }, onAdm3Selected: (adm3) {
                                _adm3 = adm3;
                              }),
                            ),
                            const Text(
                                'Lokasi yang sudah diatur tidak dapat diubah. Pastikan sudah memasukkan dengan benar!',
                                style: TextStyle(color: Colors.red)),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          child: const Text('Cancel')),
                                      PrimaryButton(
                                          text: 'Lanjut',
                                          onPressed: () {
                                            Navigator.pop(context, {
                                              'adm1': _adm1,
                                              'adm2': _adm2,
                                              'adm3': _adm3,
                                            });
                                          }),
                                    ]))
                          ]),
                    ),
                  );
                });
            if (result == false) {
              return;
            } else {
              AccountService.setLocation(uid,
                  adm1: result['adm1'],
                  adm2: result['adm2'],
                  adm3: result['adm3']);
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
                    child: StreamBuilder<List<QueryDocumentSnapshot<Item>>>(
                      stream: ItemService.getEveryItems(FirebaseFirestore.instance),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.data!.isEmpty) {
                          // in case there is no data, but this else if statement
                          // should never be the case since we have dummy data.
                          return const Center(
                            child: Text('Belum ada barang gratis, yuk tambahkan!'),
                          );
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
    final itemFuture =
        ItemService.searchItems(FirebaseFirestore.instance, query);
    return FutureBuilder<List<Item>>(
        future: itemFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            final itemResult = snapshot.requireData;
            if (itemResult.length == 0) {
              return const Text('Tidak ada data yang dapat ditemukan');
            }
            return ListView.builder(
                itemCount: itemResult.length,
                itemBuilder: (listViewContext, index) {
                  final item = itemResult[index];
                  final itemReference =
                      FirebaseStorage.instance.ref(item.imagesUrl[0]);
                  final imagePreviewFuture =
                      StorageService.getData(itemReference);
                  final locationFuture =
                      AccountService.getLocation(item.ownerId);
                  return GestureDetector(
                    onTap: () async {
                      final args =
                          DetailArguments(item, (await locationFuture)[2]);
                      Navigator.pushNamed(context, ItemDetailPage.routeName,
                          arguments: args);
                    },
                    child: ListTile(
                      shape: const Border(bottom: BorderSide()),
                      leading: AspectRatio(
                          aspectRatio: 1,
                          child: FutureBuilder<Uint8List?>(
                              future: imagePreviewFuture,
                              builder: (futureBuilderContext, snapshot) {
                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator();
                                } else {
                                  return Image.memory(
                                    snapshot.data!,
                                    fit: BoxFit.cover,
                                  );
                                }
                              })),
                      title: Text(item.name),
                      subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FutureBuilder<List<dynamic>>(
                                future: locationFuture,
                                builder: (futureBuilderContext, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Text('...');
                                  } else {
                                    return Text(snapshot.requireData[2]);
                                  }
                                }),
                            Text(DateDiffDescriber.dayDiff(
                                DateTime.now(), item.addedSince)),
                          ]),
                    ),
                  );
                });
          }
        });
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

  const DropdownButtonsLocation(
      {Key? key, required this.onAdm1Selected,
      required this.onAdm2Selected,
      required this.onAdm3Selected}) : super(key: key);

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
    super.initState();
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
