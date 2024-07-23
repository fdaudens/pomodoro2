import Foundation

class TimerManager: ObservableObject {
    @Published var timeRemaining: Int
    @Published var isRunning = false
    @Published var currentMode: TimerMode = .pomodoro
    
    var timer: Timer?
    
    init() {
        self.timeRemaining = 25 * 60 // 25 minutes for Pomodoro
    }
    
    var timeString: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func startPause() {
        if isRunning {
            pauseTimer()
        } else {
            startTimer()
        }
    }
    
    func startTimer() {
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.pauseTimer()
                self.sendNotification()
            }
        }
    }
    
    func pauseTimer() {
        isRunning = false
        timer?.invalidate()
    }
    
    func reset() {
        pauseTimer()
        setMode(currentMode)
    }
    
    func setMode(_ mode: TimerMode) {
        currentMode = mode
        switch mode {
        case .pomodoro:
            timeRemaining = 25 * 60
        case .shortBreak:
            timeRemaining = 5 * 60
        case .longBreak:
            timeRemaining = 15 * 60
        }
    }
    
    func sendNotification() {
        let notification = NSUserNotification()
        notification.title = "Pomodoro Timer"
        notification.informativeText = "Time's up! Take a break."
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.deliver(notification)
    }
}

enum TimerMode {
    case pomodoro
    case shortBreak
    case longBreak
}
