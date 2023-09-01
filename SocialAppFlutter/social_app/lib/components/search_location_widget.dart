import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchLocationWidget extends StatefulWidget {
  const SearchLocationWidget(
      {super.key, required this.handler, required this.availableCities});

  final Function(String) handler;
  final List<String> availableCities;

  @override
  State<SearchLocationWidget> createState() => _SearchLocationWidgetState();
}

class _SearchLocationWidgetState extends State<SearchLocationWidget> {
  String _selectedCity = '';

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
              child: Icon(Icons.location_city),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: ListView.builder(
                  itemCount: widget.availableCities.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => RadioListTile(
                        title: Text(widget.availableCities[index]),
                        value: widget.availableCities[index],
                        groupValue: _selectedCity,
                        onChanged: (value) {
                          setState(() {
                            _selectedCity = value!;
                          });
                        },
                      )),
            ),
            Visibility(
              visible: _selectedCity.isNotEmpty,
              child: ElevatedButton(
                  onPressed: () {
                    widget.handler(_selectedCity);

                    // print(_selectedCity);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade400),
                  child: Text(AppLocalizations.of(context)!.conversation_details_view_confirm_text)),
            )
          ],
        ));
  }
}
