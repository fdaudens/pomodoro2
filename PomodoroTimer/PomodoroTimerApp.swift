import SwiftUI

@main
struct PomodoroApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popover: NSPopover?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let statusButton = statusItem?.button {
            statusButton.image = NSImage(systemSymbolName: "timer", accessibilityDescription: "Pomodoro Timer")
            statusButton.action = #selector(togglePopover)
        }
        
        popover = NSPopover()
        popover?.contentSize = NSSize(width: 300, height: 300)
        popover?.behavior = .transient
        popover?.contentViewController = NSHostingController(rootView: ContentView())
    }
    
    @objc func togglePopover() {
        if let popover = popover {
            if popover.isShown {
                popover.performClose(nil)
            } else {
                if let statusBarButton = statusItem?.button {
                    popover.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: .minY)
                }
            }
        }
    }
}

struct ContentView: View {
    @StateObject private var timerManager = TimerManager()
    
    var body: some View {
        VStack(spacing: 20) {
            Text(timerManager.timeString)
                .font(.system(size: 48, weight: .bold, design: .rounded))
            
            HStack(spacing: 20) {
                Button(action: timerManager.startPause) {
                    Text(timerManager.isRunning ? "Pause" : "Start")
                        .frame(width: 80)
                }
                
                Button(action: timerManager.reset) {
                    Text("Reset")
                        .frame(width: 80)
                }
            }
            
            HStack(spacing: 10) {
                Button(action: { timerManager.setMode(.pomodoro) }) {
                    Text("Pomodoro")
                }
                .background(timerManager.currentMode == .pomodoro ? Color.blue : Color.clear)
                .foregroundColor(timerManager.currentMode == .pomodoro ? .white : .blue)
                
                Button(action: { timerManager.setMode(.shortBreak) }) {
                    Text("Short Break")
                }
                .background(timerManager.currentMode == .shortBreak ? Color.blue : Color.clear)
                .foregroundColor(timerManager.currentMode == .shortBreak ? .white : .blue)
                
                Button(action: { timerManager.setMode(.longBreak) }) {
                    Text("Long Break")
                }
                .background(timerManager.currentMode == .longBreak ? Color.blue : Color.clear)
                .foregroundColor(timerManager.currentMode == .longBreak ? .white : .blue)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
    }
}
