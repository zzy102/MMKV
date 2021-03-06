/*
 * Tencent is pleased to support the open source community by making
 * MMKV available.
 *
 * Copyright (C) 2020 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the BSD 3-Clause License (the "License"); you may not use
 * this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 *       https://opensource.org/licenses/BSD-3-Clause
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:MMKVFlutter/mmkv.dart';

void main() {
  // MMKV.initialize();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {

    await MMKV.initialize();

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      funtionalTest();
    });
  }

  void funtionalTest() {
    var mmkv = MMKV("test");
    mmkv.encodeBool('bool', true);
    print('bool = ${mmkv.decodeBool('bool')}');

    mmkv.encodeInt32('int32', (1<<31) - 1);
    print('max int32 = ${mmkv.decodeInt32('int32')}');

    mmkv.encodeInt32('int32', 0 - (1<<31));
    print('min int32 = ${mmkv.decodeInt32('int32')}');

    mmkv.encodeInt('int', (1<<63) - 1);
    print('max int = ${mmkv.decodeInt('int')}');

    mmkv.encodeInt('int', 0 - (1<<63));
    print('min int = ${mmkv.decodeInt('int')}');

    mmkv.encodeDouble('double', double.maxFinite);
    print('max double = ${mmkv.decodeDouble('double')}');

    mmkv.encodeDouble('double', double.minPositive);
    print('min positive double = ${mmkv.decodeDouble('double')}');

    String str = 'Hello dart from MMKV';
    mmkv.encodeString('string', str);
    print('string = ${mmkv.decodeString('string')}');

    str += ' with bytes';
    var bytes = MMBuffer.fromList(Utf8Encoder().convert(str));
    mmkv.encodeBytes('bytes', bytes);
    bytes.destroy();
    bytes = mmkv.decodeBytes('bytes');
    print('bytes = ${Utf8Decoder().convert(bytes.asList())}');
    bytes.destroy();

    print('contains "bool": ${mmkv.containsKey('bool')}');
    mmkv.removeValue('bool');
    print('after remove, contains "bool": ${mmkv.containsKey('bool')}');
    mmkv.removeValues(['int32', 'int']);
    print('all keys: ${mmkv.allKeys()}');

    mmkv.trim();
    mmkv.clearMemoryCache();
    print('all keys: ${mmkv.allKeys()}');
    mmkv.clearAll();
    print('all keys: ${mmkv.allKeys()}');
    // mmkv.sync(true);
    // mmkv.close();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              // Text('Running on: $_platformVersion\n'),
            ]
          )
        ),
      ),
    );
  }
}
