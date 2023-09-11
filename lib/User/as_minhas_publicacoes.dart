
import 'package:cached_network_image/cached_network_image.dart';
import 'package:domus_buddies/User/as_minhas_publicacoes_service.dart';
import 'package:flutter/material.dart';
import 'package:domus_buddies/pet/post_info.dart';
import 'package:domus_buddies/upload_page.dart';
import 'package:domus_buddies/User/user_info.dart';
import 'package:provider/provider.dart';
import '../background/appbar_generic.dart';
import '../background/background_generic.dart';
import 'get_keycloack_token.dart';


class AsMinhasPublicacoes extends StatelessWidget {
  const AsMinhasPublicacoes({super.key});

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
      create: (context) => AsMinhasPubliccoesService(),
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: Consumer<AsMinhasPubliccoesService>(builder: (context, provider, child) {
          List<PostInfo> feeds = provider.feeds;
          if (feeds.isEmpty) {
            provider.fetchFeed(authToken as String, username!);
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
                  ' As minhas publicações',
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
                      //}
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


  Widget buildMedia(BuildContext context, PostInfo post) {
    if (post.filename != null) {
      var imageUrl = 'https://domusbuddies.s3.eu-central-1.amazonaws.com/${post.filename!}';
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover, // Adjust the fit based on your requirements
        placeholder: (context, url) => const PlaceholderImage(),
        errorWidget: (context, url, error) => const PlaceholderImage(), // Display this if there's an error loading the image
      );
    }
    return const PlaceholderImage();
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
                  // Handle comment tap if needed
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget buildFunnyAnimation(List<PostInfo> feeds) {
    // Determine which GIF to display based on whether there are any feeds.
    String gifAsset;
    if (feeds.isEmpty) {
      gifAsset = 'assets/Gif/astronot.gif';
    } else {
      gifAsset = 'assets/Gif/cat.gif';
    }

    return Stack(
      children: [
        // Background image with stars
        Image.asset(
          'assets/images/night.jpg',
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
  const PlaceholderImage({super.key, });

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
