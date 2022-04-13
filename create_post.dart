import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';

class CreateCoursePage extends StatefulWidget {
  const CreateCoursePage({Key? key}) : super(key: key);

  @override
  State<CreateCoursePage> createState() => _CreateCoursePageState();
}

class _CreateCoursePageState extends State<CreateCoursePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<double> _animationTween;
  late DropzoneViewController dropZoneController;
  Uint8List? image;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 900),
      vsync: this,
    );

    _animationTween = Tween(begin: 1.0, end: 4.0).animate(
      _animationController,
    );

    _animationController.addListener(() {
      setState(() {});
    });
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 6, color: Colors.black12, spreadRadius: 6)
                  ]),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: AspectRatio(
                    aspectRatio: 1,
                    child: image != null
                        ? Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(24),
                            child: Stack(
                              children: [
                                ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    child: Image.memory(image!)),
                                Positioned(
                                  right: 16,
                                  top: 16,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        image = null;
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      width: 50,
                                      height: 50,
                                      child: Icon(Icons.close_rounded),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                margin: const EdgeInsets.all(24),
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    border: Border.all(
                                        color: Colors.blue,
                                        width: _animationTween.value)),
                                child: DropzoneView(
                                  onHover: () {
                                    if (!_animationController.isAnimating) {
                                      _animationController.forward();
                                    }
                                  },
                                  onCreated: (ctrl) =>
                                      dropZoneController = ctrl,
                                  onLeave: () {
                                    _animationController.reset();
                                    _animationController.stop(canceled: true);
                                  },
                                  operation: DragOperation.copy,
                                  cursor: CursorType.grab,
                                  onLoaded: () {},
                                  onDrop: (_) async {
                                    _animationController.reset();
                                    _animationController.stop(canceled: true);

                                    final bytes =
                                        await dropZoneController.getFileData(_);
                                    setState(() {
                                      image = bytes;
                                    });
                                  },
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                margin: const EdgeInsets.all(24),
                                padding: const EdgeInsets.all(24),
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AnimatedSwitcher(
                                      duration: Duration(milliseconds: 200),
                                      child: _animationController.isAnimating
                                          ? Text(
                                              "تصویر را رها کنید",
                                              key: ValueKey(0),
                                            )
                                          : Text("تصویر دوره به اینجا بکشید",
                                              key: ValueKey(1)),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                        "و یا از طریق دکمه زیر فایل را انتخاب کنید"),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    ElevatedButton(
                                        onPressed: () async {
                                          var result = await ImagePickerPlugin()
                                              .pickImage(
                                                  source: ImageSource.gallery);
                                          image = await result.readAsBytes();
                                          setState(() {});
                                        },
                                        child: Text("کلیلک"))
                                  ],
                                ),
                              ),
                            ],
                          ),
                  )),
                  Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  hintText: 'نام دوره',
                                  labelText: 'نام دوره'),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  hintText: 'هزینه دوره',
                                  labelText: 'هزینه دوره'),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            TextField(
                              minLines: 6,
                              maxLines: 7,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  hintText: 'توضیحات',
                                  labelText: 'توضیحات'),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.amber,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 6),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)))),
                                      onPressed: () {},
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.edit),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text("ویرایش")
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.red,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 6),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)))),
                                      onPressed: () {},
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.delete),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text("حذف")
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
