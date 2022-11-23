//
//  WeatherLocation.swift
//  weatherGift
//
//  Created by Matthew  Sustaita on 11/19/22.
//

import Foundation

class WeatherLocation: Codable {
    var name: String
    var lattitude: Double
    var longitude: Double
    
    
    
    init (name:String, lattitude: Double, longitude: Double){
        self.name = name
        self.lattitude = lattitude
        self.longitude = longitude
    }
    
    func getData(){
        let urlString = "https://api.openweathermap.org/data/3.0/onecall?lat=\(lattitude)&lon=\(longitude)&exclude=minutely&units=imperial&appid=\(APIkeys.openWeatherKey)"
        
        //create URL
        guard let url = URL(string: urlString) else {
            print("error could not create URL STRING")
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
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print("JSON WORKS! \(json)")
            } catch {
                print("oh no..JSON..")
            }
        }
        task.resume()
    }
    
}
