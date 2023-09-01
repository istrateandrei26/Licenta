import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:social_app/components/profile_image_choice_widget.dart';

class GroupImagePicker extends StatefulWidget {
  const GroupImagePicker(
      {super.key,
      required this.handler,
      this.groupId,
      required this.choosePictureText, required this.confirmText});

  final Function(File) handler;
  final groupId;
  final String choosePictureText;
  final String confirmText;

  @override
  State<GroupImagePicker> createState() => _GroupImagePickerState();
}

class _GroupImagePickerState extends State<GroupImagePicker> {
  List<Widget> _mediaList = [];
  AssetEntity? _selectedImage;
  Uint8List? _selectedImageData;
  int currentPage = 0;
  int? lastPage;
  bool processing = false;

  @override
  void initState() {
    super.initState();

    _fetchNewMedia();
  }

  _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        _fetchNewMedia();
      }
    }
  }

  _fetchNewMedia() async {
    lastPage = currentPage;
    var result = await PhotoManager.requestPermissionExtend();
    if (result == PermissionState.authorized) {
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
          onlyAll: true, type: RequestType.image);
      List<AssetEntity> media =
          await albums[0].getAssetListPaged(page: currentPage, size: 60);
      print(media);

      List<Widget> temp = [];
      for (var asset in media) {
        temp.add(FutureBuilder(
          future: asset.thumbnailData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return InkWell(
                onTap: () async {
                  _selectedImage = asset;
                  var selectedImageData = await _selectedImage!.thumbnailData;

                  setState(() {
                    _selectedImageData = selectedImageData;
                  });
                },
                child: ProfileImageChoiceWidget(
                  bytes: snapshot.data!,
                  asset: asset,
                ),
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

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          _handleScrollEvent(notification);
          return true;
        },
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                  color: Colors.transparent,
                  child: _selectedImage == null
                      ? Center(
                          child: Text(widget.choosePictureText,
                              style: TextStyle(fontSize: 18)))
                      : CircleAvatar(
                          radius: 40,
                          backgroundImage: MemoryImage(_selectedImageData!),
                        )),
            ),
            Expanded(
              flex: 4,
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _mediaList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, crossAxisSpacing: 2, mainAxisSpacing: 2),
                itemBuilder: (context, index) {
                  return _mediaList[index];
                },
              ),
            ),
          ],
        ),
      ),
      Visibility(
        visible: _selectedImage == null ? false : true,
        child: Positioned(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blue.shade400)),
                onPressed: processing
                    ? () {}
                    : () async {
                        setState(() {
                          processing = true;
                        });

                        final path = (await _selectedImage!.file)!.path;
                        File image = File(path);

                        await widget.handler(image);

                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();

                        setState(() {
                          _selectedImage = null;
                          processing = false;
                        });
                      },
                child: processing
                    ? const SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator.adaptive(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white)))
                    : Text(widget.confirmText),
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
