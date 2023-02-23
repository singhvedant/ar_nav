import 'package:ar_nav/add_map.dart';
import 'package:ar_nav/navigate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:ar_nav/suggestions.dart';
import 'package:easy_dashboard/easy_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AR NAV',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (context) => const MyHomePage(),
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final firebase = FirebaseAuth.instance;
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<SideTile> tiles = [
      SideBarTile(
        title: const Text("Navigate"),
        body: const Navigate(),
        icon: Icons.navigation,
        name: 'Navigate',
      ),
      SideBarTile(
        title: const Text("Map Builder"),
        body: Container(),
        icon: Icons.build,
        name: 'Build',
      ),
      SideBarTile(
        title: const Text("Settings"),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            child: Text("Logout"),
            onPressed: () async {
              await FirebaseAuth.instance.signOut().then((value) {
                setState(() {});
              });
            },
          ),
        ),
        icon: Icons.settings,
        name: 'Settings',
      ),
    ];
    final EasyAppController controller = EasyAppController(
      intialBody: EasyBody(
        child: const Center(child: Navigate()),
        title: const Text("Navigate"),
      ),
    );
    const List<Widget> actions = [];

    return firebase.currentUser == null
        ? Scaffold(
            body: FlutterLogin(
              title: 'Login',
              onLogin: _authUser,
              onSignup: _signupUser,
              onSubmitAnimationCompleted: () {
                setState(() {});
              },
              onRecoverPassword: _recoverPassword,
            ), // This trailing comma makes auto-formatting nicer for build methods.
          )
        : EasyDashboard(
            controller: controller,
            navigationIcon: const Icon(Icons.menu, color: Colors.white),
            appBarActions: actions,
            centerTitle: true,
            appBarColor: Colors.teal,
            sideBarColor: Colors.grey.shade100,
            tabletView: const TabletView(
              fullAppBar: false,
              border: BorderSide(width: 0.5, color: Colors.grey),
            ),
            drawer: (Size size, Widget? child) {
              return EasyDrawer(
                iconColor: Colors.teal,
                hoverColor: Colors.grey.shade300,
                tileColor: Colors.grey.shade100,
                selectedColor: Colors.black.withGreen(80),
                selectedIconColor: Colors.white,
                textColor: Colors.black.withGreen(20),
                selectedTileColor: Colors.teal.shade400.withOpacity(.8),
                tiles: tiles,
                topWidget: SideBox(
                  scrollable: true,
                  height: 150,
                  child: Container(
                    margin: const EdgeInsets.only(top: 40),
                    child: const Image(image: AssetImage('assets/user.png')),
                  ),
                ),
                bottomWidget: const SideBox(
                  scrollable: false,
                  height: 50,
                  child: Text('MAN OF ACTION'),
                ),
                size: size,
                onTileTapped: (body) {
                  controller.switchBody(body);
                },
              );
            },
          );
  }

  Future<String?>? _authUser(LoginData data) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return ('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        return ('Wrong password provided for that user.');
      }
    }
    return null;
  }

  Future<String?>? _signupUser(SignupData data) async {
    try {
      UserCredential userCredential =
          await firebase.createUserWithEmailAndPassword(
        email: data.name!,
        password: data.password!,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return ('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return ('The account already exists for that email.');
      }
    } catch (e) {
      return (e.toString());
    }
    return null;
  }

  Future<String?>? _recoverPassword(String data) {}
}
