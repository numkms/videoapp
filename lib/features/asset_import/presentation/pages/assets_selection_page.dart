import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class AssetsSelectionPage extends StatelessWidget {
  const AssetsSelectionPage({Key? key}) : super(key: key);

  Future<List<AssetEntity>> getAssets() async {
    var paths = await PhotoManager.getAssetPathList(onlyAll: true);
    return paths.first.getAssetListPaged(page: 0, size: 20);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PermissionState>(
      builder: (context, _ps) {
        if (_ps.data?.isAuth != null) {
          return FutureBuilder<List<AssetEntity>>(
              future: getAssets(),
              builder: (context, future) {
                return CupertinoPageScaffold(
                    navigationBar: CupertinoNavigationBar(
                      middle: Builder(builder: (context) {
                        return Text("as");
                      }),
                    ),
                    child: SafeArea(
                      child: CustomScrollView(
                        slivers: [
                          SliverGrid(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  if (future.data![index].videoDuration ==
                                      Duration.zero) {
                                    return Container(
                                      child: Image(
                                          fit: BoxFit.cover,
                                          image: AssetEntityImageProvider(
                                              future.data![index],
                                              thumbnailSize:
                                                  ThumbnailSize(200, 200),
                                              thumbnailFormat:
                                                  ThumbnailFormat.jpeg)),
                                    );
                                  } else {
                                    return Container(
                                      child: Stack(
                                        fit: StackFit.passthrough,
                                        // alignment: Alignment.center,
                                        children: [
                                          Image(
                                              fit: BoxFit.cover,
                                              image: AssetEntityImageProvider(
                                                  future.data![index],
                                                  thumbnailSize:
                                                      ThumbnailSize(200, 200),
                                                  thumbnailFormat:
                                                      ThumbnailFormat.jpeg)),
                                          new Align(
                                            //constraints.biggest.height to get the height
                                            // * .05 to put the position top: 5%
                                            alignment: Alignment.bottomRight,
                                            child: new Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 5),
                                              child: Icon(
                                                CupertinoIcons.play_fill,
                                                size: 20,
                                                color: Color.fromARGB(
                                                    255, 41, 66, 209),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                                childCount: future.data != null
                                    ? future.data!.length
                                    : 0,
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200.0,
                                mainAxisSpacing: 0.0,
                                crossAxisSpacing: 1.0,
                                childAspectRatio: 1.0,
                              ))
                        ],
                      ),
                    ));
              });
        } else {
          return Text("No access");
        }
      },
      future: PhotoManager.requestPermissionExtend(),
    );
  }
}
