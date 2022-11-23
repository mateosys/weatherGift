//
//  weatherDetail.swift
//  weatherGift
//
//  Created by Matthew  Sustaita on 11/22/22.
//

import Foundation

//creating a subclass
class WeatherDetail: WeatherLocation {
    
    struct Result: Codable {
        var timezone: String
        var current: Current
    }
    
    struct Current: Codable {
        var dt: TimeInterval
        var temp: Double
        var weather: [Weather]
    }
    
    struct Weather: Codable {
        var description: String
        var icon: String
        
    }
    
    var timezone = ""
    var CurrentTime = 0.0
    var temperature = 0
    var summary = ""
    var dailyIcon = ""
    
    func getData(completed: @escaping() -> ()){
        let urlString = "https://api.openweathermap.org/data/3.0/onecall?lat=\(lattitude)&lon=\(longitude)&exclude=minutely&units=imperial&appid=\(APIkeys.openWeatherKey)"
        
        //create URL
        guard let url = URL(string: urlString) else {
            print("error could not create URL STRING")
            completed()
            return
        }
        
        
        //create session
        let session = URLSession.shared
        
        
        //get data with .datatask method
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print ("error")
            }
            
            
            //deal with data
            do {
               // let json = try JSONSerialization.jsonObject(with: data!, options: [])
                let result = try JSONDecoder().decode(Result.self, from: data!)
                print("JSON WORKS! \(result)")
                print("JSON WORKS! \(result.timezone)")
                self.timezone = result.timezone
                self.CurrentTime = result.current.dt
                self.temperature = Int(result.current.temp.rounded())
                self.summary = result.current.weather[0].description
                self.dailyIcon = self.fileNameForIcon(icon: result.current.weather[0].icon)
            } catch {
                print("oh no..JSON..")
            }
            completed()
        }
        task.resume()
    }
    private func fileNameForIcon(icon: String) -> String {
        var newFileName = ""
        switch icon {
        case "01d":
                newFileName = "clear-day"
        case "01n":
                newFileName = "clear-night"
        case "02d":
                newFileName = "partly-cloudy-night"
        case "02n":
                newFileName = "partly-cloudy-night"
        case "03d", "03n", "04d", "04n":
                newFileName = "cloudy"
        case "09d", "09n", "10d", "10n":
                newFileName = "rain"
        case "11d", "11n":
                newFileName = "thunderstorm"
        case "13d", "13m":
                newFileName = "snow"
        case "50d", "50n":
                newFileName = "fog"
       
        default:
            newFileName = ""
        }
        return newFileName
    }
}
