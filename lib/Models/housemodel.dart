// ignore_for_file: public_member_api_docs, sort_constructors_first
class HouseModel {

  String city;
  String wilaya;
  String price;
  String houseId;
  String type;
  String image;
  String description;
  String sellerId;
  int? beds;
  int? baths;

  HouseModel({
    required this.city,
    required this.wilaya,
    required this.price,
    required this.houseId,
    required this.type,
    required this.image,
    required this.description,
    required this.sellerId,
    this.beds,
    this.baths,
  });
}
