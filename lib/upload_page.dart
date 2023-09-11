import 'dart:typed_data';

import 'package:domus_buddies/pet/post_info.dart';
import 'package:domus_buddies/services/feed_services.dart';
import 'package:domus_buddies/User/user_info.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:domus_buddies/background/appbar_generic.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'User/as_minhas_publicacoes.dart';
import 'User/get_keycloack_token.dart';
import 'background/background_generic.dart';
class UploadPage extends StatefulWidget {
  UploadPage({Key? key}) : super(key: key);

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  XFile? _selectedFile;
  TextEditingController _textController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedFile = pickedFile;
      });
    }
  }

  Future<List<int>> getListBytesOfFile() async {
    Uint8List uint8list = await _selectedFile!.readAsBytes();
    return uint8list.toList();
  }

  Future<bool> _publish(String username, String token) async {
    var message = _textController.text;

    // Add error handling here if _selectedFile is null or other issues occur.

    PostInfo postInfo = PostInfo(
      message: message,
      publishDate: DateTime.now(),
      username: username,
      userLiked: [],
      fileInBytes: await getListBytesOfFile(),
      comments: [],
    );

    bool uploadSuccessful = await FeedServices().publishPost(
        token, postInfo, File(_selectedFile!.path));

    return uploadSuccessful;
  }

  @override
  Widget build(BuildContext context) {
    final accessTokenProvider =
    Provider.of<FetchUserData>(context, listen: false);
    final authToken = accessTokenProvider.accessToken;
    String? loggedInUsername = UserSession.getLoggedInUsername();

    return Scaffold(
      appBar: CustomAppBar(), // Replace with your app bar widget.
      body: GradientBackground(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Publicar',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                  fontFamily: 'Handwritten',
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: _pickImage,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: _selectedFile != null
                            ? Image.file(
                          File(_selectedFile!.path),
                          fit: BoxFit.cover,
                        )
                            : DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(12.0),
                          padding: const EdgeInsets.all(16.0),
                          strokeWidth: 2.5,
                          dashPattern: const [6, 6],
                          color: Colors.white60,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 110.0),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.add_a_photo,
                              size: 50.0,
                              color: Colors.white60,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _textController,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: "Escreve a tua descrição aqui...",
                        labelStyle: TextStyle(color: Colors.pink),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.pink, width: 2.0),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.white, width: 2.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        bool uploadSuccessful =
                        await _publish(loggedInUsername!, authToken!);
                        if (uploadSuccessful) {
                          // Navigate to the other page after a successful upload.
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AsMinhasPublicacoes(),
                            ),
                          );
                        } else {
                          // Handle the case where the upload was not successful.
                          // You can show an error message or take appropriate action here.
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text("Publicar"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}