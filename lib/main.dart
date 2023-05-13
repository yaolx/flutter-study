import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '计时器',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '计时器'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Container(
            width: 500,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                color: Colors.black,
                width: 1.0,
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              // 水平居中
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const TabChoice(),
                const Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const FooterButton(),
              ],
            ),
          ),
        ));
  }
}

// ============计时器、倒计时tab切换组件 start
class TabChoice extends StatefulWidget {
  const TabChoice({super.key});
  @override
  State<TabChoice> createState() => _TabChoiceState();
}

enum Tab { timer, countdown }

class _TabChoiceState extends State<TabChoice> {
  Tab activeTab = Tab.timer;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<Tab>(
      segments: const <ButtonSegment<Tab>>[
        ButtonSegment(value: Tab.timer, label: Text('计时器')),
        ButtonSegment(value: Tab.countdown, label: Text('倒计时')),
      ],
      selected: <Tab>{activeTab},
      onSelectionChanged: (Set<Tab> newSelection) {
        setState(() {
          activeTab = newSelection.first;
        });
      },
    );
  }
}

// ============计时器、倒计时tab切换组件 end

// ============点击按钮 start

class FooterButton extends StatefulWidget {
  const FooterButton({super.key});
  @override
  State<FooterButton> createState() => _FooterButtonState();
}

class _FooterButtonState extends State<FooterButton> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        // 水平居中
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: OutlinedButton(
              onPressed: () {
                debugPrint('Received click');
              },
              child: const Text('重置'),
            ),
          ),
          OutlinedButton(
            onPressed: () {
              debugPrint('Received click');
            },
            child: const Text('开始'),
          )
        ],
      ),
    );
  }
}

// ============点击按钮 end