//
//  functions.swift
//  Pintrest
//
//  Created by User on 14/01/22.
//

import Foundation

func convertDate(date: String) -> String {
    
    let dateString = date.replacingOccurrences(of: "\\.\\d+", with: "", options: .regularExpression)
    let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "ru_Ru")
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    let jdate = dateFormatter.date(from: dateString) ?? Date()
        dateFormatter.dateFormat = "d MMM yyyy | HH:mm"
        dateFormatter.locale = Locale(identifier: "ru_Ru")
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
    let timeStamp = dateFormatter.string(from: jdate)
    
    return timeStamp
    
}
