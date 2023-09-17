import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:domus_buddies/pet/post_info.dart';
import 'package:domus_buddies/services/feed_services.dart';
import 'package:domus_buddies/upload_page.dart';
import 'package:domus_buddies/User/user_info.dart';
import 'package:provider/provider.dart';
import 'User/get_keycloack_token.dart';
import 'background/appbar_generic.dart';
import 'background/background_generic.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class NovidadesPage extends StatelessWidget {
  const NovidadesPage({super.key,});

  Widget buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final username = UserSession.loggedInUsername;
    final accessTokenProvider = Provider.of<FetchUserData>(context, listen: false);
    final authToken = accessTokenProvider.accessToken;

    return ChangeNotifierProvider(
      create: (context) => FeedServices(),
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: Consumer<FeedServices>(builder: (context, provider, child) {
          List<PostInfo> feeds = provider.feeds;
          if (feeds.isEmpty) {
            provider.fetchFeed(authToken as String, 10, 0);
            return buildFunnyAnimation(feeds);
          } else {
            return buildFeedList(context, feeds);
          }
        }),
      ),
    );
  }

  Widget buildFeedList(BuildContext context, List<PostInfo> feeds) {
    return Stack(
      children: [
        GradientBackground(
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  ' Novidades',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                    fontFamily: 'Handwritten',
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: feeds.length,
                    itemBuilder: (context, index) {
                      return buildPostSection(context, feeds.elementAt(index));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            backgroundColor: Colors.pink,
            elevation: 5.0,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UploadPage()),
              );
            },
            child: const Icon(Icons.add_a_photo_outlined, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget buildPostSection(BuildContext context, PostInfo post) {
    return buildMediaSection(context, post);
  }

  Future<Uint8List> resizeImage(Uint8List imageBytes, double width, double height) async {
    final image = img.decodeImage(imageBytes)!;
    final resizedImage = img.copyResize(image, width: width.toInt(), height: height.toInt());
    final resizedBytes = img.encodePng(resizedImage);
    return Uint8List.fromList(resizedBytes);
  }

  Widget buildMedia(BuildContext context, PostInfo post) {
    if (post.filename != null) {
      final imageUrl = 'https://domusbuddies.s3.eu-central-1.amazonaws.com/${post.filename!}';
      return CachedNetworkImage(
        imageUrl: imageUrl,
        placeholder: (context, url) => const PlaceholderImage(),
        errorWidget: (context, url, error) => const PlaceholderImage(), // Handle error gracefully
        fit: BoxFit.cover, // You can adjust this as needed
      );
    }
    return const PlaceholderImage();
  }

  Future<Uint8List> fetchAndResizeImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      final originalBytes = response.bodyBytes;
      // Resize the image to your desired dimensions (e.g., 200x200)
      final resizedBytes = await resizeImage(originalBytes, 200, 200);
      return resizedBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }

  Widget buildMediaSection(BuildContext context, PostInfo post) {
    return Card(
      color: Colors.transparent,
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: buildMedia(context, post),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Row(
                children: [
                  const Icon(Icons.favorite_outline_sharp, color: Colors.pink),
                  const SizedBox(width: 4),
                  Text(
                    '${post.userLiked.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.comment_outlined, color: Colors.pink),
                    onPressed: () {
                      _showListBottomSheet(context, post.comments);
                    },
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${post.comments.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showListBottomSheet(BuildContext context, List<CommentInfo> comments) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.pink,
          child: ListView.builder(
            itemCount: comments.length,
            itemBuilder: (BuildContext context, int index) {
              String comment = comments.elementAt(index).message;
              return ListTile(
                tileColor: Colors.white,
                title: Text(
                  comment,
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget buildFunnyAnimation(List<PostInfo> feeds) {
    String gifAsset;
    if (feeds.isEmpty) {
      gifAsset = 'assets/Gif/cat.gif';
    } else {
      gifAsset = 'assets/Gif/cat.gif';
    }

    return Stack(
      children: [
        Image.asset(
          'assets/images/garden.jpg',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        // Loading GIF
        Center(
          child: Image.asset(
            gifAsset,
            height: 200,
          ),
        ),
      ],
    );
  }
}

class PlaceholderImage extends StatelessWidget {
  const PlaceholderImage({super.key,});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.image,
      size: 150,
      color: Colors.pink,
    );
  }
}

enum FileType {
  image,
  video,
  unknown,
}
