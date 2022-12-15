import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  final String uid;
  final int id;
  final String first_name;
  final String last_name;
  final String name;
  final String avatar;
  // final json;

  const User({
    required this.uid,
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.name,
    required this.avatar,
    // required this.json,
  });

  factory User.fromJson(json) {
    return User(
      uid: json['uid'],
      id: json['id'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      name: json['last_name'] + " " + json['first_name'],
      avatar: json['avatar'],
      //json: json,
    );
  }

  Map<String, dynamic> toJson() => {
        "avatar": this.avatar,
        "name": this.name,
      };
}

Future<User> fetchUser() async {
  final response = await http
      .get(Uri.parse('https://random-data-api.com/api/users/random_user'));
  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load user');
  }
}
