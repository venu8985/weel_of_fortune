class Homemodel {
  final String meal;
  var img;

  Homemodel({required this.meal, this.img});

  factory Homemodel.fromJson(Map<String, dynamic> json) {
    return Homemodel(meal: json['strMeal'], img: json['strMealThumb']);
  }
}
