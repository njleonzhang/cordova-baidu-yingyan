// baidu yingyan
var exec = require('cordova/exec');
var SERVICE_NAME = 'BaiduTrace';
var ACTION_START_TRACE = 'startTrace';
var ACTION_STOP_TRACE = 'stopTraceListener';

var baiduyingyan = {};

baiduyingyan.startTrace = function(success, error, entity) {
    exec(success, error, SERVICE_NAME, ACTION_START_TRACE, [entity]);
};
baiduyingyan.stopTraceListener = function(success, error, entity) {
    exec(success, error, SERVICE_NAME, ACTION_STOP_TRACE, [entity]);
};

module.exports = baiduyingyan;
