import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vista_gram_/FUNCTIONS/firestore_methods.dart';
import 'package:vista_gram_/Models/user_model.dart';
import 'package:vista_gram_/utils/colors.dart';
import 'package:vista_gram_/utils/dimensions.dart';

import '../../Providers/user_provider.dart';
import 'comment_card.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({super.key, required this.snap});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentcontroller = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postId'])
            .collection('comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: ColorRes.app,
            ));
          }
          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context, index) => CommentCard(
              snap: (snapshot.data! as dynamic).docs[index].data(),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin: EdgeInsets.symmetric(vertical: Dimensions.height5),
        padding: EdgeInsets.only(
            left: Dimensions.height15, right: Dimensions.height8),
        child: Row(children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user.photoUrl),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  left: Dimensions.height15, right: Dimensions.height8),
              child: TextField(
                controller: _commentcontroller,
                decoration:
                    InputDecoration(hintText: 'Comment as ${user.username}'),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              await FireStoreMethods().postComment(
                  widget.snap['postId'],
                  _commentcontroller.text,
                  user.uid,
                  user.username,
                  user.photoUrl);
              setState(() {
                _commentcontroller.text = "";
              });
            },
            child: Container(
              padding: EdgeInsets.all(Dimensions.height8),
              child: const Text(
                'Post',
                style: TextStyle(color: ColorRes.button),
              ),
            ),
          )
        ]),
      )),
    );
  }
}
