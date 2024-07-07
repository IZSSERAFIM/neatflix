import 'package:flutter/material.dart';
import 'package:neatflix/screens/screens.dart';
import 'package:neatflix/widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: _ProfileScreenMobile(),
      desktop: _ProfileScreenDesktop(),
    );
  }
}

class _ProfileScreenMobile extends StatefulWidget {
  const _ProfileScreenMobile({super.key});

  @override
  State<_ProfileScreenMobile> createState() => _ProfileScreenMobileState();
}

class _ProfileScreenMobileState extends State<_ProfileScreenMobile> {
  _header(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(
              'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'),
        ),
        SizedBox(height: 10),
        Text(
          'John Doe',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          '[email protected]',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  _logout(BuildContext context) {
    return Column(
      children: [
        Divider(),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout'),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 50.0),
        child: CustomAppBar(
          isSearch: true,
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _header(context),
            _logout(context),
          ],
        ),
      ),
    );
  }
}

class _ProfileScreenDesktop extends StatefulWidget {
  const _ProfileScreenDesktop({super.key});

  @override
  State<_ProfileScreenDesktop> createState() => _ProfileScreenDesktopState();
}

class _ProfileScreenDesktopState extends State<_ProfileScreenDesktop> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 50.0),
        child: CustomAppBar(
          isSearch: true,
        ),
      ),
      body: Container(),
    );
  }
}
