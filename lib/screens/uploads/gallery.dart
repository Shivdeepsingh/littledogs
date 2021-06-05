import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:littledog/screens/uploads/uploadimage.dart';
import 'package:photo_manager/photo_manager.dart';

class Gallery extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GalleryState();
  }
}

class GalleryState extends State<Gallery> {
  List<AssetEntity> assets = [];
  _fetchAssets() async {
    // Set onlyAll to true, to fetch only the 'Recent' album
    // which contains all the photos/videos in the storage
    final albums = await PhotoManager.getAssetPathList(onlyAll: true);
    final recentAlbum = albums.first;

    // Now that we got the album, fetch all the assets it contains
    final recentAssets = await recentAlbum.getAssetListRange(
      start: 0, // start at index 0
      end: 1000000, // end at a very big index (to get all the assets)
    );

    // Update the state and notify UI
    setState(() => assets = recentAssets);
  }

  @override
  void initState() {
    _fetchAssets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // A grid view with 3 items per row
        crossAxisCount: 3,
      ),
      itemCount: assets.length,
      itemBuilder: (_, index) {
        return AssetThumbnail(asset: assets[index]);
      },
    );
  }
}

class AssetThumbnail extends StatelessWidget {
  const AssetThumbnail({
    Key key,
    @required this.asset,
  }) : super(key: key);

  final AssetEntity asset;

  @override
  Widget build(BuildContext context) {
    // We're using a FutureBuilder since thumbData is a future
    return FutureBuilder<Uint8List>(
      future: asset.thumbData,
      builder: (_, snapshot) {
        final bytes = snapshot.data;
        // If we have no data, display a spinner
        if (bytes == null)
          return Container(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(),
          );
        // If there's data, display it as an image
        return InkWell(
          onTap: () async {
            print(asset.type);
            final video = await asset.file;
            print("mjbjb");
            if (asset.type == AssetType.image) {
              print("mjbjb");
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UploadImage(
                          type: "image",
                          post: video,
                          value: "gallery",
                        )),
              );
            }

            if (asset.type == AssetType.video) {
              print("mjbjb");
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UploadImage(
                          type: "video",
                          post: video,
                          value: "gallery",
                        )),
              );
            }
          },
          child: Image.memory(bytes, fit: BoxFit.cover),
        );
      },
    );
  }
}

//   Map<dynamic, dynamic> allImageInfo = new Has
//
//   hMap();
//   List allImage = new List();
//
//   @override
//   void initState() {
//     super.initState();
//     loadImageList();
//   }
//
//   Future<void> loadImageList() async {
//     Map<dynamic, dynamic> allImageTemp;
//     allImageTemp = await FlutterGallaryPlugin.getAllImages;
//     // print(" call $allImageTemp.length");
//
//     setState(() {
//       this.allImage = allImageTemp['URIList'] as List;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return _buildGrid();
//   }
//
//   Widget _buildGrid() {
//     return GridView.count(
//         crossAxisCount: 4,
//         crossAxisSpacing: 20.0,
//         mainAxisSpacing: 20.0,
//         shrinkWrap: true,
//         reverse: false,
//         physics: ScrollPhysics(),
//         children: _buildGridTileList(allImage.length));
//   }
//
//   List<Container> _buildGridTileList(int count) {
//     return List<Container>.generate(
//         count,
//         (int index) => Container(
//                 child: new Column(
//               mainAxisSize: MainAxisSize.max,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 GestureDetector(
//                   child: Image.file(
//                     File(allImage[index].toString()),
//                     width: 60.0,
//                     height: 60.0,
//                     fit: BoxFit.cover,
//                   ),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => UploadImage(
//                                 File(allImage[index]),
//                                 "gallery",
//                                 "image",
//                               )),
//                     );
//                     print(allImage[index].toString());
//                   },
//                 )
//                 // Text(allNameList[index]
//
//                 // )
//               ],
//             )));
//   }
// }
