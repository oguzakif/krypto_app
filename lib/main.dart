import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:krypto_app/info.dart';
import './stores.dart';
import 'coindetailpage.dart';


void main() {
  runApp(DashBoard());
}

class DashBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Krypto App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white10,
        brightness: Brightness.dark,
        fontFamily: 'Poppins',
      ),
      home: HomeScreen(),
    );
  }
}


class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with StoreWatcherMixin<HomeScreen> {
  int _currentIndex = 0;
  
  CoinStore store;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    store = listenToStore(coinStoreToken);
    Timer.periodic(Duration(seconds: 3), (_) => loadCoinsAction.call());
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget coinList(int currentIndex){
    if(currentIndex == 0)
    return ListView(
        children: store.coins.map((coin) => CoinWidget(coin)).toList(),
    );
    else
    return InfoPage();
  }

  @override
  Widget build(BuildContext contenxt) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Krypto App'),
      ),
      body: coinList(_currentIndex), /*ListView(
        children: store.coins.map((coin) => CoinWidget(coin)).toList(),
      ),*/
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.deepPurple.shade900,
        backgroundColor: Colors.black45,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.coins),
            label: 'Coin List',
          ),
          new BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.info),
            label: 'About Us',
          ),
        ],
      ),
    );
  }
  
}

class CoinWidget extends StatefulWidget {
  CoinWidget(this.coin);
  Coin coin;

  @override
  _CoinWidgetState createState() => _CoinWidgetState();
}

class _CoinWidgetState extends State<CoinWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.0),
      decoration: BoxDecoration(border: Border.all(width: 10.0)),
      child: Card(
        elevation: 5.0,
        color: Colors.deepPurple.shade900,
        child: Row(children: <Widget>[
          Expanded(
              child: ListTile(
            title: Text(widget.coin.name),
            leading: CircleAvatar(
              child: Image.asset(
                  'assets/coin-icons/' + widget.coin.id.toLowerCase() + '.png'),
            ),
            subtitle: Text(widget.coin.id + "/USDT"),
            trailing: Wrap(children: <Widget>[
              Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Icon(
                    widget.coin.oneDayChanges.price_change_pct > 0
                        ? Icons.arrow_drop_up_rounded
                        : Icons.arrow_drop_down_rounded,
                    size: 34,
                    color: widget.coin.oneDayChanges.price_change_pct > 0
                        ? Colors.lightGreenAccent[400]
                        : Colors.deepOrangeAccent[700]),
              ]),
              Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text("\$${widget.coin.priceUSD.toStringAsFixed(2)}"),
                Text(
                    (widget.coin.oneDayChanges.price_change_pct * 100)
                            .toStringAsFixed(2) +
                        "%",
                    style: TextStyle(
                        color: widget.coin.oneDayChanges.price_change_pct > 0
                            ? Colors.lightGreenAccent[400]
                            : Colors.deepOrangeAccent[700])),
              ]),
            ]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return CoinScreenIn(widget.coin);
                }),
              );
            },
          )),
        ]),
      ),
    );
  }
}
