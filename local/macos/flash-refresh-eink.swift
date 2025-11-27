#!/usr/bin/swift

// Required parameters:
// @raycast.schemaVersion 1
// @raycast.title Flash Refresh Eink
// @raycast.mode silent

// Optional parameters:
// @raycast.icon 🕊️

import Cocoa

let app = NSApplication.shared

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        let targetName = ProcessInfo.processInfo.environment["EINK_DISPLAY_NAME"] ?? "EINK"
        var targetDisplayID: CGDirectDisplayID? = nil
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/sbin/system_profiler")
        process.arguments = ["SPDisplaysDataType", "-json"]
        let pipe = Pipe()
        process.standardOutput = pipe
        do {
            try process.run()
            process.waitUntilExit()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let displays = json["SPDisplaysDataType"] as? [[String: Any]] {
                for display in displays {
                    if let spdisplays = display["spdisplays_ndrvs"] as? [[String: Any]] {
                        for ndrv in spdisplays {
                            if let name = ndrv["_name"] as? String, name == targetName,
                               let idStr = ndrv["_spdisplays_displayID"] as? String,
                               let id = UInt32(idStr) {
                                targetDisplayID = id
                                break
                            }
                        }
                    }
                    if targetDisplayID != nil { break }
                }
            }
        } catch {
            // ignore
        }
        guard let targetID = targetDisplayID else {
            print("Display '\(targetName)' not found")
            app.terminate(nil)
            return
        }
        var targetScreen: NSScreen? = nil
        for screen in NSScreen.screens {
            if let desc = screen.deviceDescription as? [AnyHashable: Any],
               let screenNumber = desc["NSScreenNumber"] as? NSNumber,
               screenNumber.uint32Value == targetID {
                targetScreen = screen
                break
            }
        }
        guard let screen = targetScreen else {
            print("EINK display not found")
            app.terminate(nil)
            return
        }
        let screenFrame = screen.frame
        let window = NSWindow(contentRect: screenFrame, styleMask: [.borderless], backing: .buffered, defer: false)
        window.backgroundColor = .white
        window.level = .screenSaver
        window.makeKeyAndOrderFront(nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            window.close()
            app.terminate(nil)
        }
    }
}

let delegate = AppDelegate()
app.delegate = delegate
app.run()

