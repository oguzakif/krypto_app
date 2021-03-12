import 'dart:developer';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_flux/flutter_flux.dart';

class DayChanges {
  double volume;
  double price_change;
  double price_change_pct;
  double volume_change;
  double volume_change_pct;
  double market_cap_change;
  double market_cap_change_pct;

  DayChanges(
      {this.volume,
      this.market_cap_change,
      this.market_cap_change_pct,
      this.price_change,
      this.price_change_pct,
      this.volume_change,
      this.volume_change_pct});

  factory DayChanges.fromJson(Map<String, dynamic> json) {
    return DayChanges(
      volume: double.parse(json['volume']),
      price_change: double.parse(json['price_change']),
      price_change_pct: double.parse(json['price_change_pct']),
      volume_change: double.parse(json['volume_change']),
      volume_change_pct: double.parse(json['volume_change_pct']),
      market_cap_change: double.parse(json['market_cap_change']),
      market_cap_change_pct: double.parse(json['market_cap_change_pct']),
    );
  }
}

class SparklineInterval {
  String currencyId;
  List<dynamic> timeStamps;
  List<dynamic> prices;

  SparklineInterval({
    this.currencyId,
    this.timeStamps,
    this.prices,
  });

  SparklineInterval.fromJson(Map json)
      : currencyId = json['currency'],
        timeStamps = json['timestamps'],
        prices = json['prices'];
}

class CoinStats {
  double volume24h;
  double high24h;
  double low24h;
  final String id;

  CoinStats({
    this.high24h,
    this.low24h,
    this.volume24h,
    this.id,
  });
  CoinStats.fromJson(Map json)
      : high24h = double.parse(json["highPrice"]),
        low24h = double.parse(json["lowPrice"]),
        volume24h = double.parse(json["volume"]),
        id = json["symbol"];
}

class Coin {
  final String id;
  double priceUSD;
  double volume24h;
  double high24h;
  double low24h;
  double average24h;

  final String name;
  final String logoURL;

  DayChanges oneDayChanges;
  DayChanges sevenDayChanges;
  DayChanges thirtyDayChanges;
  SparklineInterval sparklineDaily;
  SparklineInterval sparklineWeekly;
  SparklineInterval sparklineMonthly;
  SparklineInterval sparklineYearly;

  Coin(
      {this.id,
      this.priceUSD,
      this.name,
      this.logoURL,
      this.oneDayChanges,
      this.sevenDayChanges,
      this.thirtyDayChanges});

  Coin.fromJson(Map json)
      : id = json['id'],
        priceUSD = double.parse(json['price']),
        name = json['name'],
        logoURL = json['logo_url'],
        oneDayChanges = DayChanges.fromJson(json['1d']),
        sevenDayChanges = DayChanges.fromJson(json['7d']),
        thirtyDayChanges = DayChanges.fromJson(json['30d']);

  void setPrice(double price) {
    priceUSD = price;
  }

  void setAverage(SparklineInterval interval){
    double average = 0;
    if(interval != null){
      for(String i in interval.prices){
        average += double.parse(i);
      }
      average = average/interval.prices.length;
    }
    average24h = average;
  }

  void setDayChanges(DayChanges day) {
    oneDayChanges = day;
  }

  void setWeekChanges(DayChanges week) {
    sevenDayChanges = week;
  }

  void setMonthChanges(DayChanges month) {
    thirtyDayChanges = month;
  }

  void setStats(CoinStats stats) {
    volume24h = stats.volume24h;
    high24h = stats.high24h;
    low24h = stats.low24h;
  }

  void setDailySparkline(SparklineInterval daily) {
    sparklineDaily = daily;
  }

  void setMonthlySparkline(SparklineInterval monthly) {
    sparklineMonthly = monthly;
  }

  void setWeeklySparkline(SparklineInterval weekly) {
    sparklineWeekly = weekly;
  }

  void setYearlySparkline(SparklineInterval yearly) {
    sparklineYearly = yearly;
  }
}

class CoinRepo {
  Future<Stream<Coin>> getCoins() async {
    String url = "https://heroku-vue-express.herokuapp.com/coins/relevant";
    var client = http.Client();
    var streamedRes = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRes.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .expand((body) => (body as List))
        .map((json) => Coin.fromJson(json));
  }
}

class SparklineIntervalRepo {
  Future<Stream<SparklineInterval>> getSparklineInterval(
      String id, String interval) async {
    var client = http.Client();
    String url =
        "https://heroku-vue-express.herokuapp.com/sparkline/" + interval + id;
    var streamedRes = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRes.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((json) => SparklineInterval.fromJson(json));
  }
}

class StatsRepo {
  Future<Stream<CoinStats>> getCoinStats(String id) async {
    var client = http.Client();
    String url = "https://heroku-vue-express.herokuapp.com/stats/" + id;
    var streamedRes = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRes.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((json) => CoinStats.fromJson(json));
  }
}

class CoinStore extends Store {
  final repo = CoinRepo();
  final sparklineRepo = SparklineIntervalRepo();
  final statsRepo = StatsRepo();
  var ids = [
    "BTC",
    "ETH",
    "DOGE",
    "ADA",
    "DOT",
    "XRP",
    "LTC",
    "LINK",
    "XLM",
    "ATOM",
    "TRX",
    "EOS",
    "XTZ",
    "NEO",
    "DASH"
  ];
  CoinStore() {
    triggerOnAction(loadCoinsAction, (nothing) async {
      var stream = await repo.getCoins();
      if (_coins.isEmpty) {
        stream.listen((coin) => _coins.add(coin));
      } else {
        stream.listen((coin) {
          for (Coin c in _coins) {
            if (c.id == coin.id) {
              c.setPrice(coin.priceUSD);
              c.setDayChanges(coin.oneDayChanges);
              c.setWeekChanges(coin.sevenDayChanges);
              c.setMonthChanges(coin.thirtyDayChanges);
            }
          }
        });
        for (String a in ids) {
          var stream2 = await sparklineRepo.getSparklineInterval(a, "daily/");
          var stream3 = await sparklineRepo.getSparklineInterval(a, "weekly/");
          var stream4 = await sparklineRepo.getSparklineInterval(a, "monthly/");
          var stream5 = await sparklineRepo.getSparklineInterval(a, "yearly/");
          var streamStats = await statsRepo.getCoinStats(a);
          stream2.listen((event) {
            for (Coin c in _coins) {
              //print(event.currencyId);
              if (event.currencyId == c.id) {
                c.setDailySparkline(event);
                c.setAverage(event);
              }
            }
          });
          stream3.listen((event) {
            for (Coin c in _coins) {
              //print(event.currencyId);

              if (event.currencyId == c.id) {
                c.setWeeklySparkline(event);
              }
            }
          });
          stream4.listen((event) {
            for (Coin c in _coins) {
              //print(event.currencyId);

              if (event.currencyId == c.id) {
                c.setMonthlySparkline(event);
              }
            }
          });
          stream5.listen((event) {
            for (Coin c in _coins) {
              //print(event.currencyId);
              if (event.currencyId == c.id) {
                c.setYearlySparkline(event);
              }
            }
          });
          streamStats.listen((event) {
            for (Coin c in _coins) {
              if (event.id.contains(c.id)) {
                c.setStats(event);
              }
            }
          });
        }
      }
    });
  }

  final List<Coin> _coins = <Coin>[];

  List<Coin> get coins => List<Coin>.from(_coins);
}

final Action loadCoinsAction = Action();
//final Action loadSparklineDaily = Action();
final StoreToken coinStoreToken = StoreToken(CoinStore());
