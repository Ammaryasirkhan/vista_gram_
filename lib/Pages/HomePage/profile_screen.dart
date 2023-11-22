import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vista_gram_/FUNCTIONS/auth_method.dart';
import 'package:vista_gram_/FUNCTIONS/firestore_methods.dart';
import 'package:vista_gram_/Pages/login_page.dart';
import 'package:vista_gram_/utils/colors.dart';
import 'package:vista_gram_/utils/dimensions.dart';
import 'package:vista_gram_/utils/show_snack_bar.dart';

import '../../widgets/button/follow_widget.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLength = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var profileSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      //posts numbers

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      postLength = postSnap.docs.length;

      userData = profileSnap.data()!;
      followers = profileSnap.data()!['followers'].length;
      following = profileSnap.data()!['following'].length;
      isFollowing = profileSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: const CircularProgressIndicator(
            color: ColorRes.app,
          ))
        : Scaffold(
            appBar: AppBar(title: Text(userData['username'])),
            body: ListView(children: [
              Padding(
                padding: EdgeInsets.all(Dimensions.height15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: Dimensions.height40,
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(userData['photoUrl']),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  buildStatColumn(postLength, 'posts'),
                                  buildStatColumn(followers, 'followers'),
                                  buildStatColumn(following, 'following')
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  FirebaseAuth.instance.currentUser!.uid ==
                                          widget.uid
                                      ? FollowButton(
                                          backgroundColor: Colors.black,
                                          borderColor: Colors.grey,
                                          text: 'Log Out',
                                          textColor: Colors.white,
                                          function: () async {
                                            await Auth().signOut();
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const LoginPage()));
                                          })
                                      : isFollowing
                                          ? FollowButton(
                                              backgroundColor: ColorRes.app,
                                              borderColor: Colors.grey,
                                              text: 'Unfollow',
                                              textColor: Colors.black,
                                              function: () async {
                                                await FireStoreMethods()
                                                    .followUser(
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid,
                                                        userData['uid']);
                                                setState(() {
                                                  isFollowing = true;
                                                  followers--;
                                                });
                                              },
                                            )
                                          : FollowButton(
                                              backgroundColor: Colors.blue,
                                              borderColor: Colors.grey,
                                              text: 'Follow',
                                              textColor: Colors.white,
                                              function: () async {
                                                await FireStoreMethods()
                                                    .followUser(
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                  userData['uid'],
                                                );
                                                setState(() {
                                                  isFollowing = true;
                                                  followers++;
                                                });
                                              },
                                            ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: Dimensions.height15),
                      child: Text(
                        userData['username'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: Dimensions.height3),
                      child: Text(userData['bio']),
                    )
                  ],
                ),
              ),
              Divider(),
              FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('posts')
                    .where('uid', isEqualTo: widget.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: ColorRes.app,
                    ));
                  }
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1,
                        crossAxisCount: 3,
                        crossAxisSpacing: Dimensions.height5,
                        mainAxisSpacing: 1.5),
                    shrinkWrap: true,
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot snap =
                          (snapshot.data! as dynamic).docs[index];
                      return Container(
                        child: Image(
                          image: NetworkImage(snap['postUrl']),
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  );
                },
              )
            ]),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: TextStyle(
              fontSize: Dimensions.height20, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: Dimensions.height5),
          child: Text(
            label,
            style: TextStyle(
                fontSize: Dimensions.height15,
                fontWeight: FontWeight.w400,
                color: Colors.grey),
          ),
        )
      ],
    );
  }
}
