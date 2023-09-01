import 'package:flutter/material.dart';

class LocationListTile extends StatelessWidget {
  const LocationListTile({super.key, required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          horizontalTitleGap: 0,
          leading: const Icon(Icons.location_on_outlined),
          title: Text(
            location,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Divider(
          height: 2,
          thickness: 2,
          color: Colors.grey.shade300,
        )
      ],
    );
  }
}
