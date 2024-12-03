import 'package:flutter/material.dart';

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: const <Widget>[
        ListTile(
          title: Text('Username'),
          subtitle: Text('zharsuke'),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
        Divider(),
        ListTile(
          title: Text('Name'),
          subtitle: Text('Al Azhar'),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
        Divider(),
        ListTile(
          title: Text('NIM'),
          subtitle: Text('2241783756'),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
        Divider(),
        ListTile(
          title: Text('Update Password'),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      ],
    );
  }
}
