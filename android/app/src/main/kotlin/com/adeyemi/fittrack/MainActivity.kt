package com.adeyemi.fittrack
import android.app.*
import android.content.Context
import android.os.*
import androidx.core.app.NotificationCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.BinaryMessenger
import java.util.*

class MainActivity : FlutterActivity() {
    private val NOTIFICATION_ID = 101

    private val CHANNEL = "fittrack/sensors"
    private val CHANNEL_ID = "fittrack_channel"
    private val TIMER_CHANNEL = "fittrack/timer"

    private var handler: Handler? = null
    private var timer: Timer? = null
    private var stepCount = 0
    private var heartRate = 80
    private var isPaused = false

    private fun pauseTimer() {
        isPaused = true
    }
    private fun resumeTimer() {
        isPaused = false
    }
    private lateinit var messenger: BinaryMessenger

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        messenger = flutterEngine.dartExecutor.binaryMessenger

        MethodChannel(messenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startSensorSimulation" -> {
                    startSensorSimulation()
                    result.success("started")
                }
                "stopSensorSimulation" -> {
                    stopSensorSimulation()
                    result.success("stopped")
                }
                else -> result.notImplemented()
            }
        }
        MethodChannel(messenger, TIMER_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "pauseWorkout" -> {
                    pauseTimer()
                    result.success("paused")
                }
                "resumeWorkout" -> {
                    resumeTimer()
                    result.success("resumed")
                }
                "stopWorkout" -> {
                    stopSensorSimulation()
                    result.success("stopped")
                }
                else -> result.notImplemented()
            }
        }

        createNotificationChannel()
    }

    private fun startSensorSimulation() {
        handler = Handler(Looper.getMainLooper())
        timer = Timer()
        timer?.scheduleAtFixedRate(object : TimerTask() {
            override fun run() {
                if (isPaused) return
                stepCount += (1..5).random()
                heartRate = (70..130).random()

                if (stepCount % 100 < 2) {
                    showNotification("Great job!", "You've hit $stepCount steps!")
                }

                handler?.post {
                    MethodChannel(messenger, CHANNEL).invokeMethod(
                        "sensorUpdate",
                        mapOf("steps" to stepCount, "heartRate" to heartRate)
                    )
                }
            }
        }, 0, 1000)
    }

    private fun stopSensorSimulation() {
        isPaused = true
        timer?.cancel()
        timer = null
    }

    private fun showNotification(title: String, message: String) {
        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle(title)
            .setContentText(message)
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .build()
        val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        manager.notify(NOTIFICATION_ID, notification)
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = "FitTrack Sensor Channel"
            val desc = "Notifications for workout milestones"
            val importance = NotificationManager.IMPORTANCE_HIGH
            val channel = NotificationChannel(CHANNEL_ID, name, importance).apply {
                description = desc
            }
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel)
        }
    }
}
