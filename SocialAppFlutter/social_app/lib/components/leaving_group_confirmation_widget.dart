import 'package:flutter/material.dart';
import 'package:social_app/utilities/constants.dart';

class LeavingGroupConfirmationWidget extends StatefulWidget {
  final Function handler;
  final String areYouSureText;
  final String yesText;
  final String noText;

  const LeavingGroupConfirmationWidget({
    Key? key,
    required this.handler, required this.areYouSureText, required this.yesText, required this.noText,
  }) : super(key: key);

  @override
  State<LeavingGroupConfirmationWidget> createState() =>
      _LeavingGroupConfirmationWidgetState();
}

class _LeavingGroupConfirmationWidgetState
    extends State<LeavingGroupConfirmationWidget> {
  bool isLeaving = false;

  setIsLeaving(bool value) {
    setState(() {
      isLeaving = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Text(
              widget.areYouSureText,
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 40),
              ElevatedButton(
                  onPressed: () async {
                    setIsLeaving(true);

                    await widget.handler();

                    // setIsLeaving(false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: isLeaving
                      ? const SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator.adaptive(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white)))
                      : Text(
                          widget.yesText,
                          style: TextStyle(fontSize: 12),
                        )),
              const Spacer(),
              ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Text(widget.noText, style: TextStyle(fontSize: 12))),
              const SizedBox(width: 60),
            ],
          ),
        ],
      ),
    );
  }
}
