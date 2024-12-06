package com.example.soletra_app


import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject


class MainActivity: FlutterActivity(){
    private val CHANNEL = "info.pos-mobile-flutter-utfpr/accelerometer"
    private lateinit var sensorManager: SensorManager
    private var accelerometer: Sensor? = null
    private var sensorEventListener: SensorEventListener? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "startAccelerometer") {
                startAccelerometer()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun startAccelerometer() {
        sensorManager = getSystemService(SENSOR_SERVICE) as SensorManager
        accelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)

        sensorEventListener = object : SensorEventListener {
            override fun onSensorChanged(event: SensorEvent?) {
                event?.let {
                    val json = JSONObject()
                    json.put("x", it.values[0])
                    json.put("y", it.values[1])
                    json.put("z", it.values[2])
                    json.put("timestamp", System.currentTimeMillis()) 

                    MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
                        .invokeMethod("updateAccelerometer", json.toString())
                }
            }

            override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
        }

        sensorManager.registerListener(sensorEventListener, accelerometer, SensorManager.SENSOR_DELAY_NORMAL)
    }

    override fun onDestroy() {
        super.onDestroy()
        sensorEventListener?.let {
            sensorManager.unregisterListener(it)
        }
    }
}
