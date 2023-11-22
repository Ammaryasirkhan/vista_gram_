// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:vista_gram_/utils/colors.dart';
// import 'package:vista_gram_/utils/dimensions.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   final TextEditingController searchcontrller = TextEditingController();
//   bool isShowUsers = false;

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     searchcontrller.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//             title: TextFormField(
//           controller: searchcontrller,
//           onFieldSubmitted: (String _) {
//             print(_);
//             setState(() {
//               isShowUsers = true;
//             });
//           },
//           decoration: InputDecoration(labelText: ' Search for A user'),
//         )),
//         body: isShowUsers
//             ? FutureBuilder(
//                 future: FirebaseFirestore.instance
//                     .collection('users')
//                     .where('username',
//                         isGreaterThanOrEqualTo: searchcontrller.text)
//                     .get(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) {
//                     return const Center(
//                       child: CircularProgressIndicator(color: ColorRes.app),
//                     );
//                   }
//                   return ListView.builder(
//                     itemCount: (snapshot.data! as dynamic).docs().length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                           leading: CircleAvatar(
//                             radius: Dimensions.height20,
//                             backgroundImage: NetworkImage(
//                                 (snapshot.data! as dynamic).docs[index]
//                                     ['photoUrl']),
//                           ),
//                           title: Text(
//                             (snapshot.data! as dynamic).docs[index]['username'],
//                           ));
//                     },
//                   );
//                 },
//               )
//             : FutureBuilder(
//                 future: FirebaseFirestore.instance.collection('posts').get(),
//                 builder: (context, snapshot) {
//                   if(!snapshot.hasData){
//                    return const CircularProgressIndicator(color: ColorRes.app,);
//                   }
// return StaggeredGridView.countBuilder(crossAxixCount: 3,
// itemCount: (snapshot.data! as dynamic).docs.length,
// itemBuilder: (context, index)=> Image.network(((snapshot.data! as dynamic).docs[index]['postUrl']),
// staggeredTileBuilder:(index)=>StaggeredGridTile.count((index%7==0)?2: Icons.crop_16_9,(index%7==0)?2:1 )
// );
//                 },
//               ));
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart'; // Add this import
import 'package:vista_gram_/Pages/HomePage/profile_screen.dart';
import 'package:vista_gram_/utils/colors.dart';
import 'package:vista_gram_/utils/dimensions.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextFormField(
            controller: searchController,
            onFieldSubmitted: (String _) {
              print(_);
              setState(() {
                isShowUsers = true;
              });
            },
            decoration: InputDecoration(labelText: 'Search for A user'),
          ),
        ),
        body: isShowUsers
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('username',
                        isGreaterThanOrEqualTo: searchController.text)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(color: ColorRes.app),
                    );
                  }
                  return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs().length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                                uid: (snapshot.data! as dynamic).docs[index]
                                    ['uid']),
                          ),
                        ),
                        child: ListTile(
                            leading: CircleAvatar(
                              radius: Dimensions.height20,
                              backgroundImage: NetworkImage(
                                  (snapshot.data! as dynamic).docs[index]
                                      ['photoUrl']),
                            ),
                            title: Text(
                              (snapshot.data! as dynamic).docs[index]
                                  ['username'],
                            )),
                      );
                    },
                  );
                },
              )
            : FutureBuilder(
                future: FirebaseFirestore.instance.collection('posts').get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: CircularProgressIndicator(color: ColorRes.app));
                  }

                  return StaggeredGrid.count(
                    crossAxisCount: 3,
                    children: List.generate(
                      (snapshot.data! as dynamic).docs.length,
                      (index) {
                        return GestureDetector(
                          onTap: () {
                            // Handle item tap
                          },
                          child: Image.network(
                            ((snapshot.data! as dynamic).docs[index]
                                ['postUrl']),
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  );
                },
              ));
  }
}
