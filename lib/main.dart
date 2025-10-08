import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miniproject/article.dart';
import 'package:miniproject/basket.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
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
