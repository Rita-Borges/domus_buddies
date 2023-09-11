import 'package:domus_buddies/services/login_keycloack.dart';
import 'package:flutter/material.dart';
import 'background/BackgroundGeneric.dart';
import 'User/recovery_page.dart';

import 'package:domus_buddies/feed_page.dart';

class LoginPagev0 extends StatefulWidget {
  const LoginPagev0({Key? key}) : super(key: key);

  @override
  _LoginPagev0State createState() => _LoginPagev0State();
}

class _LoginPagev0State extends State<LoginPagev0> {
  bool _isHovering = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loginFailed = false; // Track login failure

  void _handleLogin() async {
    final String username = _usernameController.text.toLowerCase();
    final String password = _passwordController.text;

    final token = await KeycloakService().authenticate(context, username, password);

    // Replace this with your actual authentication logic
    bool isAuthenticated = true;

    if (isAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const PositiveLogin(),
        ),
      );
    } else {
      setState(() {
        _loginFailed = true;

      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(loginFailed: _loginFailed), // Pass the loginFailed variable
      body: CustomBody(
        isHovering: _isHovering,
        usernameController: _usernameController,
        passwordController: _passwordController,
        handleLogin: _handleLogin,
        setHovering: (bool value) {
          setState(() {
            _isHovering = value;
          });
        },
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool loginFailed; // Receive loginFailed as a parameter

  const CustomAppBar({Key? key, required this.loginFailed}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: loginFailed ? Colors.pink : Colors.lightBlue.shade200,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.pink),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: loginFailed
          ? Text(
        'Login Failed',
        style: TextStyle(color: Colors.white),
      )
          : null,
    );
  }
}

class CustomBody extends StatefulWidget {
  final bool isHovering;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final VoidCallback handleLogin;
  final Function(bool) setHovering;

  const CustomBody({
    Key? key,
    required this.isHovering,
    required this.usernameController,
    required this.passwordController,
    required this.handleLogin,
    required this.setHovering,
  }) : super(key: key);

  @override
  _CustomBodyState createState() => _CustomBodyState();
}

class _CustomBodyState extends State<CustomBody> {
  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Center(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Center(
              child: Text(
                'Efetue Login',
                style: TextStyle(
                  color: Colors.pink,
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Handwritten',
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: Image.asset(
                'assets/images/cryptocurrency-art.png',
              ),
            ),
            TextFormField(
              controller: widget.usernameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person, color: Colors.white),
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: widget.passwordController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock, color: Colors.white),
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 32.0),
            ElevatedLoginButton(
              handleLogin: widget.handleLogin,
            ),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTapDown: (_) {
                widget.setHovering(true); // Update isHovering to true
              },
              onTapCancel: () {
                widget.setHovering(false); // Update isHovering to false
              },
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PasswordRecoveryPage(),
                  ),
                );
              },
              child: RecoveryText(
                isHovering: widget.isHovering,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ElevatedLoginButton extends StatelessWidget {
  final VoidCallback handleLogin;

  const ElevatedLoginButton({Key? key, required this.handleLogin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.0,
      child: ElevatedButton(
        onPressed: handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_circle, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Login',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecoveryText extends StatelessWidget {
  final bool isHovering;

  const RecoveryText({Key? key, required this.isHovering}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'Para recuperar a sua password, ',
        style: const TextStyle(color: Colors.white),
        children: [
          TextSpan(
            text: 'clique Aqui',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isHovering ? Colors.pink : Colors.lightBlueAccent,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}

class PositiveLogin extends StatelessWidget {
  const PositiveLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Move to feedPage',
      theme: ThemeData(),
      home: const NovidadesPage(),
    );
  }
}

class PasswordRecoveryPage extends StatelessWidget {
  const PasswordRecoveryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Recovery Page',
      theme: ThemeData(),
      home: PasswordRecoveryPage2(),
    );
  }
}
