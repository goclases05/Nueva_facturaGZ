import "package:flutter/material.dart";

class LoadingScreen extends StatelessWidget {
  LoadingScreen({Key? key, required this.colorPrimary}) : super(key: key);
  Color colorPrimary;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorPrimary,
        foregroundColor: Colors.white,
        title: Image.asset(
          'assets/gozeri_blanco2.png',
          width: size.width * 0.25,
        ),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.white54,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          CircleAvatar(
            backgroundColor: Colors.white54,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.receipt_long,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Center(
        child: CircularProgressIndicator(
          color: colorPrimary,
        ),
      ),
    );
  }
}
