import 'package:flutter/material.dart';
import 'food_page.dart';
import 'cocktails_page.dart';
import 'form_add_resource.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Main App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FoodPage.empty()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Container(
                width: 200,
                height: 200,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: Image.network(
                        'https://t3.ftcdn.net/jpg/02/60/12/88/360_F_260128861_Q2ttKHoVw2VrmvItxyCVBnEyM1852MoJ.jpg',
                        fit: BoxFit.cover,
                        width: 200,
                        height: 150,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Explore Food',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CocktailsPage.empty()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Container(
                width: 200,
                height: 200,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: Image.network(
                        'https://media.istockphoto.com/id/502072256/fr/photo/assortiment-cocktail-au-bar-bien-%C3%A9clair%C3%A9.jpg?s=612x612&w=0&k=20&c=p_Mf7rT2UXR8kEtWyZnYkk-BMcd51Z-ZOLnzS-NxgPE=',
                        fit: BoxFit.cover,
                        width: 200,
                        height: 150,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Explore Cocktails',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.purple],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Center(
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: Icon(Icons.add, color: const Color.fromARGB(255, 248, 247, 247), size: 30),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FormAddResource()),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}