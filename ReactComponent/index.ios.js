/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import codePush from "react-native-code-push";
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  Image
} from 'react-native';

var Dimensionsss = require('Dimensions')
var {width, height, scale} = Dimensionsss.get('window')
var TimerMixin = require('react-timer-mixin');

var RNInterface = require('react-native').NativeModules.RNInterface;  //  通过OC的桥接文件类名获取到这个类

let HelloRN = React.createClass({
  mixins: [TimerMixin],

  componentDidMount(){
      codePush.sync();
  },
  render() {
    this.setTimeout(
      () => { this._setupMainView(); }, 1
    );
    return (
      <View style = {styles.container}>
        <Image source = {require('./img/welcomCat.jpg')}
               style = {[{width: width, height: height}, {resizeMode: 'stretch'}]}
          />
      </View>
    );
  },
  _setupMainView() {
    RNInterface.sendMessage('{\"msgType":\"callKnowledgeList\"}')
  }
});

const styles = StyleSheet.create({
  container:{
    flex:1,
    backgroundColor:'rgb(168,143,107)',
    justifyContent:'center',
    alignItems:'center'
  }
})

AppRegistry.registerComponent('HelloRN', () => HelloRN);
