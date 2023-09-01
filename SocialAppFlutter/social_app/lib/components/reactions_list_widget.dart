import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../Models/user.dart';

class ReactionsListWidget extends StatefulWidget {
  const ReactionsListWidget({super.key, required this.usersWhoReacted});

  final List<User> usersWhoReacted;

  @override
  State<ReactionsListWidget> createState() => _ReactionsListWidgetState();
}

class _ReactionsListWidgetState extends State<ReactionsListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const SizedBox(height: 10),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: ListView.builder(
                  itemCount: widget.usersWhoReacted.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => ListTile(
                        horizontalTitleGap: 30,
                        trailing: SizedBox(width: 15, height: 15, child: Image.asset("assets/icons/medal.png")),
                        title:
                            Text("${widget.usersWhoReacted[index].firstname} ${widget.usersWhoReacted[index].lastname}"),
                        leading: widget.usersWhoReacted[index].profileImage == null ?
                          CircleAvatar(
                                      backgroundColor: Colors.grey.shade700,
                                      child: const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 30.0,
                                      ),
                                    )
                          :
                          CircleAvatar(
                            backgroundImage: 
                                MemoryImage(Uint8List.fromList(
                                    widget.usersWhoReacted[index].profileImage!))
                                
                          ),
                  )),
            ),
          ],
        ));
  }
}
