import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:miniproject/article.dart';

class BasketCard extends StatelessWidget {
  final Article article;
  final void Function(Article) onRemove;

  const BasketCard({super.key, required this.article, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.image.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  article.image,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            if (article.image.isNotEmpty) const SizedBox(height: 12),
            Text(
              article.name,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              article.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "\$${article.price.toString()}",
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.green[700]),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    onRemove(article);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${article.name} removed from basket'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  icon: const Icon(Icons.remove_shopping_cart),
                  label: const Text('Remove'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BasketList extends StatelessWidget {
  final List<Article> basket;
  final void Function(Article) onRemoveArticle;

  const BasketList({
    super.key,
    required this.basket,
    required this.onRemoveArticle,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: basket.length,
      itemBuilder: (context, index) {
        return BasketCard(article: basket[index], onRemove: onRemoveArticle);
      },
    );
  }
}
