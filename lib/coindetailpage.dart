import 'package:flutter/material.dart';
import './stores.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class CoinScreenIn extends StatefulWidget {
  CoinScreenIn(this.coin);
  Coin coin;
  List<bool> isSelected = [true, false, false, false];
  @override
  _CoinScreenState createState() => _CoinScreenState();
}

class DataPoint {
  double value;
  DateTime date;

  DataPoint(double value, String date, String interval) {
    this.value = value;
    this.date = DateTime.parse(date);
  }
}

class _CoinScreenState extends State<CoinScreenIn> {
  final coinController = TextEditingController();
  final usdController = TextEditingController();
  String graphInterval = "daily";


  List<DataPoint> getGraphData() {
    List<DataPoint> graphData = [];
    List<double> price = priceParser();
    List<String> date = getDate();
    for (int i = 0; i < price.length; i++)
      graphData.add(new DataPoint(price[i], date[i], graphInterval));

    return graphData;
  }

  List<double> priceParser() {
    List<double> list = [];
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
    } else if(graphInterval == "yearly"){
      for (String i in widget.coin.sparklineYearly.prices) {
        list.add(double.parse(i));
      }
      return list;
    }
  }

  DateTimeAxis getXaxis(String interval){
    if(interval == "daily"){
      return DateTimeAxis(
          intervalType: DateTimeIntervalType.hours,
                            interval: 2);
    }
    else if(interval == "weekly"){
      return DateTimeAxis(
          intervalType: DateTimeIntervalType.days,
                            interval: 1);
    }
    else if(interval == "monthly"){
      return DateTimeAxis(
          intervalType: DateTimeIntervalType.days,
                            interval: 4);
    }
    else if(interval == "yearly"){
      return DateTimeAxis(
          intervalType: DateTimeIntervalType.months,
                            interval: 2);
    }
  }
  List<String> getDate() {
    List<String> list = [];
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
    } else if(graphInterval == "yearly"){
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
        primaryXAxis: getXaxis(interval),
        primaryYAxis: NumericAxis(),
        // Chart title
        title: ChartTitle(text: interval[0].toUpperCase()+interval.substring(1) + " " + widget.coin.name + " Chart"),
        // Enable legend
        //legend: Legend(isVisible: true),
        // Enable tooltip

        //tooltipBehavior: TooltipBehavior(enable: true),
        crosshairBehavior: CrosshairBehavior(enable: true),
        series: <ChartSeries<DataPoint, DateTime>>[
          LineSeries<DataPoint, DateTime>(
              dataSource: getGraphData(),
              xValueMapper: (DataPoint point, _) => point.date.toLocal(),
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
                          child: Image.asset('assets/coin-icons/'+widget.coin.id.toLowerCase()+'.png')
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
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderColor: Colors.deepPurple.shade900,
                    fillColor: Colors.deepPurple.shade900,
                    selectedColor: Colors.white,
                    selectedBorderColor: Colors.deepPurple.shade900,
                    borderWidth: 2,
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
                            else if(buttonIndex == 3)
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
