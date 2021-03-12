import 'package:flutter/material.dart';
import './stores.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class CoinScreenIn extends StatefulWidget {
  CoinScreenIn(this.coin);
  Coin coin;

  @override
  _CoinScreenState createState() => _CoinScreenState();
}

class _CoinScreenState extends State<CoinScreenIn> {
  final coinController = TextEditingController();
  final usdController = TextEditingController();

  List<double> priceParser(String interval) {
    List<double> list = new List();
    if (interval == "daily") {
      for (String i in widget.coin.sparklineDaily.prices) {
        list.add(double.parse(i));
      }
      return list;
    } else if (interval == "weekly") {
      for (String i in widget.coin.sparklineWeekly.prices) {
        list.add(double.parse(i));
      }
      return list;
    } else if (interval == "monthly") {
      for (String i in widget.coin.sparklineMonthly.prices) {
        list.add(double.parse(i));
      }
      return list;
    } else {
      for (String i in widget.coin.sparklineYearly.prices) {
        list.add(double.parse(i));
      }
      return list;
    }
  }

  void _clearAll() {
    coinController.text = "";
    usdController.text = "";
  }

  void _coinChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    var coinN = double.parse(text);
    usdController.text = (widget.coin.priceUSD * coinN).toStringAsFixed(4);
  }

  void _dollarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    var dollar = double.parse(text);
    coinController.text = (dollar / widget.coin.priceUSD).toStringAsFixed(4);
  }

  bool isDouble(String value) {
    if (double.tryParse(value) != null) return true;

    return false;
  }

  static const _goldenColor = Color(0xFFFFD700);
  static const _lightColor = Color(0xFFFfcfaf1);

  Widget buildTextField(String label, String prefix,
      TextEditingController changeMoney, Function changed) {
    return Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: TextField(
          controller: changeMoney,
          decoration: InputDecoration(
              border: InputBorder.none,
              labelText: label,
              prefixText: prefix,
              prefixStyle: TextStyle()),
          onChanged: changed,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
        ));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.coin.name + " Detail Page"),
        ),
        body: Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            child: ListView(children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Card(
                      color: Colors.deepPurple.shade900,
                      elevation: 2.0,
                      child: ListTile(
                        title: Text(
                            "\$${widget.coin.priceUSD.toStringAsFixed(3)}"),
                        leading: CircleAvatar(
                          child: widget.coin.id == "DOT" ||
                                  widget.coin.id == "ATOM"
                              ? Image.network(widget.coin.logoURL)
                              : SvgPicture.network(widget.coin.logoURL),
                        ),
                        subtitle: Text(
                            widget.coin.oneDayChanges.price_change_pct > 0
                                ? "+" +
                                    "\$" +
                                    (widget.coin.oneDayChanges.price_change
                                            .abs())
                                        .toStringAsFixed(3) +
                                    " " +
                                    "(" +
                                    (widget.coin.oneDayChanges.price_change_pct *
                                            100)
                                        .toStringAsFixed(2) +
                                    "%)"
                                : "-" +
                                    "\$" +
                                    (widget.coin.oneDayChanges.price_change
                                            .abs())
                                        .toStringAsFixed(3) +
                                    " " +
                                    "(" +
                                    (widget.coin.oneDayChanges
                                                .price_change_pct *
                                            100)
                                        .toStringAsFixed(2) +
                                    "%)",
                            style: TextStyle(
                                color:
                                    widget.coin.oneDayChanges.price_change_pct >
                                            0
                                        ? Colors.lightGreenAccent[400]
                                        : Colors.deepOrangeAccent[700])),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              //LINE CHART SECTION
              //bezierChart(context),
              //LineChartSample2(),
              new Sparkline(
                data: priceParser("yearly"),
                fillMode: FillMode.below,
                fillGradient: new LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.deepPurple.shade900, Colors.white10],
                ),
                lineColor: Colors.white60,
              ),
              /*SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // Chart title
              title: ChartTitle(text: 'Half yearly sales analysis'),
              // Enable legend
              legend: Legend(isVisible: true),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<SparklineInterval, String>>[
                LineSeries<SparklineInterval, String>(
                    dataSource: widget.coin.sparklineDaily,
                    xValueMapper: (_SalesData sales, _) => sales.year,
                    yValueMapper: (_SalesData sales, _) => sales.sales,
                    name: 'Sales',
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(isVisible: true))
              ]),
            Padding(
            padding: const EdgeInsets.all(8.0),
            //Initialize the spark charts widget
            child: SfSparkLineChart.custom(
              //Enable the trackball
              trackball: SparkChartTrackball(
                  activationMode: SparkChartActivationMode.tap),
              //Enable marker
              marker: SparkChartMarker(
                  displayMode: SparkChartMarkerDisplayMode.all),
              //Enable data label
              labelDisplayMode: SparkChartLabelDisplayMode.all,
              xValueMapper: (int index) => data[index].year,
              yValueMapper: (int index) => data[index].sales,
              dataCount: 5,
            ),
            ),*/
              //optional color Color(0xff232d37)
              //24H STATISTICS SECTION
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      color: Colors.deepPurple.shade900,
                      elevation: 2.0,
                      child: ListTile(
                        title: Text("24h Low"),
                        subtitle: Text(widget.coin.low24h.toStringAsFixed(3))
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: Colors.deepPurple.shade900,
                      elevation: 2.0,
                      child: ListTile(
                        title: Text("24h High"),
                        subtitle: Text(widget.coin.high24h.toStringAsFixed(3)),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      color: Colors.deepPurple.shade900,
                      elevation: 2.0,
                      child: ListTile(
                        title: Text("24h Average"),
                        subtitle: Text(widget.coin.average24h.toStringAsFixed(3)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: Colors.deepPurple.shade900,
                      elevation: 2.0,
                      child: ListTile(
                        title: Text("24h Volume"),
                        subtitle: Text(widget.coin.volume24h.toStringAsFixed(3)),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 20, bottom: 20),
                    child: Text(widget.coin.name + " to USD converter",
                        style: TextStyle(color: _lightColor, fontSize: 20)),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Card(
                    elevation: 2.0,
                    color: Colors.grey.shade900,
                    child: buildTextField(
                        "USD", "\$", usdController, _dollarChanged),
                  ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Card(
                    elevation: 2.0,
                    color: Colors.deepPurple.shade900,
                    child: buildTextField(widget.coin.name, widget.coin.id,
                        coinController, _coinChanged),
                  ))
                ],
              ),
            ])));
  }
}
