import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vista_gram_/FUNCTIONS/firestore_methods.dart';
import 'package:vista_gram_/Pages/HomePage/comment_screen.dart';
import 'package:vista_gram_/Providers/user_provider.dart';
import 'package:vista_gram_/utils/colors.dart';
import 'package:vista_gram_/utils/dimensions.dart';
import 'package:vista_gram_/utils/show_snack_bar.dart';
import 'package:vista_gram_/widgets/Texts/big_text.dart';
import 'package:vista_gram_/widgets/animation.dart';

import '../../Models/user_model.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLenght = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();

      commentLenght = snap.docs.length;
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: Dimensions.height20),
      child: Column(children: [
        Container(
          padding: EdgeInsets.symmetric(
                  vertical: Dimensions.height5, horizontal: Dimensions.height15)
              .copyWith(right: 0),
          child: Row(children: [
            CircleAvatar(
              radius: Dimensions.height20,
              backgroundImage: NetworkImage(widget.snap['profImage']),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: Dimensions.height8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BigText(
                      text: widget.snap['username'],
                      color: ColorRes.app,
                    )
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    backgroundColor: ColorRes.app,
                    child: ListView(
                        padding:
                            EdgeInsets.symmetric(vertical: Dimensions.height15),
                        shrinkWrap: true,
                        children: ['Delete']
                            .map((e) => InkWell(
                                  onTap: () async {
                                    await FireStoreMethods()
                                        .deletePost(widget.snap['postId']);
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Dimensions.height10),
                                    child: Text(e),
                                  ),
                                ))
                            .toList()),
                  ),
                );
              },
              icon: Icon(Icons.more_vert, color: ColorRes.app),
            )
          ]),
        ),
        GestureDetector(
          onDoubleTap: () async {
            await FireStoreMethods().likePost(
                widget.snap['postId'], user.uid, widget.snap['likes']);
            setState(() {
              isLikeAnimating = true;
            });
          },
          child: Stack(alignment: Alignment.center, children: [
            SizedBox(
              height: Dimensions.height30 * 8,
              width: double.maxFinite,
              child: Image.network(
                widget.snap['postUrl'],
                fit: BoxFit.cover,
              ),
            ),
            AnimatedOpacity(
              duration: Duration(milliseconds: 200),
              opacity: isLikeAnimating ? 1 : 0,
              child: LikeAnimation(
                child: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 100,
                ),
                isAnimation: isLikeAnimating,
                duration: const Duration(microseconds: 400),
                onEnd: () {
                  setState(() {
                    isLikeAnimating = false;
                  });
                },
              ),
            )
          ]),
        ),
        //Likes Comments Section

        Row(
          children: [
            LikeAnimation(
              isAnimation: widget.snap['likes'].contains(user.uid),
              smallLike: true,
              child: IconButton(
                icon: widget.snap['likes'].contains(user.uid)
                    ? const Icon(
                        Icons.favorite_border,
                        color: ColorRes.app,
                      )
                    : Icon(Icons.favorite_border, color: ColorRes.app),
                onPressed: () async {
                  await FireStoreMethods().likePost(
                      widget.snap['postId'], user.uid, widget.snap['likes']);
                },
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.comment_outlined,
                color: ColorRes.app,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.send,
                color: ColorRes.app,
              ),
              onPressed: () {},
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: Icon(
                    Icons.bookmark_outline,
                    color: ColorRes.app,
                  ),
                  onPressed: () {},
                ),
              ),
            )
          ],
        ),
        //Description

        Container(
          padding: EdgeInsets.symmetric(
              vertical: Dimensions.height10, horizontal: Dimensions.height10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BigText(
                text: '${widget.snap['likes'].length}',
                color: ColorRes.app,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: Dimensions.height12),
                child: RichText(
                    text: TextSpan(
                        style: TextStyle(color: ColorRes.app),
                        children: [
                      TextSpan(
                        text: widget.snap['username'],
                        style: TextStyle(color: ColorRes.app),
                      ),
                      TextSpan(
                        text: ' ${widget.snap['description']}',
                        style: TextStyle(color: ColorRes.app.withOpacity(0.7)),
                      ),
                    ])),
              ),
              InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CommentScreen(snap: widget.snap),
                )),
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: Dimensions.height5),
                    child: Text(
                      'View all $commentLenght comments',
                      style: TextStyle(color: ColorRes.app.withOpacity(0.6)),
                    )),
              ),
              Container(
                  padding: EdgeInsets.symmetric(vertical: Dimensions.height5),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: TextStyle(color: ColorRes.app.withOpacity(0.6)),
                  )),
            ],
          ),
        )
      ]),
    );
  }
}
