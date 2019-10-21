import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uuid;
  final String firstname;
  final String lastname;
  final String email;
  final String displayName;
  final DocumentReference reference;

  UserModel.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['uuid'] != null),
        assert(map['firstname'] != null),
        uuid = map['uuid'],
        firstname = map['firstname'],
        lastname = map['lastname'],
        email = map['email'],
        displayName =
            map['displayname'] ?? map["lastname"] /* todo: remove that*/;

  UserModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "User<$displayName:$email>";
}
