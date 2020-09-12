// Flutter code sample for StreamBuilder

// This sample shows a [StreamBuilder] that listens to a Stream that emits bids
// for an auction. Every time the StreamBuilder receives a bid from the Stream,
// it will display the price of the bid below an icon. If the Stream emits an
// error, the error is displayed below an error icon. When the Stream finishes
// emitting bids, the final price is displayed.

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  Stream<int> _bids = (() async* {
    await Future<void>.delayed(Duration(seconds: 1));
    yield 1;
    await Future<void>.delayed(Duration(seconds: 1));
  })();

  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline2,
      textAlign: TextAlign.center,
      child: Container(
        alignment: FractionalOffset.center,
        color: Colors.white,
        child: StreamBuilder<int>(
          stream: _bids,
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            List<Widget> children;
            if (snapshot.hasError) {
              children = <Widget>[
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                )
              ];
            } else {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  children = <Widget>[
                    Icon(
                      Icons.info,
                      color: Colors.blue,
                      size: 60,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Select a lot'),
                    )
                  ];
                  break;
                case ConnectionState.waiting:
                  children = <Widget>[
                    SizedBox(
                      child: const CircularProgressIndicator(),
                      width: 60,
                      height: 60,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Awaiting bids...'),
                    )
                  ];
                  break;
                case ConnectionState.active:
                  children = <Widget>[
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('\$${snapshot.data}'),
                    )
                  ];
                  break;
                case ConnectionState.done:
                  children = <Widget>[
                    Icon(
                      Icons.info,
                      color: Colors.blue,
                      size: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('\$${snapshot.data} (closed)'),
                    )
                  ];
                  break;
              }
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            );
          },
        ),
      ),
    );
  }
}
