class ExpenseItemModel {
  // ignore: non_constant_identifier_names
  final String Id;
  final String amount;
  final String color;
  final String categoryName;
  final String date;

  ExpenseItemModel({
    required this.Id,
    required this.amount,
    required this.color,
    required this.categoryName,
    required this.date,
  });

  factory ExpenseItemModel.fromJson(Map<String, dynamic> json) => ExpenseItemModel(
      Id:json['Id'],
        amount:json['amount'], // Ensure valid double conversion
        color: json['color'],
        categoryName: json['categoryName'],
        date: json['date'],
      );

  Map<String, dynamic> toJson() => {
        'id':Id.toString(),
        'amount': amount.toString(),
        'color': color,
        'categoryName': categoryName,
        'date': date.toString(),
      };
}
class CategoryData {
  String color;
  double amount;

  CategoryData({required this.color, required this.amount});
  factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
     
        amount:json['amount'], // Ensure valid double conversion
        color: json['color'],
       
      );
  Map<String, dynamic> toJson() => {
     
        'amount': amount.toString(),
        'color': color,
        
      };
}
