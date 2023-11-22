import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vista_gram_/utils/colors.dart';
import 'package:vista_gram_/utils/dimensions.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({super.key, required this.snap});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.height20, vertical: Dimensions.height15),
      child: Row(children: [
        CircleAvatar(
          backgroundImage: NetworkImage(widget.snap['porfilePic']),
          radius: 18,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: Dimensions.height15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: widget.snap['name'],
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: ' ${widget.snap['text']}',
                    )
                  ]),
                ),
                Padding(
                  padding: EdgeInsets.only(top: Dimensions.height5),
                  child: Text(DateFormat.yMMMd()
                      .format((widget.snap['datePublished'].toDate()))),
                ),
                Padding(
                  padding: EdgeInsets.only(left: Dimensions.height12),
                  child: Container(
                    child: Icon(
                      Icons.favorite,
                      color: ColorRes.app,
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ]),
    );
  }
}
