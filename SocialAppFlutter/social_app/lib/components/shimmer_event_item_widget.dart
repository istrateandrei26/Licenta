import 'package:flutter/material.dart';
import 'package:social_app/components/shimmer_widget.dart';

class ShimmerEventItemWidget extends StatelessWidget {
  const ShimmerEventItemWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.symmetric(vertical: 20),
        elevation: 15,
        color: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: ShimmerWidget.rectangular(height: 150)
                  ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const ShimmerWidget.rectangular(height: 14),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: const <Widget>[
                              Flexible(
                                child: ShimmerWidget.rectangular(height: 10)
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ShimmerWidget.rectangular(height: 10, width: MediaQuery.of(context).size.width  * 0.1,),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
  }
}
