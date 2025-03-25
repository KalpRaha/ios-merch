//
//  APIManager.swift
//  
//
//  Created by Jamaluddin Syed on 27/01/23.
//

import Foundation
import Alamofire

class APIManager {
    
    static let shared = APIManager()
    var responseArray: [String:Any]?
    var tag: Int?
    
    private init() {}
    
    func getApiCallData(tag: Int) -> [String] {
        self.tag = tag
        return getDateTime()
    }
    
    func selectFilter(tag : Int) -> Int {
        
        if tag == 1 {
            return UserDefaults.standard.integer(forKey: "dateTimeFilter_sales")
        }
        else if tag == 2 {
            return UserDefaults.standard.integer(forKey: "dateTimeFilter_item")
        }
        else if tag == 3 {
            return UserDefaults.standard.integer(forKey: "dateTimeFilter_order")
        }
        else {
            return UserDefaults.standard.integer(forKey: "dateTimeFilter_taxes")
        }
    }
  
    func getDateTime() -> [String] {
        
        var startDate = ""
        var endDate = ""
        
        let date = Date()
        let calendar = Calendar.current
        let df = DateFormatter()
        df.timeZone = TimeZone.current
        
        switch selectFilter(tag: tag!) {
            
        case 101: //Today
            df.dateFormat = "yyyy-MM-dd"
            startDate = "\(df.string(from: date))"
            df.dateFormat = "yyyy-MM-dd"
            endDate = "\(df.string(from: date))"
            print("\(startDate) \(endDate)")
            break
        case 102: //yesterday
            df.dateFormat = "yyyy-MM-dd"
            let ydate = calendar.date(byAdding: .day, value: -1, to: date)
            startDate = "\(df.string(from: ydate!))"
            endDate = "\(df.string(from: ydate!))"
            print("\(startDate) \(endDate)")
            break
        case 103: //last 7 days
            df.dateFormat = "yyyy-MM-dd"
            let ydate = calendar.date(byAdding: .day, value: -7, to: date)
            startDate = "\(df.string(from: ydate!))"
            endDate = "\(df.string(from: date))"
            print("\(startDate) \(endDate)")
            break
        case 104 : //this month
            df.dateFormat = "yyyy-MM"
            print("\(df.string(from: date))-01")
            startDate = "\(df.string(from: date))-01"
            df.dateFormat = "yyyy-MM-dd"
            print(df.string(from: date))
            endDate = "\(df.string(from: date))"
            print("\(startDate) \(endDate)")
            break
        case 105: //custom
            startDate = "\(UserDefaults.standard.string(forKey: "custom_start_date") ?? "")"
            endDate = "\(UserDefaults.standard.string(forKey: "custom_end_date") ?? "")"
            print(startDate)
            print(endDate)
            print("")
            break
        default:
            df.dateFormat = "yyyy-MM-dd"
            startDate = "\(df.string(from: date))"
            df.dateFormat = "yyyy-MM-dd"
            endDate = "\(df.string(from: date))"
            print("\(startDate) \(endDate)")
        }
        return getMoreParameters(startDate: startDate, endDate: endDate)
    }
    
    func getMonthEndingDate(month: Int, year: Int) -> String {
        
        if month == 4 || month == 6 || month == 9 || month == 11 {
            return "30"
        }
        
        else if month == 2 && year % 4 == 0 {
            return "29"
        }
        
        else if month == 2 {
            return "28"
        }
        
        else {
            return "31"
        }
    }
    
    func getMoreParameters(startDate: String, endDate: String) -> [String] {
        var orderSource = ""
        var orderType = ""
        var category = ""
        print(startDate)
        print(endDate)
        if tag == 1 {
            orderSource = UserDefaults.standard.string(forKey: "orderSource_sales")!
            orderType = UserDefaults.standard.string(forKey: "orderType_sales")!
        }
        else if tag == 2 {
            orderSource = UserDefaults.standard.string(forKey: "orderSource_item")!
            orderType = UserDefaults.standard.string(forKey: "orderType_item")!
            category = UserDefaults.standard.string(forKey: "category_item")!
        }
        else if tag == 3 {
            orderSource = UserDefaults.standard.string(forKey: "orderSource_order")!
        }
        else {
            orderSource = UserDefaults.standard.string(forKey: "orderSource_taxes")!
            orderType = UserDefaults.standard.string(forKey: "orderType_taxes")!
        }
        var parameters = [String]()
        parameters.append(startDate)
        parameters.append(endDate)
        
        switch tag {
            
        case 1:
            parameters.append(orderSource)
            parameters.append(orderType)
            let id = UserDefaults.standard.string(forKey: "merchant_id")
            parameters.append(id!)
            break
        case 2:
            parameters.append(orderSource)
            parameters.append(orderType)
            parameters.append(category)
            let id = UserDefaults.standard.string(forKey: "merchant_id")
            parameters.append(id!)
            break
        case 3:
            parameters.append(orderSource)
            let id = UserDefaults.standard.string(forKey: "merchant_id")
            parameters.append(id!)
            break
        case 4:
            parameters.append(orderSource)
            parameters.append(orderType)
            let id = UserDefaults.standard.string(forKey: "merchant_id")
            parameters.append(id!)
            break
        default:
            break
        }
        return parameters
    }
}
