class User {
  String id;
  String name;
  String email;
  String imageAsBase64;

  User(this.id, this.name, this.email, this.imageAsBase64);
}

const defaultUserImagePath = "assets/default_user.png";
