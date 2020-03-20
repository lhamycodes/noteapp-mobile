import 'note.dart';

class User {
  int id;
  String uuid;
  String name;
  String email;
  List<Note> notes;

  User({
    this.id,
    this.uuid,
    this.name,
    this.email,
    this.notes,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    name = json['name'];
    email = json['email'];
    if (json['notes'] != null) {
      notes = List<Note>();
      json['notes'].forEach((v) {
        notes.add(Note.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uuid'] = this.uuid;
    data['name'] = this.name;
    data['email'] = this.email;
    if (this.notes != null) {
      data['notes'] = this.notes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
