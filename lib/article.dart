import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<String> loadJsonFile(String path) async {
  // Loads the file from the Flutter assets and returns it as a String
  return await rootBundle.loadString(path);
}

class Article {
  final int id;
  final String name;
  final String description;
  final int price;
  final String image;

  Article({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      image: json['image'],
    );
  }
}

class ArticleCard extends StatelessWidget {
  final Article article;
  final void Function(Article) onAdd;

  const ArticleCard({super.key, required this.article, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Image section (square) ---
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 120,
                height: 120,
                child: Image.network(
                  article.image.isNotEmpty
                      ? article.image
                      : 'https://via.placeholder.com/150',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // --- Text & button section ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    article.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Description
                  Text(
                    article.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Bottom row (price + button)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ArticleDetailsPage(
                                article: article,
                                onAdd: onAdd,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.info_outline),
                        label: const Text('Details'),
                      ),
                      const Spacer(),
                      Text('\$${article.price}'),
                      const SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          onAdd(article);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${article.name} added to basket'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('Add'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: Colors.greenAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleDetailsPage extends StatelessWidget {
  final Article article;
  final void Function(Article) onAdd;

  const ArticleDetailsPage({
    super.key,
    required this.article,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                article.image.isNotEmpty
                    ? article.image
                    : 'https://via.placeholder.com/400',
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              article.name,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${article.price}',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.green[700]),
            ),
            const SizedBox(height: 16),
            Text(
              article.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                onAdd(article);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${article.name} added to basket'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Add'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Colors.greenAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleList extends StatelessWidget {
  ArticleList({super.key, required this.onAddToBasket});

  final void Function(Article) onAddToBasket;

  Future<List<Article>> loadArticlesFromJson(String path) async {
    final String jsonString = await rootBundle.loadString(path);
    final List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((item) => Article.fromJson(item)).toList();
  }

  @override
  Widget build(BuildContext context) {
    // final articles = parseArticles();

    return Scaffold(
      body: FutureBuilder<List<Article>>(
        future: loadArticlesFromJson("data/articles.json"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Still loading
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Error loading JSON
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Empty JSON or no data
            return const Center(child: Text('No articles found.'));
          }

          final articles = snapshot.data!;
          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              return ArticleCard(
                article: articles[index],
                onAdd: onAddToBasket,
              );
            },
          );
        },
      ),
    );
  }
}
