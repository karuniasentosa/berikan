import 'dart:typed_data';

import 'package:berikan/api/account_service.dart';
import 'package:berikan/api/geolocation_api.dart';
import 'package:berikan/api/storage_service.dart';
import 'package:berikan/data/provider/location_provider.dart';
import 'package:berikan/utills/arguments.dart';
import 'package:berikan/utils/datediff_describer.dart';
import 'package:berikan/widget/button/primary_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class ItemDetailPage extends StatelessWidget {
  static const routeName = '/itemDetail';
  final _fireStorage = FirebaseStorage.instance;

  ItemDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as DetailArguments;
    final imageRefList = [];
    for (int i = 0; i < args.itemDetail.imagesUrl.length; i++) {
      final ref = _fireStorage.ref(args.itemDetail.imagesUrl[i]);
      imageRefList.add(ref);
    }
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return LocationProvider(args.location, apiService: ApiService());
      },
      child: Scaffold(
        appBar: AppBar(title: Text(args.itemDetail.name)),
        body: DetailListView(args: args, imageRefList: imageRefList),
      ),
    );
  }
}

class DetailListView extends StatelessWidget {
  const DetailListView({
    Key? key,
    required this.args,
    required this.imageRefList,
  }) : super(key: key);

  final DetailArguments args;
  final List imageRefList;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        CarouselBuilder(args: args, imageRefList: imageRefList),
        Material(
          elevation: 5,
          color: Colors.white,
          child: Wrap(
            spacing: 16,
            direction: Axis.horizontal,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DESKRIPSI',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(args.itemDetail.description)
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Material(
          elevation: 20,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LOKASI',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                    height: 300,
                    child: Consumer<LocationProvider>(
                        builder: (context, provider, child) {
                      if (provider.state == ResultState.loading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (provider.state == ResultState.noData) {
                        return Center(child: Text(provider.message));
                      } else if (provider.state == ResultState.error) {
                        return Text('Error --> ${provider.message}');
                      } else {
                        return FlutterMap(
                          options: MapOptions(
                            center: LatLng(provider.latLangResult['lat']!,
                                provider.latLangResult['lng']!),
                            zoom: 13.0,
                          ),
                          layers: [
                            TileLayerOptions(
                              urlTemplate:
                                  "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                              subdomains: ['a', 'b', 'c'],
                            ),
                            CircleLayerOptions(circles: [
                              CircleMarker(
                                color: Colors.green.withOpacity(0.3),
                                borderStrokeWidth: 1.0,
                                borderColor: Colors.green,
                                radius: 100,
                                point: LatLng(provider.latLangResult['lat']!,
                                    provider.latLangResult['lng']!),
                              )
                            ])
                          ],
                        );
                      }
                    })),
                FutureBuilder<dynamic>(
                    future: AccountService.getLocation(args.itemDetail.ownerId),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      } else {
                        return Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                                '${snapshot.data[2]}, ${snapshot.data[1]}'));
                      }
                    }),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: AccountService.getAccountById(args.itemDetail.ownerId),
          builder: (BuildContext context, accountSnapshot) {
            if (!accountSnapshot.hasData) {
              return const CircularProgressIndicator();
            } else {
              return BottomAppBar(
                elevation: 20,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Diiklankan ${DateDiffDescriber.dayDiff(args.itemDetail.addedSince, DateTime.now())} oleh'),
                      SizedBox(
                        height: 4,
                      ),
                      Row(children: [
                        FutureBuilder<dynamic>(
                          future: AccountService.getProfilePicture(
                              args.itemDetail.ownerId),
                          builder: (BuildContext context, snapshot) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.data is String) {
                              return CircleAvatar(
                                child: Image.network(
                                    'https://images.unsplash.com/photo-1453728013993-6d66e9c9123a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8dmlld3xlbnwwfHwwfHw%3D&w=1000&q=80'),
                              );
                            } else {
                              return FutureBuilder<Uint8List?>(
                                  future: StorageService.getData(
                                      snapshot.data as Reference),
                                  builder: (context, imageUintSnap) {
                                    if (!imageUintSnap.hasData) {
                                      return const CircularProgressIndicator();
                                    } else {
                                      return CircleAvatar(
                                        radius: 30.0,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage:
                                            MemoryImage(imageUintSnap.data!),
                                      );
                                    }
                                  });
                            }
                          },
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Column(
                          children: [
                            Text(
                                '${accountSnapshot.data!.data()!['first_name']} ${accountSnapshot.data!.data()!['last_name']}'),
                            Text(
                                'Terdaftar sejak ${DateDiffDescriber.dayDiff((accountSnapshot.data!.data()!['joined_since'] as Timestamp).toDate(), DateTime.now())}')
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        )
                      ]),
                      SizedBox(
                        height: 4,
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: PrimaryButton(
                            onPressed: () {},
                            text: 'CHAT PENJUAL',
                          ))
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

class CarouselBuilder extends StatefulWidget {
  const CarouselBuilder({
    Key? key,
    required this.args,
    required this.imageRefList,
  }) : super(key: key);

  final DetailArguments args;
  final List imageRefList;

  @override
  State<CarouselBuilder> createState() => _CarouselBuilderState();
}

class _CarouselBuilderState extends State<CarouselBuilder> {
  int _current = 0;
  List<Uint8List?> loadedImageList = [];

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  void loadImage() async {
    for (int i = 0; i < widget.imageRefList.length; i++) {
      final img = await StorageService.getData(widget.imageRefList[i]);
      setState(() {
        loadedImageList.add(img);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CarouselSlider.builder(
          itemCount: widget.args.itemDetail.imagesUrl.length,
          itemBuilder: (context, index, pageViewIndex) {
            if (loadedImageList.length !=
                widget.args.itemDetail.imagesUrl.length) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Image.memory(loadedImageList[index]!);
            }
          },
          options: CarouselOptions(
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: widget.imageRefList.asMap().entries.map((entry) {
            return Container(
              width: 12.0,
              height: 12.0,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    Colors.black.withOpacity(_current == entry.key ? 0.9 : 0.4),
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}
