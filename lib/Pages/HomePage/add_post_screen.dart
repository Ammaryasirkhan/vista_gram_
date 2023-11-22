import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vista_gram_/FUNCTIONS/firestore_methods.dart';
import 'package:vista_gram_/FUNCTIONS/storage_mthods.dart';
import 'package:vista_gram_/utils/show_snack_bar.dart';

import '../../Models/user_model.dart';
import '../../Providers/user_provider.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../utils/image_picker.dart';
import '../../widgets/Texts/big_text.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _descriptioncontroller = TextEditingController();
  bool _isLoading = false;
  void postImage(
    String uid,
    String username,
    String profImage,
  ) async {
    setState(() {
      _isLoading = true;
    });

    try {
      String response = await FireStoreMethods().uploadPost(
        _descriptioncontroller.text,
        _file!,
        uid,
        username,
        profImage,
      );
      if (response == 'success') {
        setState(() {
          _isLoading = false;
        });

        showSnackBar('Posted', context);
        clearImage();
      } else {
        showSnackBar(response, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _descriptioncontroller.dispose();
  }

  Uint8List? _file;
  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: BigText(text: 'Create a post'),
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.all(Dimensions.height20),
                child: BigText(text: 'Take a photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: EdgeInsets.all(Dimensions.height20),
                child: BigText(text: 'choose from gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                  padding: EdgeInsets.all(Dimensions.height20),
                  child: BigText(text: 'cancel'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Center(
            child: CircleAvatar(
              radius: 35,
              child: IconButton(
                icon: Icon(
                  Icons.post_add,
                  color: ColorRes.white,
                ),
                onPressed: () {
                  print("Post Add Icon Clicked"); // Add this line
                  _selectImage(context);
                },
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: clearImage,
              ),
              title: BigText(text: 'Post to'),
              centerTitle: false,
              actions: [
                TextButton(
                  child: BigText(
                    text: 'post',
                    color: ColorRes.app,
                  ),
                  onPressed: () =>
                      postImage(user.uid, user.username, user.photoUrl),
                )
              ],
            ),
            body: Column(

                // mainAxisAlignment: MainAxisAlignment.st,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _isLoading
                      ? const LinearProgressIndicator(
                          color: ColorRes.app,
                        )
                      : Padding(
                          padding: EdgeInsets.only(top: 1),
                        ),
                  Divider(
                    color: ColorRes.app,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                          radius: 33,
                          backgroundImage: NetworkImage(user.photoUrl)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        // height: Dimensions.height45,
                        child: TextField(
                          controller: _descriptioncontroller,
                          decoration: InputDecoration(
                            hintText: 'write a caption...',
                            border: InputBorder.none,
                          ),
                          maxLines: 8,
                        ),
                      ),
                      SizedBox(
                        width: 45,
                        height: 45,
                        child: AspectRatio(
                          aspectRatio: 487 / 451,
                          child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: MemoryImage(_file!),
                                      fit: BoxFit.fill,
                                      alignment: FractionalOffset.topCenter))),
                        ),
                      )
                    ],
                  ),
                  Divider(),
                ]),
          );
  }
}
