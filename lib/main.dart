import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miniproject/article.dart';
import 'package:miniproject/basket.dart';

Future<void> main() async {
  runApp(const MyApp());
}

ThemeData myDarkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF121212),
  colorScheme: const ColorScheme.dark(
    primary: Colors.red,
    secondary: Colors.redAccent,
    surface: Color(0xFF1E1E1E),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white70,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E1E1E),
    foregroundColor: Colors.redAccent,
    elevation: 2,
  ),
  cardTheme: CardThemeData(
    color: const Color(0xFF1E1E1E),
    shadowColor: Colors.red.withOpacity(0.3),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.redAccent,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.redAccent,
      side: const BorderSide(color: Colors.redAccent),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.redAccent,
    foregroundColor: Colors.white,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF1E1E1E),
    selectedItemColor: Colors.redAccent,
    unselectedItemColor: Colors.white70,
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Color(0xFF2A2A2A),
    contentTextStyle: TextStyle(color: Colors.white),
    behavior: SnackBarBehavior.floating,
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      darkTheme: myDarkTheme,
      home: const MyHomePage(title: 'BuyMyCar.biz'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Article> _itemBasket = [];

  void _addArticleToBasket(Article item) {
    setState(() {
      _itemBasket.add(item);
    });
  }

  void _removeArticleFromBasket(Article item) {
    setState(() {
      _itemBasket.removeWhere((a) => a.id == item.id);
    });
  }

  // Bottom navigation state
  int _selectedIndex = 0;

  // Two-tab pages
  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return ArticleList(onAddToBasket: _addArticleToBasket);
      case 1:
        return BasketList(
          basket: _itemBasket,
          onRemoveArticle: _removeArticleFromBasket,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Articles'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            label: 'Basket (${_itemBasket.length})',
          ),
        ],
      ),
    );
  }
}
