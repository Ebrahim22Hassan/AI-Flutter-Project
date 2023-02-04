import 'package:flutter/material.dart';
import 'package:ml_app/constants.dart';

class TypeText extends StatelessWidget {
  const TypeText({
    Key? key,
    required List? outputs,
  })  : _outputs = outputs,
        super(key: key);

  final List? _outputs;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 84,
      child: _outputs != null
          ? Container(
              decoration: const BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    text: "${_outputs![0]["label"]}",
                    style: const TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          : Container(),
    );
  }
}
