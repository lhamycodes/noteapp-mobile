class Note {
  int id;
  String uuid;
  int userId;
  String title;
  String description;
  String createdAt;
  String updatedAt;

  Note({
    this.id,
    this.uuid,
    this.userId,
    this.title,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  Note.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uuid'] = this.uuid;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
