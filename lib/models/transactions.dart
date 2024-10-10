class Transactions {
  final int? keyID;
  final String title;
  final double amount;
  final DateTime date;
  final String user;
  final String password;
  final String products;

  Transactions({
    this.keyID,
    required this.title,
    required this.amount,
    required this.date,
    required this.password,
    required this.user,
    required this.products,
  });
}
