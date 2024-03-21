import 'package:booksy_2/bookshelf/bookshelf_screen.dart';
import 'package:booksy_2/home/home_screen.dart';
import 'package:booksy_2/state.dart';
import 'package:booksy_2/firebase_options.dart' as fo;
import 'package:flutter/material.dart';
import 'package:booksy_2/categories/categories_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

//import 'package:flutter/widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: fo.DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      //el block provider simepre tiene que estas por sobre los widget que hacenn uso de el
      create: (_) => BookShelfBloc(BookShelfState([])),
      child: MaterialApp(
        title: 'Booksy',
        theme: ThemeData(
          primarySwatch: Colors.grey,
          appBarTheme: AppBarTheme(
            color: Colors.grey, // Color púrpura para la barra de la aplicación
          ),
        ),
        home: const BottonNavigationWidget(),
      ),
    );
  }
}

class BottonNavigationWidget extends StatefulWidget {
  const BottonNavigationWidget({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _BottonNavigationWidget();
}

class _BottonNavigationWidget extends State<BottonNavigationWidget> {
  int _selectedindex = 0;

  static const List<Widget> _sections = [
    HomeScreen(),
    CategoriesScreen(),
    BookShelfScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booksy"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Inicio",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_library),
            label: "Biblioteca",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories),
            label: "Mi Estante",
          ),
        ],
        currentIndex: _selectedindex,
        onTap: _onItemTaped,
      ),
      body: _sections[_selectedindex],
    );
  }

  void _onItemTaped(int index) {
    setState(() {
      _selectedindex = index;
    });
  }
}
