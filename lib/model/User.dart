// class User {
//   String name;
//   int age;

//   User(this.name, this.age);

//   factory User.fromJson(dynamic json) {
//     return User(json['name'] as String, json['age'] as int);
//   }

//   @override
//   String toString() {
//     return '{ ${this.name}, ${this.age} }';
//   }
// }

// class Tutorial {
//   String title;
//   String description;
//   User author;

//   Tutorial(this.title, this.description, this.author);

//   factory Tutorial.fromJson(dynamic json) {
//     return Tutorial(json['title'] as String, json['description'] as String, User.fromJson(json['author']));
//   }

//   @override
//   String toString() {
//     return '{ ${this.title}, ${this.description}, ${this.author} }';
//   }
// }