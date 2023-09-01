import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:social_app/components/local_image_widget.dart';
import 'package:social_app/services/icloudstorage_service.dart';
import 'package:social_app/utilities/service_locator/locator.dart';
import 'package:path/path.dart';

class MediaGrid extends StatefulWidget {
  final int userId;
  final int conversationId;
  final String functionName;
  final dynamic Function(String, int, int) handler;

  const MediaGrid(
      {super.key,
      required this.userId,
      required this.conversationId,
      required this.functionName,
      required this.handler});

  @override
  State<MediaGrid> createState() => _MediaGridState();
}

class _MediaGridState extends State<MediaGrid> {
  bool uploadingMedia = false;

  List<Widget> _mediaList = [];
  List<AssetEntity> _selectedList = [];
  int currentPage = 0;
  int? lastPage;

  Map<String, dynamic Function(String, int, int)> sendFileMessageHandler = {};

  @override
  void initState() {
    super.initState();
    sendFileMessageHandler[widget.functionName] = widget.handler;

    _fetchNewMedia();
  }

  _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        _fetchNewMedia();
      }
    }
  }

  // _showSelectedList() {
  //   for (var asset in _selectedList) {
  //     print("${asset.relativePath}${asset.id}");
  //   }
  //   print("-----------------------------------------");
  // }

  _fetchNewMedia() async {
    lastPage = currentPage;
    var result = await PhotoManager.requestPermissionExtend();
    if (result == PermissionState.authorized) {
      List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(onlyAll: true);
      List<AssetEntity> media =
          await albums[0].getAssetListPaged(page: currentPage, size: 60);
      print(media);

      List<Widget> temp = [];
      for (var asset in media) {
        temp.add(FutureBuilder(
          future: asset.thumbnailData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return LocalImageWidget(
                bytes: snapshot.data!,
                asset: asset,
                isSelected: (value) {
                  setState(() {});
                  if (value) {
                    _selectedList.add(asset);
                  } else {
                    _selectedList.remove(asset);
                  }
                  // _showSelectedList();
                },
              );
            }
            return Container();
          },
        ));
      }

      setState(() {
        _mediaList.addAll(temp);
        currentPage++;
      });
    } else {
      PhotoManager.openSetting();
    }
  }

  Future<String?> uploadFile(String directory, File? file) async {
    if (file == null) return null;

    final filename = basename(file.path);
    final destination = "/$directory/$filename";

    final downloadUrl = await provider
        .get<ICloudStorageService>()
        .uploadFile(destination, file);

    print('Download link: $downloadUrl');

    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          _handleScrollEvent(notification);
          return true;
        },
        child: GridView.builder(
          itemCount: _mediaList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, crossAxisSpacing: 2, mainAxisSpacing: 2),
          itemBuilder: (context, index) {
            return _mediaList[index];
          },
        ),
      ),
      Visibility(
        visible: _selectedList.isEmpty ? false : true,
        child: Positioned(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: uploadingMedia
                  ? ElevatedButton(onPressed: () {},
                   child: SizedBox(height: 20, width: 20, child: const CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation(Colors.white), strokeWidth: 2,))
                  )
                  : ElevatedButton.icon(
                      icon: const Icon(
                        Icons.send,
                        size: 15,
                      ),
                      onPressed: () async {
                        setState(() {
                          uploadingMedia = true;
                        });

                        _selectedList.forEach((element) async {
                          var file = await element.file;
                          int isImage = element.type == AssetType.image ? 1 : 0;

                          int isVideo = element.type == AssetType.video ? 1 : 0;

                          var link =
                              await uploadFile("conversations/images", file);

                          sendFileMessageHandler.forEach((key, value) async{
                            await value(link!, isImage, isVideo);
                          });
                        });

                        setState(() {
                          _selectedList.clear();
                        });

                        Navigator.of(context).pop();

                        setState(() {
                              uploadingMedia = false;
                            });
                      },
                      label: const Text("Send", style: TextStyle(fontSize: 12),),
                    ),
            ),
          ),
        ),
      ),
    ]);
  }
}
