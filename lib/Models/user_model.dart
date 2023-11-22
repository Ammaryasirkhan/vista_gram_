import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String username;
  final String photoUrl;
  final String bio;
  final List followers;
  final List following;

  const User(
      {required this.email,
      required this.username,
      required this.uid,
      required this.bio,
      required this.photoUrl,
      required this.followers,
      required this.following});
  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'email': email,
        'photoUrl': photoUrl,
        'bio': bio,
        'follower': followers,
        'following': following,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      email: snapshot['email'],
      username: snapshot['username'],
      uid: snapshot['uid'],
      bio: snapshot['bio'],
      photoUrl: snapshot['photoUrl'],
      followers:
          (snapshot['followers'] != null && snapshot['followers'] is List)
              ? (snapshot['followers'] as List<dynamic>)
              : [],
      following:
          (snapshot['following'] != null && snapshot['following'] is List)
              ? (snapshot['following'] as List<dynamic>)
              : [],
    );
  }
}
