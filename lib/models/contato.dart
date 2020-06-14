class Contato {
  int id;
  String name;
  String email;
  String image;

  Contato(this.id, this.name, this.email, this.image);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      'id':id,
      'name': name,
      'email': email,
      'image': image,
    };

    return map;
  }

  Contato.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    email = map['email'];
    image = map['image'];
  }

  @override
  String toString() {
    return "Contato => (id: $id, name: $name, email: $email, image: $image";
  }
}