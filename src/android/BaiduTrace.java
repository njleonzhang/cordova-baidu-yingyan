package com.bsy.cordovaPlugin;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.graphics.Color;
import android.os.Handler;
import android.util.Log;
import android.util.SparseArray;

import com.baidu.trace.LBSTraceClient;
import com.baidu.trace.OnStartTraceListener;
import com.baidu.trace.OnStopTraceListener;
import com.baidu.trace.OnTrackListener;
import com.baidu.trace.Trace;
import com.baidu.trace.OnGeoFenceListener;
import com.baidu.trace.OnEntityListener;
import android.widget.Toast;

public class BaiduTrace extends CordovaPlugin {
    private LBSTraceClient client;
    private Trace trace;

    @Override
    public boolean execute(String action, JSONArray args, final CallbackContext callbackContext) throws JSONException {
        Log.i("leon", "插件调用");
        JSONObject options = new JSONObject();
        if (action.equals("startTrace")) {
            try {
                options = args.getJSONObject(0);
                Log.v("leon", options.toString());
            } catch (JSONException e) {
                Log.v("leon", "options 未传入");
            }
            Context ctx = cordova.getActivity().getApplicationContext();
            //实例化轨迹服务客户端
            client = new LBSTraceClient(ctx);
            //鹰眼服务ID
            long serviceId = options.getLong("serviceId"); //开发者创建的鹰眼服务ID
            //entity标识
            String entityName = options.getString("entityName");
            //轨迹服务类型（0 : 不上传位置数据，也不接收报警信息； 1 : 不上传位置数据，但接收报警信息；2 : 上传位置数据，且接收报警信息）
            int traceType = 2;

            //实例化轨迹服务
            trace = new Trace(ctx, serviceId, entityName, traceType);

            //实例化开启轨迹服务回调接口
            OnStartTraceListener startTraceListener = new OnStartTraceListener() {
                //开启轨迹服务回调接口（arg0 : 消息编码，arg1 : 消息内容，详情查看类参考）
                @Override
                public void onTraceCallback(int arg0, String arg1) {
                    // TODO Auto-generated method stub
                    showMessage("开启轨迹服务回调接口消息 [消息编码 : " + arg0 + "，消息内容 : " + arg1 + "]", Integer.valueOf(arg0));
                    if (0 == arg0 || 10006 == arg0 || 10008 == arg0) {
                    }
                }

                // 轨迹服务推送接口（用于接收服务端推送消息，arg0 : 消息类型，arg1 : 消息内容，详情查看类参考）
                @Override
                public void onTracePushCallback(byte arg0, String arg1) {
                    // TODO Auto-generated method stub
                    showMessage("轨迹服务推送接口消息 [消息类型 : " + arg0 + "，消息内容 : " + arg1 + "]", null);
                }
            };
            //开启轨迹服务
            client.startTrace(trace, startTraceListener);
            //return getCurrentPosition(options, callbackContext);
            return true;
        }
        if (action.equals("stopTraceListener")) {
            if (client == null || trace == null) {
                return false;
            }
            //实例化停止轨迹服务回调接口
            OnStopTraceListener stopTraceListener = new OnStopTraceListener() {
                // 轨迹服务停止成功
                @Override
                public void onStopTraceSuccess() {
                }

                // 轨迹服务停止失败（arg0 : 错误编码，arg1 : 消息内容，详情查看类参考）
                @Override
                public void onStopTraceFailed(int arg0, String arg1) {
                }
            };

            //停止轨迹服务
            client.stopTrace(trace, stopTraceListener);
        }
        return false;
    }

    private void showMessage(final String message, final Integer errorNo) {
        Toast.makeText(cordova.getActivity().getApplicationContext(), message, Toast.LENGTH_LONG).show();
    }
}
