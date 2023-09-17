import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:domus_buddies/User/update_get_user_info_request.dart';
import 'package:domus_buddies/User/user_info.dart';

// Define AccessTokenProvider and UserDataProvider classes if not defined
class AccessTokenProvider with ChangeNotifier {
  String? accessToken; // Implement your logic to provide access token
}

class UserDataProvider with ChangeNotifier {
  String firstName = '';
  String lastName = '';
  String email = '';

  void updateUserData(Map<String, dynamic> userData) {
    // Implement your logic to update user data
    // Example: firstName = userData['firstName'];
    //          lastName = userData['lastName'];
    //          email = userData['email'];
    notifyListeners();
  }
}

class FetchUserData extends StatelessWidget {
  const FetchUserData({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: fetchUserData(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const YourWidget();
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

Future<void> fetchUserData(BuildContext context) async {
  final accessTokenProvider = Provider.of<AccessTokenProvider>(context, listen: false);
  String? accessToken = accessTokenProvider.accessToken;
  String? loggedInUsername = UserSession.getLoggedInUsername();

  if (accessToken != null && loggedInUsername != null) {
    try {
      Map<String, dynamic> userData = await getUserInfo(loggedInUsername, accessToken);

      final userDataProvider = Provider.of<UserDataProvider>(context, listen: false);
      userDataProvider.updateUserData(userData);

    } catch (error) {
      //print('Error fetching user data: $error');
    }
  } else {
    //print('Failed to get access token or logged-in username.');
  }
}

class YourWidget extends StatelessWidget {
  const YourWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserDataProvider>(context);

    return Column(
      children: [
        TextFormField(controller: TextEditingController(text: userData.firstName)),
        TextFormField(controller: TextEditingController(text: userData.lastName)),
        TextFormField(controller: TextEditingController(text: userData.email)),
      ],
    );
  }
}
