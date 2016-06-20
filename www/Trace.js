// baidu yingyan
var exec = require('cordova/exec');
var SERVICE_NAME = 'BaiduTrace';
var ACTION_START_TRACE = 'startTrace';
var ACTION_STOP_TRACE = 'stopTraceListener';

var baiduyingyan = {};

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

baiduyingyan.startTrace = function(entity, success, fail) {
  return getPromisedCordovaExec(ACTION_START_TRACE, entity, success, fail);
};
baiduyingyan.stopTraceListener = function(entity, success, fail) {
  return getPromisedCordovaExec(ACTION_STOP_TRACE, entity, success, fail);
};

module.exports = baiduyingyan;
