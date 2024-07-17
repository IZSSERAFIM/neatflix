import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:neatflix/user/user.dart';
import 'package:neatflix/utils/utils.dart';
import 'package:neatflix/widgets/widgets.dart';

class CommentList extends StatelessWidget {
  const CommentList({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
        mobile: _CommentListMobile(), desktop: _CommentListDesktop());
  }
}

class _CommentListMobile extends StatefulWidget {
  const _CommentListMobile({super.key});

  @override
  State<_CommentListMobile> createState() => _CommentListMobileState();
}

class _CommentListMobileState extends State<_CommentListMobile> {
  @override
  void initState() {
    fetchUserInfo();
    fetchComments();
    super.initState();
  }

  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  List? filedata = [];

  String? name;
  String? avatar;

  Future<void> fetchUserInfo() async {
    await getUserInfo();
    setState(() {
      name = userName;
      avatar = userAvatar;
    });
  }

  Future<void> fetchComments() async {
    var comments = await getComments();
    print("Comments: $comments");
    setState(() {
      filedata = [...?filedata, ...comments];
    });
  }

  Widget commentChild(data) {
    return ListView(
      children: [
        for (var i = 0; i < data.length; i++)
          Padding(
            padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
            child: ListTile(
              leading: GestureDetector(
                onTap: () async {
                  // Display the image in large form.
                  print("Comment Clicked");
                },
                child: Container(
                  height: 25.0,
                  width: 25.0,
                  decoration: new BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: new BorderRadius.all(Radius.circular(50))),
                  child: CircleAvatar(
                      radius: 25,
                      backgroundImage: CommentBox.commentImageParser(
                          imageURLorPath: data[i]['pic'])),
                ),
              ),
              title: Text(
                data[i]['name'],
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
              subtitle: Text(data[i]['message']),
              trailing: Text(
                  data[i]['date']
                      .toString()
                      .substring(0, 19)
                      .replaceAll('T', ' '),
                  style: TextStyle(fontSize: 5)),
            ),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Comments'),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.9,
        child: CommentBox(
          userImage:
              CommentBox.commentImageParser(imageURLorPath: '$baseURL/$avatar'),
          child: commentChild(filedata),
          labelText: 'Write a comment...',
          errorText: 'Comment cannot be blank',
          withBorder: false,
          sendButtonMethod: () {
            if (formKey.currentState!.validate()) {
              print(commentController.text);
              setState(() {
                var value = {
                  'name': name,
                  'pic': '$baseURL/$avatar',
                  'message': commentController.text,
                  'date': DateTime.now().toString().substring(0, 19),
                };
                filedata?.insert(0, value);
                // postComments(context, value);
                // fetchComments();
              });
              commentController.clear();
              FocusScope.of(context).unfocus();
            } else {
              print("Not validated");
            }
          },
          formKey: formKey,
          commentController: commentController,
          backgroundColor: Colors.transparent,
          textColor: Colors.white,
          sendWidget: Icon(Icons.send_sharp, size: 30, color: Colors.white),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            fetchComments();
          },
          icon: Icon(Icons.refresh),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}

class _CommentListDesktop extends StatefulWidget {
  @override
  _CommentListDesktopState createState() => _CommentListDesktopState();
}

class _CommentListDesktopState extends State<_CommentListDesktop> {
  @override
  void initState() {
    fetchUserInfo();
    fetchComments();
    super.initState();
  }

  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  List? filedata = [];

  String? name;
  String? avatar;

  Future<void> fetchUserInfo() async {
    await getUserInfo();
    setState(() {
      name = userName;
      avatar = userAvatar;
    });
  }

  Future<void> fetchComments() async {
    var comments = await getComments();
    print("Comments: $comments");
    setState(() {
      filedata = [...?filedata, ...comments];
    });
  }

  Widget commentChild(data) {
    return ListView(
      children: [
        for (var i = 0; i < data.length; i++)
          Padding(
            padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
            child: ListTile(
              leading: GestureDetector(
                onTap: () async {
                  // Display the image in large form.
                  print("Comment Clicked");
                },
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: new BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: new BorderRadius.all(Radius.circular(50))),
                  child: CircleAvatar(
                      radius: 50,
                      backgroundImage: CommentBox.commentImageParser(
                          imageURLorPath: data[i]['pic'])),
                ),
              ),
              title: Text(
                data[i]['name'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(data[i]['message']),
              trailing: Text(
                  data[i]['date']
                      .toString()
                      .substring(0, 19)
                      .replaceAll('T', ' '),
                  style: TextStyle(fontSize: 10)),
            ),
          )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Comments'),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height * 0.6,
        child: CommentBox(
          userImage:
              CommentBox.commentImageParser(imageURLorPath: '$baseURL/$avatar'),
          child: commentChild(filedata),
          labelText: 'Write a comment...',
          errorText: 'Comment cannot be blank',
          withBorder: false,
          sendButtonMethod: () {
            if (formKey.currentState!.validate()) {
              print(commentController.text);
              setState(() {
                var value = {
                  'name': name,
                  'pic': '$baseURL/$avatar',
                  'message': commentController.text,
                  'date': DateTime.now().toString().substring(0, 19),
                };
                filedata?.insert(0, value);
                // postComments(context, value);
                // fetchComments();
              });
              commentController.clear();
              FocusScope.of(context).unfocus();
            } else {
              print("Not validated");
            }
          },
          formKey: formKey,
          commentController: commentController,
          backgroundColor: Colors.transparent,
          textColor: Colors.white,
          sendWidget: Icon(Icons.send_sharp, size: 30, color: Colors.white),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            fetchComments();
          },
          icon: Icon(Icons.refresh),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}
