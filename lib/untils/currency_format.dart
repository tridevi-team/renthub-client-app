class CurrencyFormat {

  static int roundToMillion(int price) {
    return (price / 1000000).round();
  }
}