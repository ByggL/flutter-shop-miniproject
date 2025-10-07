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

  const ArticleCard({super.key, required this.article});

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
            Text(
              "\$${article.price.toString()}",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.green[700]),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(Colors.blue),
                backgroundColor: WidgetStateProperty.all<Color>(
                  Colors.greenAccent,
                ),
              ),
              onPressed: () {},
              child: Text('Add to cart'),
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleList extends StatelessWidget {
  const ArticleList({super.key});

  // Synchronous JSON parsing
  final String jsonData = '''
  [
    {"id":1,"name":"Toyota Supra Mk4 (1993)","description":"The fourth-generation Toyota Supra became an icon of 1990s performance cars, boasting a 3.0-liter twin-turbo inline-six engine producing up to 320 horsepower. Its smooth design, bulletproof reliability, and immense tuning potential made it a favorite among enthusiasts and pop culture alike.","price":65000,"image":""},
    {"id":2,"name":"Mazda RX-7 FD3S (1992)","description":"The Mazda RX-7 FD3S was celebrated for its lightweight chassis, near-perfect weight distribution, and distinctive twin-rotor Wankel engine. Its sleek curves and razor-sharp handling earned it cult status as one of Japan’s finest sports cars of the decade.","price":55000,"image":""},
    {"id":3,"name":"Nissan Skyline GT-R R34 (1999)","description":"The Nissan Skyline GT-R R34 combined advanced all-wheel drive and a potent RB26DETT engine to deliver exceptional performance. Its digital driver interface and legendary tuning potential cemented its place in automotive history and Japanese performance culture.","price":120000,"image":""},
    {"id":4,"name":"Honda NSX (1990)","description":"The Honda NSX redefined supercar standards with everyday usability and precision engineering. Featuring an all-aluminum body, mid-mounted V6, and input from Formula 1 champion Ayrton Senna, it provided a balance of performance and refinement that rivaled European exotics.","price":90000,"image":""},
    {"id":5,"name":"BMW E36 M3 (1992)","description":"The BMW E36 M3 offered a blend of performance and practicality with its high-revving inline-six engine and balanced chassis. Known for its precise handling and understated looks, it became a benchmark for sports sedans of the 1990s.","price":40000,"image":""},
    {"id":6,"name":"Porsche 911 (993) (1994)","description":"The Porsche 911 (993) marked the end of the air-cooled era, combining classic Porsche styling with improved handling and performance. Its timeless design and robust build quality make it one of the most sought-after 911 models today.","price":150000,"image":""},
    {"id":7,"name":"Chevrolet Corvette C5 (1997)","description":"The fifth-generation Corvette introduced the LS1 V8 engine, offering 345 horsepower with improved refinement and comfort. Its composite body and modern suspension made it a capable grand tourer with true American performance DNA.","price":35000,"image":""},
    {"id":8,"name":"Mitsubishi Lancer Evolution VI (1999)","description":"The Mitsubishi Lancer Evolution VI was built for rally dominance, featuring a turbocharged 2.0-liter engine, all-wheel drive, and aggressive aerodynamics. Its raw performance and razor-sharp response made it a legend among performance sedans.","price":45000,"image":""},
    {"id":9,"name":"Ferrari F355 (1994)","description":"The Ferrari F355 combined elegant design with cutting-edge performance. Its 3.5-liter V8 produced 375 horsepower, paired with a screaming 8,500 rpm redline. It’s revered for bringing modern drivability to Ferrari’s mid-engine lineup.","price":160000,"image":""},
    {"id":10,"name":"Acura Integra Type R (1997)","description":"The Acura Integra Type R is often hailed as one of the best-handling front-wheel-drive cars ever built. Its hand-built 1.8-liter VTEC engine, lightweight chassis, and precise gearshift made it a favorite among driving purists and tuners alike.","price":38000,"image":""}
  ]
  ''';

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
        return ArticleCard(article: articles[index]);
      },
    );
  }
}
