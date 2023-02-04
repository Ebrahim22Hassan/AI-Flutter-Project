import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ml_app/Components/header_widget.dart';
import 'package:ml_app/Components/type_widget.dart';
import 'dart:io';
import 'package:tflite/tflite.dart';
import '../constants.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List? _outputs;
  File? image;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loading = true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderWidget(),
                buttonsAndImage(context),
                TypeText(outputs: _outputs),
              ],
            ),
          );
  }

  Padding buttonsAndImage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: kDefaultPadding * 3),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: kDefaultPadding * 3),
                child: Column(
                  children: <Widget>[
                    // Align(
                    //   alignment: Alignment.topLeft,
                    //   child: IconButton(
                    //     padding: const EdgeInsets.symmetric(
                    //         horizontal: kDefaultPadding),
                    //     icon: const Icon(Icons.arrow_back),
                    //     onPressed: () {
                    //       Navigator.pop(context);
                    //     },
                    //   ),
                    // ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.topCenter,
                      child: buttonWidget(
                          context: context,
                          icon: Icons.image,
                          source: ImageSource.gallery),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: buttonWidget(
                          context: context,
                          icon: Icons.camera,
                          source: ImageSource.camera),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.70,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(63),
                  bottomLeft: Radius.circular(63),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 10),
                    blurRadius: 60,
                    color: kPrimaryColor.withOpacity(0.29),
                  ),
                ],
              ),
              child: image == null
                  ? Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.fill,
                          image: AssetImage("assets/images/img.png"),
                        ),
                      ),
                    )
                  : Image.file(
                      image!,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future pickImage(ImageSource source) async {
    var saveImg = await ImagePicker().getImage(source: source);
    if (saveImg == null) return null;

    setState(() {
      _loading = true;
      image = File(saveImg.path);
    });
    Image.file(image!);
    classifyImage(image!);
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _loading = false;
      _outputs = output!;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  GestureDetector buttonWidget(
      {required BuildContext context,
      required ImageSource source,
      required IconData icon}) {
    return GestureDetector(
      onTap: () {
        pickImage(source);
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.03),
        padding: const EdgeInsets.all(kDefaultPadding / 2),
        height: 62,
        width: 62,
        decoration: BoxDecoration(
          color: kBackgroundColor,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 15),
              blurRadius: 22,
              color: kPrimaryColor.withOpacity(0.22),
            ),
            const BoxShadow(
              offset: Offset(-15, -15),
              blurRadius: 20,
              color: Colors.white,
            ),
          ],
        ),
        child: Icon(icon),
      ),
    );
  }
}
