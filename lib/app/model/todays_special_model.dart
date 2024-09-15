// class TodaySpecialModel {
//   final String description;
//   final String image;
//   final String title;
//
//   TodaySpecialModel({
//     required this.description,
//     required this.image,
//     required this.title,
//   });
//
//   // Factory constructor for creating a new instance from a map
//   factory TodaySpecialModel.fromJson(Map<String, dynamic> json) {
//     return TodaySpecialModel(
//       description: json['description'],
//       image: json['image'],
//       title: json['title'],
//     );
//   }
//
//   // Method for converting an instance to a map
//   Map<String, dynamic> toJson() {
//     return {
//       'description': description,
//       'image': image,
//       'title': title,
//     };
//   }
// }


class TodaySpecialModel {
  String id;
  String title;
  String imageUrl;
  String linkUrl;
  bool publish;

  TodaySpecialModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.linkUrl,
    required this.publish,
  });

  // Convert model to JSON (for Firestore)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image_url': imageUrl,
      'link_url': linkUrl,
      'publish': publish,
    };
  }

  // Convert JSON to model (for fetching from Firestore)
  static TodaySpecialModel fromJson(Map<String, dynamic> json) {
    return TodaySpecialModel(
      id: json['id'] as String,
      title: json['title'] as String,
      imageUrl: json['image_url'] as String,
      linkUrl: json['link_url'] as String,
      publish: json['publish'] as bool,
    );
  }
}
