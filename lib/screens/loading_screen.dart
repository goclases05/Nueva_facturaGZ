import "package:flutter/material.dart";

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title:Image.asset(
          'assets/gozeri_blanco2.png',
           width: size.width * 0.25,
        ),
        actions:[
          CircleAvatar(
            backgroundColor: Colors.cyan[300],
            child: IconButton(
              onPressed: () {
                
              },
              icon:const Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          CircleAvatar(
            backgroundColor: Colors.cyan[300],
            child: IconButton(
              onPressed: () {
                
              },
              icon:const Icon(
                Icons.receipt_long,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          CircleAvatar(
            backgroundColor: Colors.cyan[300],
            child: IconButton(
              onPressed: () {
                
              },
              icon:const Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body:const Center(
        child: CircularProgressIndicator(
          color: Colors.cyan,
        ),
      ),
    );
  }
}