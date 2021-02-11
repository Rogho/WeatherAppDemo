//
//  ViewController.swift
//  WeatherAppDemo
//
//  Created by Rohan Ghorpade on 11/02/21.
//

import UIKit
import DropDown

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var citiesTableView: UITableView!
    @IBOutlet weak var citySearchBar: UISearchBar!
    let dropDown = DropDown()
    var cityNameArr = [String]()
    var weather = DatabaseHelper.instance.fetchData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        citySearchBar.delegate = self
        self.checkTimerAndFetchData()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: Check timer manually and refresh tableview
    @IBAction func refreshTableViewTapped(_ sender: Any) {
        self.checkTimerAndFetchData()
    }
   
    
    //MARK:- Check time and delete data from CoreData
    func checkTimerAndFetchData(){
        self.cityNameArr = weather.map{($0.cityName ?? "")}
        if let MinPassed = UserDefaults.standard.value(forKey: "timerSet"){
            let diffInMins = (Calendar.current.dateComponents([.minute], from: MinPassed as! Date, to: Date()).minute)!
            print(diffInMins,"////////////////////////")
            if diffInMins > 1 {
                DatabaseHelper.instance.deleteAll()
                self.weather = DatabaseHelper.instance.fetchData()
                self.citiesTableView.reloadData()
                UserDefaults.standard.setValue(Date(), forKey: "timerSet")
            }
        } else {
            UserDefaults.standard.setValue(Date(), forKey: "timerSet")
        }
    }
    
    
    //MARK:- TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if weather.count == 0{
            return UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cityInfoCell") as! CityCell
            cell.cityName.text =  weather[indexPath.row].cityName
            cell.timeZone?.text = "\(weather[indexPath.row].timeZone ?? "" )"
            cell.weather.text = "\(String(describing: weather[indexPath.row].weather))" + " Kelvin"
            
            return cell
        }
    }
    
    
    //MARK:- UISearchbar Methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0{
            dropDown.hide()
        } else {
            let tempCityArr = cityNameArr.filter({(item: String) -> Bool in
                
                let stringMatch = item.lowercased().range(of:searchText.lowercased())
                return stringMatch != nil ? true : false
            })
            dropDown.dataSource = tempCityArr
            dropDown.anchorView = self.citySearchBar
            dropDown.bottomOffset = CGPoint(x: 0, y: self.citySearchBar.frame.size.height)
            dropDown.show()
            dropDown.selectionAction = { [weak self] (index: Int, item: String) in
                guard let _ = self else { return }
                self!.citySearchBar.text = item
            }
        }
    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        FetchWeatherDetailsService.instance.fetchCityWeather(cityName: searchBar.text ?? ""){err,data in
            print(data,"/////////////////")
            if let errorCode = data?.value(forKey: "cod") as? Int{
                if errorCode == 200{
                    let weatherObj = CityWeather(cityName: FetchWeatherDetailsService.instance.cityWeather.cityName!, timeZone: Utility.getCurrentTime(), weather: FetchWeatherDetailsService.instance.cityWeather.weather!)
                    let tempCityNameArr = self.weather.map{$0.cityName}
                    
                    if tempCityNameArr.contains("\(FetchWeatherDetailsService.instance.cityWeather.cityName!)") {
                        
                    } else {
                        DatabaseHelper.instance.saveData(object: weatherObj)
                        self.weather = DatabaseHelper.instance.fetchData()
                        self.citiesTableView.reloadData()
                    }
                }
            }
            else {
                let alert = UIAlertController(title: "Alert!", message: "City not found.", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.citySearchBar.endEditing(true)
    }
}

