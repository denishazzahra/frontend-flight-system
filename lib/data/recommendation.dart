class Recommendation {
  String name;
  String code;
  String image;
  Recommendation({required this.name, required this.code, required this.image});
}

List<Recommendation> recommendationList = [
  Recommendation(name: 'Soekarno-Hatta', code: 'CGK', image: 'cgk.jpg'),
  Recommendation(name: 'Juanda', code: 'SUB', image: 'sub.jpg'),
  Recommendation(name: 'Sultan Hasanuddin', code: 'UPG', image: 'upg.jpg'),
  Recommendation(name: 'I Gusti Ngurah Rai', code: 'DPS', image: 'dps.jpg'),
];
