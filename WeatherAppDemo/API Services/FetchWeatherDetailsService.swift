//
//  FetchWeatherDetailsService.swift
//  WeatherAppDemo
//
//  Created by Rohan Ghorpade on 11/02/21.
//

import Foundation
import Alamofire


class FetchWeatherDetailsService {
    static var instance = FetchWeatherDetailsService()
    
    
    private var sessionManager = Alamofire.Session()
    typealias CompletionHandler = (_ Success: Bool, _ response: NSDictionary?) -> ()
    var cityWeather = CityWeather()
    
    func fetchCityWeather(cityName: String, completionHandler: @escaping CompletionHandler) {
      //  let city = cityName.trimmingCharacters(in: .whitespaces)
        let city = cityName.replacingOccurrences(of: " ", with: "_")
        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=094aa776d64c50d5b9e9043edd4ffd00")!
    
    // 8b1bf33626d544efc1ae4716bb907ed3
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 100
        

        self.sessionManager.request(url, method: .get, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                   // if let result = response.result {
                        let JSON = value as! NSDictionary
                    if let cityName = JSON.value(forKey: "name") as? String{
                        if let timezone = JSON.value(forKey: "timezone") as? Double{
                            if let main = JSON.value(forKey: "main") as? NSDictionary{
                                if let temp = main.value(forKey: "temp") as? Double{
                                    let cityWeatherData = CityWeather(cityName: cityName, timeZone: "", weather: temp)
                                    self.cityWeather = cityWeatherData
                                }
                            }
                        }
                    }
                       
                    completionHandler(true, JSON)
                    
                case .failure( let error ):
                    if error._code == NSURLErrorTimedOut {
                    }
                    if let errorCode = response.response?.statusCode , errorCode == 401 {
                        completionHandler(false, nil)
                        return
                    }
                    completionHandler(false, nil)
                }
        }
    
        
      }
}
