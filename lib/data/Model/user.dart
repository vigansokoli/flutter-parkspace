import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class User {
  final String id;
  // String userName;
  String email;
  String token;
  String phone;
  String city;
  String country;
  String street;
  String postalCode;

  double balance;

  User(this.id, this.email, this.token, this.phone, this.city, this.country,
      this.street, this.postalCode, this.balance);

  User.initial()
      : id = '0',
        // userName = '',
        token = '';

  User.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        // userName = json['username'],
        balance = json['balance'].toDouble(),
        token = json['token'],
        email = json['email'],
        city = json['city'],
        country = json['country'],
        street = json['street'];
  // postalCode = json['postalCode'];

  Map<String, dynamic> toJson() => {
        '_id': id,
        // 'username': userName,
        'email': email,
        'token': token,
        'balance': balance,
        'phone': phone != null ? phone : '',
        'city': city != null ? city : '',
        'country': country != null ? country : '',
        'street': street != null ? street : '',
        // 'postalCode': postalCode,
      };

  bool operator ==(o) => o is User && o.id == id;
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return '_id $id email $email token $token balance $balance';
  }
}
