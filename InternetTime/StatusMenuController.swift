//
//  StatusMenuController.swift
//  InternetTime
//
//  Created by Cavan Farrell on 3/11/19.
//  Copyright © 2019 Cavan Farrell. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    var convertWindow: ConvertWindow!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    @IBAction func quitClicked(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
    override func awakeFromNib() {
        convertWindow = ConvertWindow()
        statusItem.menu = statusMenu
        
        let icon = NSImage(named: "statusIcon")
        statusItem.button!.image = icon
        statusItem.button!.imagePosition = NSControl.ImagePosition.imageLeft;
        statusItem.menu = statusMenu
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
            self.statusItem.button!.title = self.computeCurrentTime()
        }
    }
    
    @IBAction func convertClicked(_ sender: Any) {
        convertWindow.showWindow(nil)
    }
    
    func computeCurrentTime() -> String {
        let utcTime = Date()
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        var hours = calendar.component(.hour, from: utcTime)
        let minutes = calendar.component(.minute, from: utcTime)
        let seconds = calendar.component(.second, from: utcTime)
        
        hours = (hours == 23) ? 0 : hours + 1
        
        let timeInSeconds = (((hours * 60) + minutes) * 60) + seconds
        let secondsInABeat = 86.4
        
        let beats = Int(abs(Double(timeInSeconds)/secondsInABeat))
        return String(format: "%03d", arguments: [beats])
    }
}
