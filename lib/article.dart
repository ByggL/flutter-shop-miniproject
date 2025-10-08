import 'dart:convert';

import 'package:flutter/material.dart';

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
  final String jsonString;

  ArticleList({
    super.key,
    required this.onAddToBasket,
    required this.jsonString,
  });

  // Synchronous JSON parsing
  final String jsonData = '''
  [
  {"id":1,"name":"Toyota Supra Mk4 (1993)","description":"The fourth-generation Toyota Supra became an icon of 1990s performance cars, boasting a 3.0-liter twin-turbo inline-six engine producing up to 320 horsepower. Its smooth design, bulletproof reliability, and immense tuning potential made it a favorite among enthusiasts and pop culture alike.","price":65000,"image":"https://upload.wikimedia.org/wikipedia/commons/d/d5/Toyota_Supra_A80%2C_Bangladesh._%2833381482523%29.jpg"},
  {"id":2,"name":"Mazda RX-7 FD3S (1992)","description":"The Mazda RX-7 FD3S was celebrated for its lightweight chassis, near-perfect weight distribution, and distinctive twin-rotor Wankel engine. Its sleek curves and razor-sharp handling earned it cult status as one of Japan’s finest sports cars of the decade.","price":55000,"image":"https://upload.wikimedia.org/wikipedia/commons/8/8c/1994_Mazda_RX-7_R2_in_Vintage_Red%2C_front_left_%28Lime_Rock%29.jpg"},
  {"id":3,"name":"Nissan Skyline GT-R R34 (1999)","description":"The Nissan Skyline GT-R R34 combined advanced all-wheel drive and a potent RB26DETT engine to deliver exceptional performance. Its digital driver interface and legendary tuning potential cemented its place in automotive history and Japanese performance culture.","price":120000,"image":"https://upload.wikimedia.org/wikipedia/commons/thumb/0/06/Nissan_Skyline_GT-R_R34_V_Spec_II.jpg/960px-Nissan_Skyline_GT-R_R34_V_Spec_II.jpg?20150619164332"},
  {"id":4,"name":"Honda NSX (1990)","description":"The Honda NSX redefined supercar standards with everyday usability and precision engineering. Featuring an all-aluminum body, mid-mounted V6, and input from Formula 1 champion Ayrton Senna, it provided a balance of performance and refinement that rivaled European exotics.","price":90000,"image":"https://upload.wikimedia.org/wikipedia/commons/thumb/a/aa/Honda_NSX_1993_Castle_Hedingham_2008.JPG/1200px-Honda_NSX_1993_Castle_Hedingham_2008.JPG"},
  {"id":5,"name":"BMW E36 M3 (1992)","description":"The BMW E36 M3 offered a blend of performance and practicality with its high-revving inline-six engine and balanced chassis. Known for its precise handling and understated looks, it became a benchmark for sports sedans of the 1990s.","price":40000,"image":"https://upload.wikimedia.org/wikipedia/commons/thumb/e/e5/BMWM3E36-001.jpg/1200px-BMWM3E36-001.jpg"},
  {"id":6,"name":"Porsche 911 (993) (1994)","description":"The Porsche 911 (993) marked the end of the air-cooled era, combining classic Porsche styling with improved handling and performance. Its timeless design and robust build quality make it one of the most sought-after 911 models today.","price":150000,"image":"https://images-porsche.imgix.net/-/media/250EC08BC48142DEA25BEC9D2144BB0A_2FEBFABD29EB4E878E4D5E6E270E56C1_020_info-slider_993_carrera_s_1997-98_desktop?w=1299&q=85&auto=format"},
  {"id":7,"name":"Chevrolet Corvette C5 (1997)","description":"The fifth-generation Corvette introduced the LS1 V8 engine, offering 345 horsepower with improved refinement and comfort. Its composite body and modern suspension made it a capable grand tourer with true American performance DNA.","price":35000,"image":"https://upload.wikimedia.org/wikipedia/commons/b/b9/Chevrolet_Corvette_C5.jpg"},
  {"id":8,"name":"Mitsubishi Lancer Evolution VI (1999)","description":"The Mitsubishi Lancer Evolution VI was built for rally dominance, featuring a turbocharged 2.0-liter engine, all-wheel drive, and aggressive aerodynamics. Its raw performance and razor-sharp response made it a legend among performance sedans.","price":45000,"image":"https://upload.wikimedia.org/wikipedia/commons/d/d3/Mitsubishi_Lancer_Evolution_VI.jpg"},
  {"id":9,"name":"Ferrari F355 (1994)","description":"The Ferrari F355 combined elegant design with cutting-edge performance. Its 3.5-liter V8 produced 375 horsepower, paired with a screaming 8,500 rpm redline. It’s revered for bringing modern drivability to Ferrari’s mid-engine lineup.","price":160000,"image":"https://upload.wikimedia.org/wikipedia/commons/0/00/2007-06-17_Ferrari_F355_GTS_%28kl%29.jpg"},
  {"id":10,"name":"Acura Integra Type R (1997)","description":"The Acura Integra Type R is often hailed as one of the best-handling front-wheel-drive cars ever built. Its hand-built 1.8-liter VTEC engine, lightweight chassis, and precise gearshift made it a favorite among driving purists and tuners alike.","price":38000,"image":"https://hips.hearstapps.com/hmg-prod/images/1997-acura-integratyper-105-1589894166.jpg"}
]
  ''';

  final void Function(Article) onAddToBasket;

  List<Article> parseArticles() {
    final List<dynamic> data = jsonDecode(jsonData);
    return data.map((json) => Article.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final articles = parseArticles();

    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        return ArticleCard(article: articles[index], onAdd: onAddToBasket);
      },
    );
  }
}
