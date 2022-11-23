//
//  weatherDetail.swift
//  weatherGift
//
//  Created by Matthew  Sustaita on 11/22/22.
//

import Foundation


private let dateFormatter: DateFormatter = {
    print("i just created a date formatter! in weatherdetail.swift")
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, "
    return dateFormatter
}()

struct DailyWeather {
    var dailyIcon: String
    var dailyWeekday: String
    var dailySummary: String
    var dailyHigh: Int
    var dailyLow: Int
}

//creating a subclass
class WeatherDetail: WeatherLocation {
    
    struct Result: Codable {
        var timezone: String
        var current: Current
        var daily: [Daily]
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
    struct Daily: Codable {
        var dt: TimeInterval
        var temp: Temp
        var weather: [Weather]
    }
    struct Temp: Codable {
        var max: Double
        var min: Double
    }
    var timezone = ""
    var CurrentTime = 0.0
    var temperature = 0
    var summary = ""
    var dayIcon = ""
    var dailyWeatherData: [DailyWeather] = []

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
                self.timezone = result.timezone
                self.CurrentTime = result.current.dt
                self.temperature = Int(result.current.temp.rounded())
                self.summary = result.current.weather[0].description
                self.dayIcon = self.fileNameForIcon(icon: result.current.weather[0].icon)
                for index in 0..<result.daily.count {
                    let weekdayDate = Date(timeIntervalSince1970: result.daily[index].dt)
                    dateFormatter.timeZone = TimeZone(identifier: result.timezone)
                    let dailyWeekday = dateFormatter.string(from: weekdayDate)
                    let dailyIcon = self.fileNameForIcon(icon: result.daily[index].weather[0].icon)
                    let dailySummary = result.daily[index].weather[0].description
                    let dailyHigh = Int(result.daily[index].temp.max.rounded())
                    let dailyLow = Int(result.daily[index].temp.max.rounded())
                    let dailyWeather = DailyWeather(dailyIcon: dailyIcon, dailyWeekday: dailyWeekday, dailySummary: dailySummary, dailyHigh: dailyHigh, dailyLow: dailyLow)
                    self.dailyWeatherData.append(dailyWeather)
                    print("day: \(dailyWeekday), High: \(dailyHigh), Low: \(dailyLow)")
                }
            } catch {
                print("JSON isn't WORKING!.")
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
