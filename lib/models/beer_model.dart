import 'package:http/http.dart' as http;
import 'dart:convert';

class Beer {
  final int id;
  final String uid;
  final String brand;
  final String name;
  final String style;
  final String hop;
  final String alcohol;

  const Beer({
    required this.uid,
    required this.id,
    required this.name,
    required this.brand,
    required this.style,
    required this.hop,
    required this.alcohol,
  });

  factory Beer.fromJson(Map<String, dynamic> json) {
    return Beer(
      uid: json['uid'],
      id: json['id'],
      name: json['name'],
      brand: json['brand'],
      style: json['style'],
      hop: json['hop'],
      alcohol: json['alcohol'],
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': this.uid,
        'id': this.id,
        "name": this.name,
        "brand": this.brand,
        "style": this.style,
        "hop": this.hop,
        "alcohol": this.alcohol,
      };
}

Future<Beer> fetchBeer() async {
  final response = await http
      .get(Uri.parse('https://random-data-api.com/api/beer/random_beer'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Beer.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load beer');
  }
}

/**{
"id": 8481,
"uid": "3fde8cde-f3a9-4be7-8500-10fbb3f5c2dc",
"brand": "Heineken",
"name": "Hercules Double IPA",
"style": "Pilsner",
"hop": "Bravo",
"yeast": "1318 - London Ale III",
"malts": "Roasted barley",
"ibu": "92 IBU",
"alcohol": "7.6%",
"blg": "14.7°Blg"
} */