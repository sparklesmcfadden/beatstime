//
//  ConvertWindow.swift
//  InternetTime
//
//  Created by Cavan Farrell on 3/19/19.
//  Copyright © 2019 Cavan Farrell. All rights reserved.
//

import Cocoa

class ConvertWindow: NSWindowController {
    
    override var windowNibName: String! {
        return "ConvertWindow"
    }
    
    var outputTime = "000"
    
    @IBOutlet weak var fromTime: NSTextField!
    @IBOutlet weak var internetTimeLabel: NSTextField!
    @IBOutlet weak var warningLabel: NSTextField!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        setDefaults()
        setTimeLabel()
        
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    @IBAction func convertButtonClicked(_ sender: Any) {
        setTimeLabel()
    }
    
    func setTimeLabel() {
        if (fromTime.stringValue.isEmpty) {
            outputTime = "---"
            warningLabel.stringValue = "Check inputs!"
        }
        else {
            let inputTimeZone = TimeZone.current.identifier
            
            outputTime = computeInputTime(inputTime: fromTime.stringValue, inputTimeZone: inputTimeZone)
        }
        internetTimeLabel.stringValue = "@\(outputTime)"
    }
    
    func setDefaults() {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        fromTime.stringValue = "\(String(format: "%02d", arguments: [hour])):\(String(format: "%02d", arguments: [minutes]))"
        internetTimeLabel.stringValue = "@\(outputTime)"
    }
    
    func computeInputTime(inputTime: String, inputTimeZone: String) -> String {
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "HH:mm"
        
        let convertedTime = localToUTC(time: inputTime)
        if (convertedTime == "000") {
            return "---"
        }
        
        let timeFromString = timeFormat.date(from: localToUTC(time: inputTime))!
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: inputTimeZone)!
        
        var hours = calendar.component(.hour, from: timeFromString)
        let minutes = calendar.component(.minute, from: timeFromString)
        let seconds = calendar.component(.second, from: timeFromString)
        
        hours = (hours == 23) ? 0 : hours + 1
        
        let timeInSeconds = (((hours * 60) + minutes) * 60) + seconds
        let secondsInABeat = 86.4
        
        let beats = Int(abs(Double(timeInSeconds)/secondsInABeat))
        return String(format: "%03d", arguments: [beats])
    }
    
    func localToUTC(time: String) -> String {
        let utcDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current
        let date = dateFormatter.string(from: utcDate)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        timeFormatter.calendar = NSCalendar.current
        timeFormatter.timeZone = TimeZone.current
        
        let dt = timeFormatter.date(from: "\(date) \(time)")
        timeFormatter.timeZone = TimeZone(abbreviation: "UTC")
        timeFormatter.dateFormat = "HH:mm"
        
        if (dt == nil) {
            warningLabel.stringValue = "Invalid time entered"
            return "000"
        }
        
        warningLabel.stringValue = ""
        return timeFormatter.string(from: dt!)
    }
}
