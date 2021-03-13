import 'package:flutter/material.dart';
import './stores.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:intl/intl.dart';

String graphInterval = "daily";

class CoinScreenIn extends StatefulWidget {
  CoinScreenIn(this.coin);
  Coin coin;
  List<bool> isSelected = [true, false, false, false];
  @override
  _CoinScreenState createState() => _CoinScreenState();
}

class DataPoint {
  double value;
  String date;

  DataPoint(double value, String date, String interval) {
    this.value = value;
    DateTime timeObj = DateTime.parse(date);
    if(interval == "yearly")
    date = DateFormat('d/MMM/yyy').format(timeObj);

    else if(interval =="weekly")
    date = DateFormat('d/MMM').format(timeObj);

    else if(interval =="monthly")
    date = DateFormat('d/MMM').format(timeObj);
    else 
    date = DateFormat('d/h a').format(timeObj);
    this.date = date;
  }
}

class _CoinScreenState extends State<CoinScreenIn> {
  final coinController = TextEditingController();
  final usdController = TextEditingController();


  List<DataPoint> getGraphData() {
    List<DataPoint> graphData = new List();
    List<double> price = priceParser();
    List<String> date = getDate();
    for (int i = 0; i < price.length; i++)
      graphData.add(new DataPoint(price[i], date[i], graphInterval));

    return graphData;
  }

  List<double> priceParser() {
    List<double> list = new List();
    if (graphInterval == "daily") {
      for (String i in widget.coin.sparklineDaily.prices) {
        list.add(double.parse(i));
      }
      return list;
    } else if (graphInterval == "weekly") {
      for (String i in widget.coin.sparklineWeekly.prices) {
        list.add(double.parse(i));
      }
      return list;
    } else if (graphInterval == "monthly") {
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

  List<String> getDate() {
    List<String> list = new List();
    if (graphInterval == "daily") {
      for (String i in widget.coin.sparklineDaily.timeStamps) {
        list.add(i);
      }
      return list;
    } else if (graphInterval == "weekly") {
      for (String i in widget.coin.sparklineWeekly.timeStamps) {
        list.add(i);
      }
      return list;
    } else if (graphInterval == "monthly") {
      for (String i in widget.coin.sparklineMonthly.timeStamps) {
        list.add(i);
      }
      return list;
    } else {
      for (String i in widget.coin.sparklineYearly.timeStamps) {
        list.add(i);
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

  Widget sparklineGraph(String interval) {
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(),
        // Chart title
        title: ChartTitle(text: interval[0].toUpperCase()+interval.substring(1) + " " + widget.coin.name + " Chart"),
        // Enable legend
        //legend: Legend(isVisible: true),
        // Enable tooltip

        //tooltipBehavior: TooltipBehavior(enable: true),
        crosshairBehavior: CrosshairBehavior(enable: true),
        series: <ChartSeries<DataPoint, String>>[
          LineSeries<DataPoint, String>(
              dataSource: getGraphData(),
              xValueMapper: (DataPoint point, _) => point.date.toString(),
              yValueMapper: (DataPoint point, _) => point.value,
              name: widget.coin.name + " Price",
              // Enable data label
              dataLabelSettings: DataLabelSettings(isVisible: false))
        ]);
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
              sparklineGraph(graphInterval),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ToggleButtons(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 15, bottom: 15),
                        child: Text("Daily"),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 15, bottom: 15),
                        child: Text("Weekly"),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 15, bottom: 15),
                        child: Text("Monthly"),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 15, right: 15, top: 15, bottom: 15),
                        child: Text("Yearly"),
                      ),
                    ],
                    onPressed: (int index) {
                      setState(() {
                        for (int buttonIndex = 0;
                            buttonIndex < widget.isSelected.length;
                            buttonIndex++) {
                          if (buttonIndex == index) {
                            if (buttonIndex == 0)
                              graphInterval = "daily";
                            else if (buttonIndex == 1)
                              graphInterval = "weekly";
                            else if (buttonIndex == 2)
                              graphInterval = "monthly";
                            else
                              graphInterval = "yearly";
                            widget.isSelected[buttonIndex] = true;
                          } else {
                            widget.isSelected[buttonIndex] = false;
                          }
                        }
                      });
                    },
                    isSelected: widget.isSelected,
                  ),
                ],
              ),

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
                          subtitle: Text(
                              "\$" + widget.coin.low24h.toStringAsFixed(3))),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: Colors.deepPurple.shade900,
                      elevation: 2.0,
                      child: ListTile(
                        title: Text("24h High"),
                        subtitle:
                            Text("\$" + widget.coin.high24h.toStringAsFixed(3)),
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
                        subtitle: Text(
                            "\$" + widget.coin.average24h.toStringAsFixed(3)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: Colors.deepPurple.shade900,
                      elevation: 2.0,
                      child: ListTile(
                        title: Text("24h Volume"),
                        subtitle:
                            Text(widget.coin.volume24h.toStringAsFixed(3)),
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
