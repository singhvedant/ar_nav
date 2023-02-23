import 'package:ar_nav/navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:shaky_animated_listview/scroll_animator.dart';

class Navigate extends StatelessWidget {
  const Navigate({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedListView(
      duration: 100,
      extendedSpaceBetween: 30,
      spaceBetween: 10,
      children: [
        newItem('Tech Park', "assets/tp.jpg", context),
        newItem('University Building', "assets/ub.jpg", context),
        newItem('T.P.Ganesan', "assets/tpg.jpg", context),
        newItem('JAVA Canteen', "assets/java.jpg", context),
      ],
    );
  }

  Widget newItem(String title, String img, BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('pushed');
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NavigationScreen(title: title),
            ));
      },
      child: Card(
        elevation: 50,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        shadowColor: Colors.black,
        color: Colors.teal[200],
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.teal,
                  radius: 60,
                  child: CircleAvatar(
                    backgroundImage: AssetImage(
                      img,
                    ),
                    //NetworkImage
                    radius: 50,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.teal[900],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
