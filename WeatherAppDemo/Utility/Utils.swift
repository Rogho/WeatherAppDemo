//
//  Utils.swift
//  WeatherAppDemo
//
//  Created by Rohan Ghorpade on 11/02/21.
//

import Foundation

class Utility {
   class func getCurrentTime() -> String{
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "dd-MM-yy"
        let date1 = dateFormatter.string(from: date)
        return date1 + "  " + time
    }
}
