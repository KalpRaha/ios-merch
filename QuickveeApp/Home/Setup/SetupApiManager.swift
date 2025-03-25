//
//  SetupApiManager.swift
//  
//
//  Created by Jamaluddin Syed on 14/04/23.
//

import Foundation

class SetupApiManager {
    
    static let shared = SetupApiManager()
    
    
    func getDateTime(tag: Int) {
        
        var startDate = ""
        var endDate = ""
        
        let date = Date()
        let calendar = Calendar.current
        let df = DateFormatter()
        df.timeZone = TimeZone.current
        
        switch tag {
            
        case 1: //Today
            df.dateFormat = "yyyy-MM-dd"
            startDate = "\(df.string(from: date)) 00:00:00"
            df.dateFormat = "yyyy-MM-dd hh:mm:ss"
            endDate = df.string(from: date)
            print("\(startDate) \(endDate)")
            break
        case 2: //yesterday
            df.dateFormat = "yyyy-MM-dd"
            let ydate = calendar.date(byAdding: .day, value: -1, to: date)
            startDate = "\(df.string(from: ydate!)) 00:00:00"
            endDate = "\(df.string(from: ydate!)) 23:59:59"
            print("\(startDate) \(endDate)")
            break
        case 3: //last 7 days
            df.dateFormat = "yyyy-MM-dd"
            let ydate = calendar.date(byAdding: .day, value: -6, to: date)
            startDate = "\(df.string(from: ydate!)) 00:00:00"
            endDate = "\(df.string(from: date)) 23:59:59"
            print("\(startDate) \(endDate)")
            break
        case 4 : //this month
            df.dateFormat = "yyyy-MM"
            print("\(df.string(from: date))-01 00:00:00")
            startDate = "\(df.string(from: date))-01 00:00:00"
            df.dateFormat = "yyyy-MM-dd hh:mm:ss"
            print(df.string(from: date))
            endDate = df.string(from: date)
            print("\(startDate) \(endDate)")
            break
        default:
            print("")
        }
    }
    
    
    
}
