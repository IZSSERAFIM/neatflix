import 'package:flutter/material.dart';
import 'package:neatflix/screens/screens.dart';
import 'package:neatflix/user/user_info.dart';
import 'package:neatflix/widgets/widgets.dart';
import 'package:neatflix/user/user.dart';
import 'package:neatflix/utils/utils.dart';
import 'package:neatflix/cubits/cubits.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AvatarCubit()..fetchAvatar(),
      child: Responsive(
        mobile: _ProfileScreenMobile(),
        desktop: _ProfileScreenDesktop(),
      ),
    );
  }
}

class _ProfileScreenMobile extends StatefulWidget {
  const _ProfileScreenMobile({super.key});

  @override
  State<_ProfileScreenMobile> createState() => _ProfileScreenMobileState();
}

class _ProfileScreenMobileState extends State<_ProfileScreenMobile> {
  late Future<List<dynamic>> _combinedFutures;

  @override
  void initState() {
    super.initState();
    _combinedFutures = Future.wait([
      getUserInfo(),
    ]);
    context.read<AvatarCubit>().fetchAvatar();
  }

  void _showEditDialog(BuildContext context) {
    final _nameController = TextEditingController(text: userName);
    final _emailController = TextEditingController(text: userEmail);

    final _formKey = GlobalKey<FormState>(); // Step 1

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: Form(
            // Step 2
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    icon: Icon(Icons.person),
                  ),
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    icon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email cannot be empty';
                    }
                    String pattern =
                        r'^[a-zA-Z0-9._]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
                    RegExp regex = RegExp(pattern);
                    if (!regex.hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Step 3
                  // If the form is valid, proceed to update user info
                  updateUserInfo(
                    context,
                    newName: _nameController.text,
                    newEmail: _emailController.text,
                  ).then((_) {
                    setState(() {
                      userName = _nameController.text;
                      userEmail = _emailController.text;
                    });
                    Navigator.of(context).pop();
                  });
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 50.0),
        child: CustomAppBar(
          isProfile: true,
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _combinedFutures,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var combinedData = snapshot.data!;
            var userData = combinedData[0];

            return BlocBuilder<AvatarCubit, String>(
              builder: (context, userAvatar) {
                return Container(
                  margin: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final newAvatar = await getRandomAvatar();
                              context.read<AvatarCubit>().emit(newAvatar);
                            },
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(userAvatar),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            userName,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.email, color: Colors.grey),
                              SizedBox(width: 8),
                              Text(
                                userEmail,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              isVip
                                  ? Icon(Icons.verified, color: Colors.grey)
                                  : Icon(Icons.cancel, color: Colors.grey),
                              SizedBox(width: 8),
                              Text(
                                isVip ? 'VIP Member' : 'Regular Member',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.edit),
                            title: Text('Edit Profile'),
                            onTap: () => _showEditDialog(context),
                          ),
                          ListTile(
                            leading: Icon(Icons.verified),
                            title: Text('Get VIP Membership'),
                            onTap: () async {
                              await getVip(context);
                              setState(() {
                                isVip = true;
                              });
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.cancel),
                            title: Text('Cancel VIP Membership'),
                            onTap: () async {
                              await cancelVip(context);
                              setState(() {
                                isVip = false;
                              });
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.logout),
                            title: Text('Logout'),
                            onTap: () async {
                              await Logout(context);
                              token = userEmail = userName = userAvatar = "";
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return Container(); // Fallback for unexpected state
        },
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
  late Future<List<dynamic>> _combinedFutures;

  @override
  void initState() {
    super.initState();
    _combinedFutures = Future.wait([
      getUserInfo(),
    ]);
    context.read<AvatarCubit>().fetchAvatar();
  }

  void _showEditDialog(BuildContext context) {
    final _nameController = TextEditingController(text: userName);
    final _emailController = TextEditingController(text: userEmail);

    final _formKey = GlobalKey<FormState>(); // Step 1

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: Form(
            // Step 2
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    icon: Icon(Icons.person),
                  ),
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    icon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email cannot be empty';
                    }
                    String pattern =
                        r'^[a-zA-Z0-9._]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
                    RegExp regex = RegExp(pattern);
                    if (!regex.hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Step 3
                  // If the form is valid, proceed to update user info
                  updateUserInfo(
                    context,
                    newName: _nameController.text,
                    newEmail: _emailController.text,
                  ).then((_) {
                    setState(() {
                      userName = _nameController.text;
                      userEmail = _emailController.text;
                    });
                    Navigator.of(context).pop();
                  });
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 50.0),
        child: CustomAppBar(
          isProfile: true,
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _combinedFutures,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var combinedData = snapshot.data!;
            var userData = combinedData[0];

            return BlocBuilder<AvatarCubit, String>(
              builder: (context, userAvatar) {
                return Container(
                  margin: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final newAvatar = await getRandomAvatar();
                              context.read<AvatarCubit>().emit(newAvatar);
                            },
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(userAvatar),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            userName,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.email, color: Colors.grey),
                              SizedBox(width: 8),
                              Text(
                                userEmail,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              isVip
                                  ? Icon(Icons.verified, color: Colors.grey)
                                  : Icon(Icons.cancel, color: Colors.grey),
                              SizedBox(width: 8),
                              Text(
                                isVip ? 'VIP Member' : 'Regular Member',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Divider(),
                            ),
                          ),
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: ListTile(
                                leading: Icon(Icons.edit),
                                title: Text('Edit Profile'),
                                onTap: () => _showEditDialog(context),
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: ListTile(
                                leading: Icon(Icons.verified),
                                title: Text('Get VIP Membership'),
                                onTap: () async {
                                  await getVip(context);
                                  setState(() {
                                    isVip = true;
                                  });
                                },
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: ListTile(
                                leading: Icon(Icons.cancel),
                                title: Text('Cancel VIP Membership'),
                                onTap: () async {
                                  await cancelVip(context);
                                  setState(() {
                                    isVip = false;
                                  });
                                },
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: ListTile(
                                leading: Icon(Icons.logout),
                                title: Text('Logout'),
                                onTap: () async {
                                  await Logout(context);
                                  token =
                                      userEmail = userName = userAvatar = "";
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return Container(); // Fallback for unexpected state
        },
      ),
    );
  }
}
