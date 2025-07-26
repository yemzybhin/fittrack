import UIKit
import Flutter
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  var stepCount = 0
  var heartRate = 75
  var isPaused = false
  var timer: Timer?
  var notificationThreshold = 100
  var lastNotificationStep = 0

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window.rootViewController as! FlutterViewController
    let sensorChannel = FlutterMethodChannel(name: "fittrack/sensors", binaryMessenger: controller.binaryMessenger)
    let timerChannel = FlutterMethodChannel(name: "fittrack/timer", binaryMessenger: controller.binaryMessenger)

    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      if granted {
        print("✅ Notification permission granted.")
      } else {
        print("❌ Notification permission denied.")
      }
    }

    sensorChannel.setMethodCallHandler { [weak self] (call, result) in
      guard let self = self else { return }

      if call.method == "startSensorSimulation" {
        self.startSensorSimulation(channel: sensorChannel)
        result("started")
      } else if call.method == "stopSensorSimulation" {
        self.stopSimulation()
        result("stopped")
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    timerChannel.setMethodCallHandler { [weak self] (call, result) in
      guard let self = self else { return }

      switch call.method {
        case "pauseWorkout":
          self.isPaused = true
          result("paused")
        case "resumeWorkout":
          self.isPaused = false
          result("resumed")
        case "stopWorkout":
          self.stopSimulation()
          result("stopped")
        default:
          result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func startSensorSimulation(channel: FlutterMethodChannel) {
    stepCount = 0
    heartRate = 75
    lastNotificationStep = 0
    isPaused = false

    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
      guard let self = self else { return }
      if self.isPaused { return }

      self.stepCount += Int.random(in: 2...10)
      self.heartRate = Int.random(in: 70...130)

      let update: [String: Any] = [
        "steps": self.stepCount,
        "heartRate": self.heartRate
      ]
      channel.invokeMethod("sensorUpdate", arguments: update)
      if self.stepCount - self.lastNotificationStep >= self.notificationThreshold {
        self.lastNotificationStep = self.stepCount
        self.sendNotification(
          title: "Great job!",
          message: "You've hit \(self.stepCount) steps!"
        )
      }
    }
  }

  private func stopSimulation() {
    timer?.invalidate()
    timer = nil
    stepCount = 0
    heartRate = 75
    isPaused = true
    lastNotificationStep = 0
  }

  private func sendNotification(title: String, message: String) {
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = message
    content.sound = UNNotificationSound.default

    let request = UNNotificationRequest(
      identifier: UUID().uuidString,
      content: content,
      trigger: nil
    )

    UNUserNotificationCenter.current().add(request) { error in
      if let error = error {
        print("Notification error: \(error)")
      }
    }
  }
}
