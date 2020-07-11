import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ImageUploaderView extends StatefulWidget {
  @override
  _ImageUploaderViewState createState() => _ImageUploaderViewState();
}

class _ImageUploaderViewState extends State<ImageUploaderView> {
  static const MAX_IMAGES = 6;
  List<Asset> images = List<Asset>();
  int availableImages = MAX_IMAGES;
//  final _picker = ImagePicker();

//  Future getImages() async{
//    PickedFile file = await _picker.getImage(source: ImageSource.gallery);
//
//  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> getImages() async {
    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: availableImages,
        enableCamera: true,
      );
    } on Exception catch (e) {
      error = e.toString();
      print('error: ' + error);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images.addAll(resultList);
      availableImages -= resultList.length;
    });
    print('available images: ' + availableImages.toString());
    for (Asset image in images) {
      print(image.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildGridView();
  }

  Widget buildGridView() {
    print(availableImages);
    print(images.length);
    if (images != null) {
      print('entre1');
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1,
        shrinkWrap: true,
        children: List.generate(MAX_IMAGES, (index) {
          if ((MAX_IMAGES - availableImages) > index) {
            return Card(
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: <Widget>[
                  AssetThumb(
                    asset: images[index],
                    height: 300,
                    width: 300,
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: InkWell(
                      child: Icon(Icons.remove_circle,
                          size: 20, color: Colors.red),
                      onTap: () {
                        setState(() {
                          images.removeAt(index);
                          availableImages++;
                          for (Asset image in images) {
                            print(image.toString());
                          }
                        });
                      },
                    ),
                  )
                ],
              ),
            );
          } else {
            print('entre');
            return Card(
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  getImages();
                },
              ),
            );
          }
        }),
      );
    } else {
      return Container();
    }
  }
}
