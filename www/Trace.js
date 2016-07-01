// baidu yingyan
var exec = require('cordova/exec');
var SERVICE_NAME = 'BaiduTrace';
var ACTION_START_TRACE = 'startTrace';
var ACTION_STOP_TRACE = 'stopTrace';
var ACTION_SET_INTERVAL = 'setInterval';
var ACTION_SET_LOCATION_MODE = 'setLocationMode';
var ACTION_SET_PROTOCOL_TYPE = 'setProtocolType';

var baiduTrace = {};

// Returns a jQuery or AngularJS deferred object, or pass a success and fail callbacks if you don't want to use jQuery or AngularJS
var getPromisedCordovaExec = function (command, entity, success, fail) {
  var toReturn, deferred, injector, $q;
  if (success === undefined) {
    if (window.jQuery) {
      deferred = jQuery.Deferred();
      success = deferred.resolve;
      fail = deferred.reject;
      toReturn = deferred;
    } else if (window.angular) {
      injector = angular.injector(["ng"]);
      $q = injector.get("$q");
      deferred = $q.defer();
      success = deferred.resolve;
      fail = deferred.reject;
      toReturn = deferred.promise;
    } else if (window.Promise) {
      toReturn = new Promise(function(c, e) {
        success = c;
        fail = e;
      });
    } else if (window.WinJS && window.WinJS.Promise) {
      toReturn = new WinJS.Promise(function(c, e) {
        success = c;
        fail = e;
      });
    } else {
      return console.error('AppVersion either needs a success callback, or jQuery/AngularJS/Promise/WinJS.Promise defined for using promises');
    }
  }

  cordova.exec(success, fail, SERVICE_NAME, command, [entity]);
  return toReturn;
};

baiduTrace.startTrace = function(entityName, serviceId, operationMode, customAttr, success, fail) {
  var entity = {
    entityName: entityName,
    serviceId: serviceId,
    operationMode: operationMode,
    customAttr: customAttr
  }
  return getPromisedCordovaExec(ACTION_START_TRACE, entity, success, fail);
};
baiduTrace.stopTrace = function(success, fail) {
  return getPromisedCordovaExec(ACTION_STOP_TRACE, {}, success, fail);
};
baiduTrace.setInterval = function(gatherInterval, packInterval, success, fail) {
  var entity = {
    'gatherInterval': gatherInterval,
    'packInterval': packInterval
  };
  return getPromisedCordovaExec(ACTION_SET_INTERVAL, entity, success, fail);
};

baiduTrace.setLocationMode = function(mode, success, fail) {
  var entity = {
    'locationMode': mode
  };
  return getPromisedCordovaExec(ACTION_SET_LOCATION_MODE, entity, success, fail);
};

baiduTrace.setProtocolType = function(type, success, fail) {
  var entity = {
    'protocolType': type
  };
  return getPromisedCordovaExec(ACTION_SET_PROTOCOL_TYPE, entity, success, fail);
};

module.exports = baiduTrace;
