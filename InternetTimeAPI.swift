//
//  InternetTimeAPI.swift
//  InternetTime
//
//  Created by Cavan Farrell on 3/11/19.
//  Copyright © 2019 Cavan Farrell. All rights reserved.
//

import Foundation

class InternetTimeAPI {
    static func fetchTime() -> String {
        let utcTime = Date()
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        let components = Calendar.current.component(.hour, from: utcTime)
        
        var hours = calendar.component(.hour, from: utcTime)
        let minutes = calendar.component(.minute, from: utcTime)
        let seconds = calendar.component(.second, from: utcTime)
        
        hours = (hours == 23) ? 0 : hours + 1
        
        let timeInSeconds = (((hours * 60) + minutes) * 60) + seconds
        let secondsInABeat = 86.4
        
        let beats = Int(abs(Double(timeInSeconds)/secondsInABeat))
        
        return String(beats)
    }
}
