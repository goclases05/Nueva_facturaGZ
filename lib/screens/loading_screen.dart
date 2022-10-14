import "package:flutter/material.dart";

class LoadingScreen extends StatelessWidget {
  LoadingScreen({Key? key, required this.colorPrimary}) : super(key: key);
  Color colorPrimary;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: colorPrimary,
        title: Image.asset(
          color: colorPrimary,
          'assets/gozeri_blanco2.png',
          width: size.width * 0.25,
        ),
        actions: [
          CircleAvatar(
            backgroundColor: const Color.fromRGBO(242, 242, 247, 1),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: colorPrimary,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          CircleAvatar(
            backgroundColor: const Color.fromRGBO(242, 242, 247, 1),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.receipt_long,
                color: colorPrimary,
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
