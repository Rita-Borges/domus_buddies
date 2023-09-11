import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../feed_page.dart';
import '../home_page.dart';
import '../services/sevicos.dart';
import '../pet/new_adoption.dart';
import '../User/update_perfil.dart';
import '../User/as_minhas_publicacoes.dart';
import '../pet/pet_list.dart';


class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  CustomAppBarState createState() => CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomAppBarState extends State<CustomAppBar> {
  bool _hasLocationPermission = false;
  List<PopupMenuEntry<int>> _menuOptions(BuildContext context) {
    return [
      PopupMenuItem<int>(
        child: InkWell(
          onTap: () {
            Navigator.pop(context, 0);  // Closes the popup and returns the value
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.white, // Set the background color to white
            child: const Row(
              children: [
                Icon(Icons.explore_outlined, color: Colors.pink),
                SizedBox(width: 16),
                Text('Serviços', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.pink)),
              ],
            ),
          ),
        ),
      ),
      const PopupMenuDivider(height: 1.0),
      PopupMenuItem<int>(
        child: InkWell(
          onTap: () {
            Navigator.pop(context, 1);  // Closes the popup and returns the value
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.white, // Set the background color to white
            child: const Row(
              children: [
                Icon(Icons.pets_outlined, color: Colors.pink),
                SizedBox(width: 16),
                Text('Adoção', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.pink)),
              ],
            ),
          ),
        ),
      ),
    ];
  }

  List<PopupMenuEntry<int>> _menuProfil(BuildContext context) {
    return [
      PopupMenuItem<int>(
        child: InkWell(
          onTap: () {
            Navigator.pop(context, 0);  // Closes the popup and returns the value
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.white, // Set the background color to white
            child: const Row(
              children: [
                Icon(Icons.edit_outlined, color: Colors.pink),
                SizedBox(width: 16),
                Text('Editar perfil', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.pink)),
              ],
            ),
          ),
        ),
      ),
      const PopupMenuDivider(height: 1.0),
      PopupMenuItem<int>(
        child: InkWell(
          onTap: () {
            Navigator.pop(context, 2);  // Closes the popup and returns the value
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.white, // Set the background color to white
            child: const Row(
              children: [
                Icon(Icons.pets_sharp, color: Colors.pink),
                SizedBox(width: 16),
                Text('My Pets', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.pink)),
              ],
            ),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.lightBlue.shade200,
      elevation: 0,
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.pets_sharp, color: Colors.white),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AsMinhasPublicacoes()));
          },
        ),
        IconButton(
          icon: const Icon(Icons.home_outlined, color: Colors.pink),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  const NovidadesPage()));
          },
        ),
        IconButton(
          icon: const Icon(Icons.menu, color: Colors.pink),
          onPressed: () async {
            final selectedValue = await showMenu<int>(
              context: context,
              position: RelativeRect.fill,
              items: _menuOptions(context),
            );

            // Handle the value returned from the menu here (if needed)
            if (selectedValue != null) {
              switch (selectedValue) {
                case 0:
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SearchServices()));
                  break;
                case 1:
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => AdotePage()));
                  break;
                default:
                  break;
              }
            }
          },
        ),
        IconButton(
          icon: Icon(
              _hasLocationPermission ? Icons.pin_drop : Icons.pin_drop_outlined,
              color: Colors.pink
          ),
          onPressed: () {
            _showLocationPermissionDialog(context);
          },
        ),

        /*IconButton(
          icon: Icon(Icons.send_outlined, color: Colors.pink),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConversationPage()));
          },
        ),*/
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.pink),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.person_outline_outlined, color: Colors.pink),
          onPressed: () async {
            final selectedValue = await showMenu<int>(
              context: context,
              position: RelativeRect.fill,
              items: _menuProfil(context),
            );

            // Handle the value returned from the menu here (if needed)
            if (selectedValue != null) {
              switch (selectedValue) {
                case 0:
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UpdateProfilePage()));
                  break;

                case 2:
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyPetsList()));
                  break;

                default:
                  break;
              }
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.pink),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false,
            );
          },
        ),
      ],
    );
  }
  void _showLocationPermissionDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Location Permission'),
          content: const Text('Do you allow the application to use your location via GPS?'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('Yes'),
              onPressed: () {
                setState(() {
                  _hasLocationPermission = true;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //@override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
