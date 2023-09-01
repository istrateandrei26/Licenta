import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditGroupNameWidget extends StatefulWidget {
  const EditGroupNameWidget({
    Key? key,
    required this.handler, required this.text,
  }) : super(key: key);

  final Function(String) handler;
  final String text;

  @override
  State<EditGroupNameWidget> createState() => _EditGroupNameWidgetState();
}

class _EditGroupNameWidgetState extends State<EditGroupNameWidget> {
  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Icon(Icons.edit),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r',')),
                    ],
                    onChanged: (value) {
                      setState(() {});
                    },
                    controller: controller,
                    decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2.0, color: Colors.blue.shade200)),
                        hintText: widget.text),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: controller.text.isNotEmpty,
              child: ElevatedButton(
                  onPressed: () async {
                    await widget.handler(controller.text);

                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade400),
                  child: const Text("Confirm")),
            )
          ],
        ));
  }
}
