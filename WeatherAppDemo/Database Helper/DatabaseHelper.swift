//
//  DatabaseHelper.swift
//  WeatherAppDemo
//
//  Created by Rohan Ghorpade on 11/02/21.
//

import Foundation
import CoreData
import UIKit

class DatabaseHelper{
    static var instance = DatabaseHelper()
    
    let context = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
    
    //MARK:- Save data to CoreData
    func saveData(object: CityWeather) {
        let cityWeather = NSEntityDescription.insertNewObject(forEntityName: "City", into: context) as! City
        
        cityWeather.cityName = object.cityName
        cityWeather.timeZone = object.timeZone
        cityWeather.weather = object.weather
        
        do{
            try context.save()
        }
        catch{
            debugPrint("Error Occured")
        }
        
    }
    
    //MARK:- Delete Data from CoreData
    func deleteAll() {
        
        _ = NSFetchRequest<NSManagedObject>(entityName: "City")
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try context.execute(deleteRequest)
            try context.save()
        }
        catch
        {
            debugPrint("Some Error Occured")
        }
    }
    
    //MARK: Fetch Data from CoreData
    func fetchData() -> [City]{
        var weather = [City]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "City")
        
        do {
            weather = try context.fetch(fetchRequest) as! [City]
        }catch{
            debugPrint("Some Error Occured")
        }
        return weather
    }
}
