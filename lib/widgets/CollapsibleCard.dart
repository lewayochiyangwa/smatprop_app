import 'package:flutter/material.dart';

class ExpandedTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      elevation: 2,
      margin: EdgeInsets.all(12.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ExpansionTile(
          backgroundColor: Colors.white,
          title: _buildTitle(),
          trailing: SizedBox(),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Text("leroy"),
                  Spacer(),
                  Icon(Icons.check),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Text("chiyaz"),
                  Spacer(),
                  Icon(Icons.check),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text("MODUL 1"),
            Spacer(),
            Text("Mehr"),
          ],
        ),
        Text("Kursubersicht"),
        Row(
          children: <Widget>[
            Text("6 Aufgaben"),
            Spacer(),
            ElevatedButton(
    child:Text("Starten"),
                onPressed: (){}),

          ],
        ),
      ],
    );
  }
}