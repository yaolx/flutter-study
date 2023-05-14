import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

// timer 计时器，countdown 倒计时
enum Tab { timer, countdown }

// 秒数格式转换成mm:ss
String getFormattedTime(int seconds) {
  var d = Duration(seconds: seconds);
  return d.toString().substring(2, 7);
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
  // 计时器秒数
  int _counter = 0;
  // 秒数转换后的时间
  String _timeText = '00:00';
  // 右边按钮名称
  String _rightBtnText = '开始';
  // true 暂停；false 播放
  bool _isPause = true;
  // tab切换
  Tab _tab = Tab.timer;
  // 计时器对象
  late Timer _timer;
  // 开始
  void _startTimer() {
    const period = Duration(seconds: 1);
    _timer = Timer.periodic(period, (timer) {
      //更新界面
      setState(() {
        if (_tab == Tab.timer) {
          _counter++;
        } else {
          _counter--;
        }
        _timeText = getFormattedTime(_counter);
      });
    });
  }

  // 重置时间
  void resetTime(tabType) {
    setState(() {
      if (tabType == Tab.timer) {
        _counter = 0;
      } else {
        _counter = 3599;
      }
      _timeText = getFormattedTime(_counter);
      _rightBtnText = '开始';
    });
    _isPause = true;
  }

  // 取消定时器
  void _cancelTimer() {
    _timer.cancel();
  }

  // 点击开始或者暂停
  void _onPlay([type]) {
    // 重置
    if (type == -1) {
      _cancelTimer();
      resetTime(_tab);
      _isPause = true;
    } else {
      // 开始
      if (_isPause) {
        _startTimer();
        setState(() {
          _rightBtnText = '暂停';
        });
        _isPause = false;
      } else {
        // 暂停
        _cancelTimer();
        setState(() {
          _rightBtnText = '开始';
        });
        _isPause = true;
      }
    }
  }

  // 切换tab
  void _onChangeTab(Tab newValue) {
    setState(() {
      _tab = newValue;
    });
    resetTime(newValue);
    _cancelTimer();
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
                TabChoice(
                  onChangeTab: _onChangeTab,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Text(
                    _timeText,
                  ),
                ),
                FooterButton(play: _onPlay, rightBtnText: _rightBtnText),
              ],
            ),
          ),
        ));
  }
}

// ============计时器、倒计时tab切换组件 start
class TabChoice extends StatefulWidget {
  const TabChoice({
    super.key,
    required this.onChangeTab,
  });

  final void Function(Tab value) onChangeTab;

  @override
  State<TabChoice> createState() => _TabChoiceState();
}

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
          widget.onChangeTab(activeTab);
        });
      },
    );
  }
}

// ============计时器、倒计时tab切换组件 end

// ============点击按钮 FooterButton  无状态组件

class FooterButton extends StatelessWidget {
  const FooterButton(
      {super.key, required this.play, required this.rightBtnText});

  final String rightBtnText;
  // mode：-1表示重置
  final void Function([int mode]) play;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        // 水平居中
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(
                  width: 1,
                  color: Colors.blue,
                ),
              ),
              onPressed: () {
                play(-1);
              },
              child: const Text(
                '重置',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          FilledButton(
            onPressed: () {
              play();
            },
            child: Text(rightBtnText),
          )
        ],
      ),
    );
  }
}

// ============点击按钮 end